Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61989 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbbJ2Tnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:46 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/9] brcmfmac: Add RSDB support.
Date: Thu, 29 Oct 2015 20:33:16 +0100
Message-ID: <1446147199-21671-7-git-send-email-arend@broadcom.com> (sfid-20151029_204350_376814_5DE132D0)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

RSDB works almost autonomously in firmware except for AP config.
When device supports RSDB then the interface should not be
brought down when configuring it, otherwise the link (if
configured) on the other interface will be lost.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 4 +++-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  | 5 ++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index deb5f78..8a3c9fa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -4183,7 +4183,9 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			}
 		}
 
-		if (dev_role == NL80211_IFTYPE_AP) {
+		if ((dev_role == NL80211_IFTYPE_AP) &&
+		    ((ifp->ifidx == 0) ||
+		     !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RSDB))) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 			if (err < 0) {
 				brcmf_err("BRCMF_C_DOWN error %d\n", err);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 44bb306..ba52494 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -137,6 +137,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	if (drvr->bus_if->chip != BRCM_CC_43362_CHIP_ID)
 		brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_P2P, "p2p");
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_RSDB, "rsdb_mode");
 
 	if (brcmf_feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
index 6b381f7..5381758 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
@@ -24,13 +24,16 @@
  * PNO: preferred network offload.
  * WOWL: Wake-On-WLAN.
  * P2P: peer-to-peer
+ * RSDB: Real Simultaneous Dual Band
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
 	BRCMF_FEAT_DEF(MCHAN) \
 	BRCMF_FEAT_DEF(PNO) \
 	BRCMF_FEAT_DEF(WOWL) \
-	BRCMF_FEAT_DEF(P2P)
+	BRCMF_FEAT_DEF(P2P) \
+	BRCMF_FEAT_DEF(RSDB)
+
 /*
  * Quirks:
  *
-- 
1.9.1

