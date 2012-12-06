Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41528 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2LFDrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 22:47:40 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so249199qaq.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 19:47:39 -0800 (PST)
Message-ID: <50C01558.8050102@lwfinger.net> (sfid-20121206_044746_039392_220627F1)
Date: Wed, 05 Dec 2012 21:47:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Janda <felix.janda@posteo.de>
Subject: [RFC/RFT] b43: Load initial firmware file asynchronously
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent versions of udev cause synchronous firmware loading from the
probe routine to fail because the request to user space would time
out. The original fix for b43 (commit 6b6fa58) moved the firmware
from the probe routine to a work queue, but it still used synchronous
firmware loading. This method is OK when b43 is built as a module;
however, it fails when the driver is compiled into the kernel.

This version changes the code to load the initial firmware file
using request_firmware_nowait(). A completion event is used to
hold the work queue until that file is available. This driver
reads several firmware files - the remainder can be read synchronously.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Felix,

Please test this with b43 built into the kernel.

Thanks,

Larry
---

Index: wireless-testing-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing-new/drivers/net/wireless/b43/b43.h
@@ -7,6 +7,7 @@
  #include <linux/hw_random.h>
  #include <linux/bcma/bcma.h>
  #include <linux/ssb/ssb.h>
+#include <linux/completion.h>
  #include <net/mac80211.h>

  #include "debugfs.h"
@@ -722,6 +723,10 @@ enum b43_firmware_file_type {
  struct b43_request_fw_context {
  	/* The device we are requesting the fw for. */
  	struct b43_wldev *dev;
+	/* a completion event structure needed if this call is asynchronous */
+	struct completion fw_load_complete;
+	/* a pointer to the firmware object */
+	const struct firmware *blob;
  	/* The type of firmware to request. */
  	enum b43_firmware_file_type req_type;
  	/* Error messages for each firmware type. */
Index: wireless-testing-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing-new/drivers/net/wireless/b43/main.c
@@ -2088,11 +2088,20 @@ static void b43_print_fw_helptext(struct
  		b43warn(wl, text);
  }

+static void b43_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct b43_request_fw_context *ctx = context;
+
+	ctx->blob = firmware;
+	if (!firmware)
+		pr_err("In callback routine, firmware not available\n");
+	complete(&ctx->fw_load_complete);
+}
+
  int b43_do_request_fw(struct b43_request_fw_context *ctx,
  		      const char *name,
-		      struct b43_firmware_file *fw)
+		      struct b43_firmware_file *fw, bool async)
  {
-	const struct firmware *blob;
  	struct b43_fw_header *hdr;
  	u32 size;
  	int err;
@@ -2131,27 +2140,43 @@ int b43_do_request_fw(struct b43_request
  		B43_WARN_ON(1);
  		return -ENOSYS;
  	}
-	err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);
-	if (err == -ENOENT) {
-		snprintf(ctx->errors[ctx->req_type],
-			 sizeof(ctx->errors[ctx->req_type]),
-			 "Firmware file \"%s\" not found\n", ctx->fwname);
-		return err;
-	} else if (err) {
-		snprintf(ctx->errors[ctx->req_type],
-			 sizeof(ctx->errors[ctx->req_type]),
-			 "Firmware file \"%s\" request failed (err=%d)\n",
-			 ctx->fwname, err);
-		return err;
+	if (async) {
+		/* do this part asynchronously */
+		init_completion(&ctx->fw_load_complete);
+		err = request_firmware_nowait(THIS_MODULE, 1, ctx->fwname,
+					      ctx->dev->dev->dev, GFP_KERNEL,
+					      ctx, b43_fw_cb);
+		if (err < 0) {
+			pr_err("Unable to load firmware\n");
+			return err;
+		}
+		/* stall here until fw ready */
+		wait_for_completion(&ctx->fw_load_complete);
+	} else {
+		err = request_firmware(&ctx->blob, ctx->fwname,
+				       ctx->dev->dev->dev);
+		if (err == -ENOENT) {
+			snprintf(ctx->errors[ctx->req_type],
+				 sizeof(ctx->errors[ctx->req_type]),
+				 "Firmware file \"%s\" not found\n",
+				 ctx->fwname);
+			return err;
+		} else if (err) {
+			snprintf(ctx->errors[ctx->req_type],
+				 sizeof(ctx->errors[ctx->req_type]),
+				 "Firmware file \"%s\" request failed (err=%d)\n",
+				 ctx->fwname, err);
+			return err;
+		}
  	}
-	if (blob->size < sizeof(struct b43_fw_header))
+	if (ctx->blob->size < sizeof(struct b43_fw_header))
  		goto err_format;
-	hdr = (struct b43_fw_header *)(blob->data);
+	hdr = (struct b43_fw_header *)(ctx->blob->data);
  	switch (hdr->type) {
  	case B43_FW_TYPE_UCODE:
  	case B43_FW_TYPE_PCM:
  		size = be32_to_cpu(hdr->size);
-		if (size != blob->size - sizeof(struct b43_fw_header))
+		if (size != ctx->blob->size - sizeof(struct b43_fw_header))
  			goto err_format;
  		/* fallthrough */
  	case B43_FW_TYPE_IV:
@@ -2162,7 +2187,7 @@ int b43_do_request_fw(struct b43_request
  		goto err_format;
  	}

-	fw->data = blob;
+	fw->data = ctx->blob;
  	fw->filename = name;
  	fw->type = ctx->req_type;

@@ -2172,7 +2197,7 @@ err_format:
  	snprintf(ctx->errors[ctx->req_type],
  		 sizeof(ctx->errors[ctx->req_type]),
  		 "Firmware file \"%s\" format error.\n", ctx->fwname);
-	release_firmware(blob);
+	release_firmware(ctx->blob);

  	return -EPROTO;
  }
@@ -2223,7 +2248,7 @@ static int b43_try_request_fw(struct b43
  			goto err_no_ucode;
  		}
  	}
-	err = b43_do_request_fw(ctx, filename, &fw->ucode);
+	err = b43_do_request_fw(ctx, filename, &fw->ucode, true);
  	if (err)
  		goto err_load;

@@ -2235,7 +2260,7 @@ static int b43_try_request_fw(struct b43
  	else
  		goto err_no_pcm;
  	fw->pcm_request_failed = false;
-	err = b43_do_request_fw(ctx, filename, &fw->pcm);
+	err = b43_do_request_fw(ctx, filename, &fw->pcm, false);
  	if (err == -ENOENT) {
  		/* We did not find a PCM file? Not fatal, but
  		 * core rev <= 10 must do without hwcrypto then. */
@@ -2296,7 +2321,7 @@ static int b43_try_request_fw(struct b43
  	default:
  		goto err_no_initvals;
  	}
-	err = b43_do_request_fw(ctx, filename, &fw->initvals);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals, false);
  	if (err)
  		goto err_load;

@@ -2355,7 +2380,7 @@ static int b43_try_request_fw(struct b43
  	default:
  		goto err_no_initvals;
  	}
-	err = b43_do_request_fw(ctx, filename, &fw->initvals_band);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals_band, false);
  	if (err)
  		goto err_load;

Index: wireless-testing-new/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/main.h
+++ wireless-testing-new/drivers/net/wireless/b43/main.h
@@ -137,9 +137,8 @@ void b43_mac_phy_clock_set(struct b43_wl


  struct b43_request_fw_context;
-int b43_do_request_fw(struct b43_request_fw_context *ctx,
-		      const char *name,
-		      struct b43_firmware_file *fw);
+int b43_do_request_fw(struct b43_request_fw_context *ctx, const char *name,
+		      struct b43_firmware_file *fw, bool async);
  void b43_do_release_fw(struct b43_firmware_file *fw);

  #endif /* B43_MAIN_H_ */

