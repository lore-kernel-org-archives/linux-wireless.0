Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:23209 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbbLJMnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:22 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 05/13] brcmfmac: Make TDLS a detectable feature
Date: Thu, 10 Dec 2015 13:43:04 +0100
Message-ID: <1449751392-32569-6-git-send-email-arend@broadcom.com> (sfid-20151210_134339_369785_871CB4CA)
In-Reply-To: <1449751392-32569-1-git-send-email-arend@broadcom.com>
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 21 ++++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c  |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h  |  4 +++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 564e533..8557566 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5983,8 +5983,9 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
 	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
 			WIPHY_FLAG_OFFCHAN_TX |
-			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			WIPHY_FLAG_SUPPORTS_TDLS;
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
+		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	if (!brcmf_roamoff)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
@@ -6376,13 +6377,15 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto wiphy_unreg_out;
 	}
 
-	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
-	if (err) {
-		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
-		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
-	} else {
-		brcmf_fweh_register(cfg->pub, BRCMF_E_TDLS_PEER_EVENT,
-				    brcmf_notify_tdls_peer_event);
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS)) {
+		err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
+		if (err) {
+			brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
+			wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
+		} else {
+			brcmf_fweh_register(cfg->pub, BRCMF_E_TDLS_PEER_EVENT,
+					    brcmf_notify_tdls_peer_event);
+		}
 	}
 
 	/* (re-) activate FWEH event handling */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index ba52494..d9d1ca4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -138,6 +138,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_P2P, "p2p");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_RSDB, "rsdb_mode");
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_TDLS, "tdls_enable");
 
 	if (brcmf_feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 5381758..1390656 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -25,6 +25,7 @@
  * WOWL: Wake-On-WLAN.
  * P2P: peer-to-peer
  * RSDB: Real Simultaneous Dual Band
+ * TDLS: Tunneled Direct Link Setup
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -32,7 +33,8 @@
 	BRCMF_FEAT_DEF(PNO) \
 	BRCMF_FEAT_DEF(WOWL) \
 	BRCMF_FEAT_DEF(P2P) \
-	BRCMF_FEAT_DEF(RSDB)
+	BRCMF_FEAT_DEF(RSDB) \
+	BRCMF_FEAT_DEF(TDLS)
 
 /*
  * Quirks:
-- 
1.9.1

