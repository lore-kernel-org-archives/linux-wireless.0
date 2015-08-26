Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:21157 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbHZUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/12] brcmfmac: use brcmf_get_ifp() to map ifidx to struct brcmf_if instance
Date: Wed, 26 Aug 2015 22:14:58 +0200
Message-ID: <1440620104-2715-7-git-send-email-arend@broadcom.com> (sfid-20150826_221517_988793_E91E45F4)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The knowledge on how to map the interface index to a struct brcmf_if
instance is in brcmf_get_ifp() so use that function when only the
interface index is known instead of accessing brcmf_pub::iflist
directly.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c   |  4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 12 +++++++-----
 6 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
index 0445163..4e33f96 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
@@ -149,7 +149,7 @@ static s32 brcmf_btcoex_params_read(struct brcmf_if *ifp, u32 addr, u32 *data)
 static void brcmf_btcoex_boost_wifi(struct brcmf_btcoex_info *btci,
 				    bool trump_sco)
 {
-	struct brcmf_if *ifp = btci->cfg->pub->iflist[0];
+	struct brcmf_if *ifp = brcmf_get_ifp(btci->cfg->pub, 0);
 
 	if (trump_sco && !btci->saved_regs_part2) {
 		/* this should reduce eSCO agressive
@@ -468,7 +468,7 @@ int brcmf_btcoex_set_mode(struct brcmf_cfg80211_vif *vif,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(vif->wdev.wiphy);
 	struct brcmf_btcoex_info *btci = cfg->btcoex;
-	struct brcmf_if *ifp = cfg->pub->iflist[0];
+	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
 
 	switch (mode) {
 	case BRCMF_BTCOEX_DISABLED:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 0c29bf6..cee9ff4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6213,7 +6213,7 @@ static void brcmf_free_wiphy(struct wiphy *wiphy)
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 						  struct device *busdev)
 {
-	struct net_device *ndev = drvr->iflist[0]->ndev;
+	struct net_device *ndev = brcmf_get_ifp(drvr, 0)->ndev;
 	struct brcmf_cfg80211_info *cfg;
 	struct wiphy *wiphy;
 	struct brcmf_cfg80211_vif *vif;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 1e94e94..7c2135f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -121,7 +121,7 @@ static void brcmf_feat_iovar_int_set(struct brcmf_if *ifp,
 
 void brcmf_feat_attach(struct brcmf_pub *drvr)
 {
-	struct brcmf_if *ifp = drvr->iflist[0];
+	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
 
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 8d1ab4a..2ca783f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -221,7 +221,7 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
 
 	bus_if = dev_get_drvdata(flow->dev);
 	drvr = bus_if->drvr;
-	ifp = drvr->iflist[ifidx];
+	ifp = brcmf_get_ifp(drvr, ifidx);
 	brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_FLOW, blocked);
 
 	spin_unlock_irqrestore(&flow->block_lock, flags);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 1afaf97..3330f30 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -334,7 +334,7 @@ void brcmf_fweh_attach(struct brcmf_pub *drvr)
 void brcmf_fweh_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_fweh_info *fweh = &drvr->fweh;
-	struct brcmf_if *ifp = drvr->iflist[0];
+	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 
 	if (ifp) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index fd43873..0c80c85 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -972,7 +972,7 @@ static void
 brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
 			     u8 if_id)
 {
-	struct brcmf_if *ifp = fws->drvr->iflist[!if_id ? 0 : if_id + 1];
+	struct brcmf_if *ifp = brcmf_get_ifp(fws->drvr, if_id);
 
 	if (WARN_ON(!ifp))
 		return;
@@ -2118,6 +2118,7 @@ static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
 int brcmf_fws_init(struct brcmf_pub *drvr)
 {
 	struct brcmf_fws_info *fws;
+	struct brcmf_if *ifp;
 	u32 tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS;
 	int rc;
 	u32 mode;
@@ -2177,21 +2178,22 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	 * continue. Set mode back to none indicating not enabled.
 	 */
 	fws->fw_signals = true;
-	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv)) {
+	ifp = brcmf_get_ifp(drvr, 0);
+	if (brcmf_fil_iovar_int_set(ifp, "tlv", tlv)) {
 		brcmf_err("failed to set bdcv2 tlv signaling\n");
 		fws->fcmode = BRCMF_FWS_FCMODE_NONE;
 		fws->fw_signals = false;
 	}
 
-	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "ampdu_hostreorder", 1))
+	if (brcmf_fil_iovar_int_set(ifp, "ampdu_hostreorder", 1))
 		brcmf_dbg(INFO, "enabling AMPDU host-reorder failed\n");
 
 	/* Enable seq number reuse, if supported */
-	if (brcmf_fil_iovar_int_get(drvr->iflist[0], "wlfc_mode", &mode) == 0) {
+	if (brcmf_fil_iovar_int_get(ifp, "wlfc_mode", &mode) == 0) {
 		if (BRCMF_FWS_MODE_GET_REUSESEQ(mode)) {
 			mode = 0;
 			BRCMF_FWS_MODE_SET_REUSESEQ(mode, 1);
-			if (brcmf_fil_iovar_int_set(drvr->iflist[0],
+			if (brcmf_fil_iovar_int_set(ifp,
 						    "wlfc_mode", mode) == 0) {
 				BRCMF_FWS_MODE_SET_REUSESEQ(fws->mode, 1);
 			}
-- 
1.9.1

