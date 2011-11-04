Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3675 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/16] brcm80211: fmac: remove unnecessary 4329 chip
 specific code
Date: Fri, 4 Nov 2011 22:23:27 +0100
Message-ID: <1320441822-4615-2-git-send-email-arend@broadcom.com> (sfid-20111104_222438_163169_AB41575B)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

4329 with chiprev 0 can not be found on any product. The code can
be removed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6de489b..2c409ca 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -812,10 +812,6 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		clkreq =
 		    bus->alp_only ? SBSDIO_ALP_AVAIL_REQ : SBSDIO_HT_AVAIL_REQ;
 
-		if ((bus->ci->chip == BCM4329_CHIP_ID)
-		    && (bus->ci->chiprev == 0))
-			clkreq |= SBSDIO_FORCE_ALP;
-
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
@@ -1034,11 +1030,9 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 			SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
-		if (bus->ci->chip != BCM4329_CHIP_ID) {
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_DEVICE_CTL,
-				SBSDIO_DEVCTL_PADS_ISO, NULL);
-		}
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+			SBSDIO_DEVICE_CTL,
+			SBSDIO_DEVCTL_PADS_ISO, NULL);
 
 		/* Change state */
 		bus->sleeping = true;
-- 
1.7.4.1


