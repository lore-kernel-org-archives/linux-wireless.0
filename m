Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34686 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbeAJIrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 03:47:37 -0500
Received: by mail-wr0-f180.google.com with SMTP id 36so16608445wrh.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 00:47:36 -0800 (PST)
Subject: Re: brcmfmac4329-sdio firmware load failed.
To: Kyle Evans <kvans32@gmail.com>, linux-wireless@vger.kernel.org
References: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A55D325.60805@broadcom.com> (sfid-20180110_094741_078929_7086CE1F)
Date: Wed, 10 Jan 2018 09:47:33 +0100
MIME-Version: 1.0
In-Reply-To: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/9/2018 1:51 PM, Kyle Evans wrote:
> This is linux-4.15-rc2 on an ASUS TF101. This device was shipped with
> Android and a custom kernel using bcmdhd. I have taken nvram.txt from
> /system/etc/ on the stock filesystem and copied to
> /lib/firmware/brcm/brcmfmac4329-sdio.txt. Below is the result.

Ok. So far so good as that nvram.txt is indeed what you want to use.
> [    2.729157] brcmfmac: F1 signature read @0x18000000=0x9934329
> [    2.734313] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data
> F1@0x080ac, err: -84

The read failure is a bit concerning, but I ignore it for now.

> [    2.739952] brcmfmac: brcmf_fw_map_chip_to_name: using
> brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
> [    2.965820] brcmfmac mmc0:0001:1: Direct firmware load for
> brcm/brcmfmac4329-sdio.clm_blob failed with error -2

Expected as you did not put a clm_blob file in /lib/firmware/brcm/. 
However, ...

> [    2.969658] brcmfmac mmc0:0001:1: Falling back to user helper
> [   64.489695] brcmfmac: brcmf_c_process_clm_blob: request CLM blob file
> failed (-11)

...in one of the review cycles for the CLM blob feature it was made 
clear that this should not result in a probe failure...

> [   64.489720] brcmfmac: brcmf_c_preinit_dcmds: download CLM blob file
> failed, -11
> [   64.489739] brcmfmac: brcmf_bus_started: failed: -11

... but it does bail out. Turns out the driver is checking for a 
specific error code -ENOENT (-2) and not -EAGAIN(-11). A patch has been 
submitted for it earlier [1], but it was rejected. I have taken another 
stab at it (see below). Let me know if it works for you.

> [   64.489783] brcmfmac: brcmf_sdio_firmware_callback: dongle is not
> responding
> [   64.596281] [<c061fd98>] (device_release_driver_internal) from
> [<c068f394>] (brcmf_sdio_firmware_callback+0x244/0x5b8)
> [   64.596500] [<c068f394>] (brcmf_sdio_firmware_callback) from
> [<c0686870>] (brcmf_fw_request_nvram_done+0x1cc/0x73c)
> [   64.596716] [<c0686870>] (brcmf_fw_request_nvram_done) from
> [<c063337c>] (request_firmware_work_func+0x3c/0x64)

This stack trace is from a driver bug that has been fixed in later -rc [2].

Regards,
Arend

[1] https://patchwork.kernel.org/patch/10106571/
[2] https://patchwork.kernel.org/patch/10075091/

---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c 
b/driver
index 6a59d06..f805600 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -182,12 +182,8 @@ static int brcmf_c_process_clm_blob(struct brcmf_if 
*ifp)

         err = request_firmware(&clm, clm_name, dev);
         if (err) {
-               if (err == -ENOENT) {
-                       brcmf_dbg(INFO, "continue with CLM data 
currently prese
-                       return 0;
-               }
-               brcmf_err("request CLM blob file failed (%d)\n", err);
-               return err;
+               brcmf_info("no CLM blob. Firmware may still need it.\n");
+               return 0;
         }

         chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, 
GFP_KERNEL)
