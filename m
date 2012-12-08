Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39374 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964986Ab2LHRPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 12:15:46 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so420889qad.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2012 09:15:45 -0800 (PST)
Message-ID: <50C375BE.9050907@lwfinger.net> (sfid-20121208_181600_583115_741DC6F4)
Date: Sat, 08 Dec 2012 11:15:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Janda <felix.janda@posteo.de>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Load initial firmware file asynchronously
References: <50C01558.8050102@lwfinger.net> <20121208143032.GA1903@gauss>
In-Reply-To: <20121208143032.GA1903@gauss>
Content-Type: multipart/mixed;
 boundary="------------000000060409050603070104"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000000060409050603070104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/08/2012 08:30 AM, Felix Janda wrote:
> Thanks, for coming back to this.
>
> It now gives me a kernel panic after 30 seconds.
>
> I did some debugging using ssleep and printk. b43_fw_cb seems
> to be called several times and on the last time the "firmware"
> argument seems to be zero. The execution then returns to
> b43_do_request_fw, which tries to deference a zero pointer in
> the line
>
>> +	if (ctx->blob->size < sizeof(struct b43_fw_header))
>
>
> It is another machine then last time, has B4306 (rev 3) and a
> kernel without modules. The firmware is in /lib/firmware/b43,
> which is on the root partition. There is no udev installed.

Felix,

Curious. I would have expected a single call to b43_do_request_fw() with the 
async flag set, and thus a single call to the callback routine.

Attached is a new version of the patch. It will give us some instrumentation on 
the calls, and it should prevent the crash. I would like to see the dmesg output 
showing the info.

Thanks for testing,

Larry


--------------000000060409050603070104
Content-Type: text/plain; charset=UTF-8;
 name="b43_async_firmware"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="b43_async_firmware"

Recent versions of udev cause synchronous firmware loading from the
probe routine to fail because the request to user space would time
out. The original fix for b43 (commit 6b6fa58) moved the firmware
load from the probe routine to a work queue, but it still used synchronous
firmware loading. This method is OK when b43 is built as a module;
however, it fails when the driver is compiled into the kernel.

This version changes the code to load the initial firmware file
using request_firmware_nowait(). A completion event is used to
hold the work queue until that file is available. This driver
reads several firmware files - the remainder can be read synchronourly.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>  (V3.4+)
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
@@ -2088,11 +2088,21 @@ static void b43_print_fw_helptext(struct
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
+	dump_stack();
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
@@ -2131,27 +2141,48 @@ int b43_do_request_fw(struct b43_request
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
+		pr_info("async load of %s\n", ctx->fwname);
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
+		if (!ctx->blob) {
+			pr_err("Firmware not found\n");
+			return -ENOENT;
+		}
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
@@ -2162,7 +2193,7 @@ int b43_do_request_fw(struct b43_request
 		goto err_format;
 	}
 
-	fw->data = blob;
+	fw->data = ctx->blob;
 	fw->filename = name;
 	fw->type = ctx->req_type;
 
@@ -2172,7 +2203,7 @@ err_format:
 	snprintf(ctx->errors[ctx->req_type],
 		 sizeof(ctx->errors[ctx->req_type]),
 		 "Firmware file \"%s\" format error.\n", ctx->fwname);
-	release_firmware(blob);
+	release_firmware(ctx->blob);
 
 	return -EPROTO;
 }
@@ -2223,7 +2254,7 @@ static int b43_try_request_fw(struct b43
 			goto err_no_ucode;
 		}
 	}
-	err = b43_do_request_fw(ctx, filename, &fw->ucode);
+	err = b43_do_request_fw(ctx, filename, &fw->ucode, true);
 	if (err)
 		goto err_load;
 
@@ -2235,7 +2266,7 @@ static int b43_try_request_fw(struct b43
 	else
 		goto err_no_pcm;
 	fw->pcm_request_failed = false;
-	err = b43_do_request_fw(ctx, filename, &fw->pcm);
+	err = b43_do_request_fw(ctx, filename, &fw->pcm, false);
 	if (err == -ENOENT) {
 		/* We did not find a PCM file? Not fatal, but
 		 * core rev <= 10 must do without hwcrypto then. */
@@ -2296,7 +2327,7 @@ static int b43_try_request_fw(struct b43
 	default:
 		goto err_no_initvals;
 	}
-	err = b43_do_request_fw(ctx, filename, &fw->initvals);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals, false);
 	if (err)
 		goto err_load;
 
@@ -2355,7 +2386,7 @@ static int b43_try_request_fw(struct b43
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

--------------000000060409050603070104--
