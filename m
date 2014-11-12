Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53586 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaKLKk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 05:40:59 -0500
Message-ID: <54633939.6000400@broadcom.com> (sfid-20141112_114105_296106_C65C5580)
Date: Wed, 12 Nov 2014 11:40:57 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac not working on ECS LIVA
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>	<545F4611.3010207@broadcom.com> <CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com>
In-Reply-To: <CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-11-14 23:32, Felipe Contreras wrote:
> On Sun, Nov 9, 2014 at 4:46 AM, Arend van Spriel <arend@broadcom.com> wrote:
> 
>> Could you share the nvram obtained from EFI? Also please create a kernel log
>> with debug=0xd416.
> 
> There you go:
> http://people.freedesktop.org/~felipec/dmesg-brcm.txt
> 

It is using the sdhci-acpi driver for the sdio host controller. If I am
not mistaken that one does runtime-pm. This has caused issues with our
device. This is what happens:

1. driver sends control message and waits for firmware response.
 2. runtime pm kicks in and suspends host controller.
  3. host controller suspend disable sdio clock.
   4. host controller does not detect firmware interrupt for response.
    5. control message times out.

You can disable it through sysfs, but the patch below may do it.

Regards,
Arend

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
b/drivers/net/wire
index f754ffc..d231e65 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -27,6 +27,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
+#include <linux/pm_runtime.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/brcmfmac-sdio.h>
 #include <linux/suspend.h>
@@ -976,6 +977,12 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev
*sdiodev
                                           SG_MAX_SINGLE_ALLOC);
        sdiodev->max_segment_size = host->max_seg_size;

+       /*
+        * Several issues with the driver seem to occur when the SDIO host
+        * is using runtime-pm. Prevent host from doing runtime-pm here.
+        */
+       __pm_runtime_use_autosuspend(&host->class_dev, false);
+
        /* allocate scatter-gather table. sg support
         * will be disabled upon allocation failure.
         */

