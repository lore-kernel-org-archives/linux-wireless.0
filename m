Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34564 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdIAUCv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 16:02:51 -0400
Received: by mail-wm0-f45.google.com with SMTP id 137so2730270wmj.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Sep 2017 13:02:50 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Correctly fail to suspend when SDIO does not
 support power on suspend
To: Eric Bentley <Eric.Bentley@lairdtech.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Steve deRosier <derosier@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <eacde476-6130-6ab1-ea09-ceb2d3a58aaa@broadcom.com> (sfid-20170901_220255_860314_117184D7)
Date: Fri, 1 Sep 2017 22:02:48 +0200
MIME-Version: 1.0
In-Reply-To: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-09-17 15:00, Eric Bentley wrote:
> Return error when failing to set power management capabilities flag.  This will
> cause the suspend to fail but the radio will continue to operate.  Allowing this
> to fail without reporting error will cause the radio to be non-functional on
> resume as it will have lost power.

There is more to this story to tell. Initially, the suspend callback did 
return an error upon failing to set the flags. This was dropped by 
commit 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.") as 
it set the flags only for wowl and that wowl would only be enabled if 
the host supports the capability flags:

+#ifdef CONFIG_PM_SLEEP
+       /* wowl can be supported when KEEP_POWER is true and (WAKE_SDIO_IRQ
+        * is true or when platform data OOB irq is true).
+        */
+       if ((sdio_get_host_pm_caps(sdiodev->func[1]) & MMC_PM_KEEP_POWER) &&
+           ((sdio_get_host_pm_caps(sdiodev->func[1]) & 
MMC_PM_WAKE_SDIO_IRQ) ||
+            (sdiodev->pdata->oob_irq_supported)))
+               bus_if->wowl_supported = true;
+#endif

However, MMC_PM_KEEP_POWER is also needed for the non-wowl case. I 
restored that in commit bdf1340cf20f ("brcmfmac: fix sdio suspend and 
resume"), but overlooked the error code return also needed to be restored.

Also note that the wifi chip (the term "radio" does not quite cover it) 
has not really lost power. It is quite common that it is not powered 
through the SDIO bus. With the power-sequence support in the MMC stack 
these days the suspend may result in loss of power. Otherwise, it is 
just the bus that loses power (and clock) and the flags affect what 
tricks the MMC stack tries to pull to get the device accessible again 
upon resume.

Maybe you can incorporate some of this in the commit message, but you 
should at least add:

Fixes: 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
Fixes: bdf1340cf20f ("brcmfmac: fix sdio suspend and resume")
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Eric Bentley eric.bentley@lairdtech.com
> ---
> v2: corrected errant ( with {
> ---
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
