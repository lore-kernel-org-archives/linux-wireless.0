Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2038 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab1KDVX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:23:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/16] brcm80211: fmac: abstract chip iscoreup function
Date: Fri, 4 Nov 2011 22:23:36 +0100
Message-ID: <1320441822-4615-11-git-send-email-arend@broadcom.com> (sfid-20111104_222403_281393_FED981FE)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Prepare for adding backplane interconnect type support

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 ++------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   13 +++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    3 ++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 868cb9d..30802a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3138,7 +3138,6 @@ brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 {
 	uint retries;
-	u32 regdata;
 	int bcmerror = 0;
 
 	/* To enter download state, disable ARM and reset SOCRAM.
@@ -3159,11 +3158,8 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 					 (u8 *)&zeros, 4);
 		}
 	} else {
-		regdata = brcmf_sdcard_reg_read(bus->sdiodev,
-			CORE_SB(bus->ci->ramcorebase, sbtmstatelow), 4);
-		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
-			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
+		if (!brcmf_sdio_chip_iscoreup(bus->sdiodev,
+					      bus->ci->ramcorebase)) {
 			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
 			bcmerror = -EBADE;
 			goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 10befbf..e0c22c4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -52,6 +52,19 @@
 #define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
 #define	SBIDH_VC_SHIFT		16
 
+bool
+brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
+			 u32 corebase)
+{
+	u32 regdata;
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+	regdata &= (SBTML_RESET | SBTML_REJ_MASK |
+			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	return ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) == regdata);
+}
+
 void
 brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 25ac385..9c43e1d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -133,7 +133,8 @@ struct sbconfig {
 	u32 sbidhigh;	/* identification */
 };
 
-
+extern bool brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
+				     u32 corebase);
 extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
 					u32 corebase);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-- 
1.7.4.1


