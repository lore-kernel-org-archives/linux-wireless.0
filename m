Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23203 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3FQQTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 12:19:05 -0400
Date: Mon, 17 Jun 2013 12:19:03 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: rvossen@broadcom.com, arend@broadcom.com, frankyl@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] net: brcmfmac: add sdio chip id 0x4319
Message-ID: <20130617161903.GN31667@titan.lakedaemon.net> (sfid-20130617_181913_945217_40802830)
References: <20130612222123.GB31667@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130612222123.GB31667@titan.lakedaemon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added Franky...

On Wed, Jun 12, 2013 at 06:21:23PM -0400, Jason Cooper wrote:
> All,
> 
> I have a Seagate Wireless Plus I am trying to put a vanilla kernel on
> (currently v3.10-rc5 for various omap DT bits).
> 
> I have the board booting and running a debian rootfs on the HD.  I just
> got mmc to come up and I've discovered that the wireless card is vendor
> 0x02d0, device 0x4319.
> 
> My hope, once I got to this point, was that I would be able to use
> the mainline, open source driver.  Unfortunately, it looks like brcmfmac
> lost support for the 0x4319 while it was in staging.
> 
> The commit in question is:
> 
>   4dad253 staging: brcm80211: remove code for unsupported chip
> 
> Is adding it back in a bridge too far?

It looks like only two things are needed, adding the chip id and then
setting the addresses.  Here's a preliminary patch to do just that.
Note, the addresses I have used are a straight copy from the 4329.  It
causes this:

[   12.346466] mmcblk mmc0:0001: no of_node; not parsing pinctrl DT
[   12.353149] brcmfmac_sdio mmc0:0001:1: no of_node; not parsing pinctrl DT
[   12.360717] brcmfmac_sdio mmc0:0001:2: no of_node; not parsing pinctrl DT
[   12.368804] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength init done for chip 4319 rev 1 pmurev 7
[   12.380462] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
[   12.391906] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
[   12.403289] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
[   12.412261] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
[   12.418457] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
[   12.429718] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
[   12.441101] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
[   12.450073] brcmfmac: brcmf_sdio_regrw_helper: failed with -22

I've taken a quick look at aosp, the provided GPL broadcom code, and I
haven't seen anything for the 4319 wrt to addresses.  How hard would it
be to get those addresses from you guys?

thx,

Jason.

----8<------
commit 8fa440e8d6da21c95cdbc9c1ced76d5962cd9e3d
Author: Jason Cooper <jason@lakedaemon.net>
Date:   Mon Jun 17 15:30:43 2013 +0000

    net: brcmfmac: add sdio chip id 0x4319
    
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 44fa0cd..75ddc2b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -43,6 +43,7 @@
 
 #define SDIO_DEVICE_ID_BROADCOM_43143	43143
 #define SDIO_DEVICE_ID_BROADCOM_43241	0x4324
+#define SDIO_DEVICE_ID_BROADCOM_4319	0x4319
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
 #define SDIO_DEVICE_ID_BROADCOM_4334	0x4334
@@ -55,6 +56,7 @@
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43143)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4319)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d248751..68816ec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3551,6 +3551,8 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 		return true;
 	if (chipid == BCM43241_CHIP_ID)
 		return true;
+	if (chipid == BCM4319_CHIP_ID)
+		return true;
 	if (chipid == BCM4329_CHIP_ID)
 		return true;
 	if (chipid == BCM4330_CHIP_ID)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index ca72177..4336dbb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -31,6 +31,15 @@
 #include "sdio_chip.h"
 
 /* chip core base & ramsize */
+/* bcm4319 */
+/* SDIO device core, ID 0x829 */
+#define BCM4319_CORE_BUS_BASE		0x18011000
+/* internal memory core, ID 0x80e */
+#define BCM4319_CORE_SOCRAM_BASE	0x18003000
+/* ARM Cortex M3 core, ID 0x82a */
+#define BCM4319_CORE_ARM_BASE		0x18002000
+#define BCM4319_RAMSIZE			0x48000
+
 /* bcm4329 */
 /* SDIO device core, ID 0x829 */
 #define BCM4329_CORE_BUS_BASE		0x18011000
@@ -484,6 +493,15 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].cib = 0x07004211;
 		ci->ramsize = 0x90000;
 		break;
+	case BCM4319_CHIP_ID:
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = BCM4319_CORE_BUS_BASE;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = BCM4319_CORE_SOCRAM_BASE;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = BCM4319_CORE_ARM_BASE;
+		ci->ramsize = BCM4319_RAMSIZE;
+		break;
 	case BCM4329_CHIP_ID:
 		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
 		ci->c_inf[1].base = BCM4329_CORE_BUS_BASE;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index c1fe245..c2434db 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -36,6 +36,7 @@
 #define BCM43236_CHIP_ID	43236
 #define BCM43238_CHIP_ID	43238
 #define BCM43241_CHIP_ID	0x4324
+#define BCM4319_CHIP_ID		0x4319
 #define BCM4329_CHIP_ID		0x4329
 #define BCM4330_CHIP_ID		0x4330
 #define BCM4331_CHIP_ID		0x4331

