Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab2LGDzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 22:55:24 -0500
Date: Thu, 06 Dec 2012 21:55:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix firmware loading when driver is built into the kernel
Message-ID: <50c168a4.SH1v4TIX8libpU3B%Larry.Finger@lwfinger.net> (sfid-20121207_045528_722074_2BCF27D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent versions of udev cause synchronous firmware loading from the
probe routine to fail because the request to user space times out.
The original fix for b43legacy (commit a3ea2c7) moved the firmware
load from the probe routine to a work queue, but it still used synchronous
firmware loading. This method is OK when b43legacy is built as a module;
however, it fails when the driver is compiled into the kernel.

This version changes the code to load the initial firmware file
using request_firmware_nowait(). A completion event is used to
hold the work queue until that file is available. The remaining
firmware files are read synchronously.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>  (V3.4+)
---

John,

This patch is for 3.8. I have marked it for Stable, but I'm not
that committed to having it backported for the reason that not
many people build this driver into the kernel - it usually is a
module. I will let you decide whether to keep that line in when
you merge it.

Thanks,

Larry
---

 b43legacy.h |    5 +++++
 main.c      |   37 +++++++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 6 deletions(-)

Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -13,6 +13,7 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_driver_chipcommon.h>
+#include <linux/completion.h>
 
 #include <net/mac80211.h>
 
@@ -733,6 +734,10 @@ struct b43legacy_wldev {
 
 	/* Firmware data */
 	struct b43legacy_firmware fw;
+	const struct firmware *fwp;	/* needed to pass fw pointer */
+
+	/* completion struct for firmware loading */
+	struct completion fw_load_complete;
 
 	/* Devicelist in struct b43legacy_wl (all 802.11 cores) */
 	struct list_head list;
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -1513,9 +1513,17 @@ static void b43legacy_print_fw_helptext(
 		     "and download the correct firmware (version 3).\n");
 }
 
+static void b43legacy_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct b43legacy_wldev *dev = context;
+
+	dev->fwp = firmware;
+	complete(&dev->fw_load_complete);
+}
+
 static int do_request_fw(struct b43legacy_wldev *dev,
 			 const char *name,
-			 const struct firmware **fw)
+			 const struct firmware **fw, bool async)
 {
 	char path[sizeof(modparam_fwpostfix) + 32];
 	struct b43legacy_fw_header *hdr;
@@ -1528,7 +1536,24 @@ static int do_request_fw(struct b43legac
 	snprintf(path, ARRAY_SIZE(path),
 		 "b43legacy%s/%s.fw",
 		 modparam_fwpostfix, name);
-	err = request_firmware(fw, path, dev->dev->dev);
+	b43legacyinfo(dev->wl, "Loading firmware %s\n", path);
+	if (async) {
+		init_completion(&dev->fw_load_complete);
+		err = request_firmware_nowait(THIS_MODULE, 1, path,
+					      dev->dev->dev, GFP_KERNEL,
+					      dev, b43legacy_fw_cb);
+		if (err) {
+			b43legacyerr(dev->wl, "Unable to load firmware\n");
+			return err;
+		}
+		/* stall here until fw ready */
+		wait_for_completion(&dev->fw_load_complete);
+		if (!dev->fwp)
+			err = -EINVAL;
+		*fw = dev->fwp;
+	} else {
+		err = request_firmware(fw, path, dev->dev->dev);
+	}
 	if (err) {
 		b43legacyerr(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
@@ -1580,7 +1605,7 @@ static void b43legacy_request_firmware(s
 			filename = "ucode4";
 		else
 			filename = "ucode5";
-		err = do_request_fw(dev, filename, &fw->ucode);
+		err = do_request_fw(dev, filename, &fw->ucode, true);
 		if (err)
 			goto err_load;
 	}
@@ -1589,7 +1614,7 @@ static void b43legacy_request_firmware(s
 			filename = "pcm4";
 		else
 			filename = "pcm5";
-		err = do_request_fw(dev, filename, &fw->pcm);
+		err = do_request_fw(dev, filename, &fw->pcm, false);
 		if (err)
 			goto err_load;
 	}
@@ -1607,7 +1632,7 @@ static void b43legacy_request_firmware(s
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals);
+		err = do_request_fw(dev, filename, &fw->initvals, false);
 		if (err)
 			goto err_load;
 	}
@@ -1627,7 +1652,7 @@ static void b43legacy_request_firmware(s
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals_band);
+		err = do_request_fw(dev, filename, &fw->initvals_band, false);
 		if (err)
 			goto err_load;
 	}
