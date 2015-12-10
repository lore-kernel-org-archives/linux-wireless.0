Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50093 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbbLJMnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:21 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 08/13] brcmfmac: Fix IBSS setup
Date: Thu, 10 Dec 2015 13:43:07 +0100
Message-ID: <1449751392-32569-9-git-send-email-arend@broadcom.com> (sfid-20151210_134336_400454_15DBB9AA)
In-Reply-To: <1449751392-32569-1-git-send-email-arend@broadcom.com>
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

IBSS got broken over time. Disconnect events should not be given
for IBSS mode and connect events for IBSS need to have channel
information.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 3ac5cf7..17658b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1273,17 +1273,17 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state)) {
+	if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state)) {
 		brcmf_dbg(INFO, "Call WLC_DISASSOC to stop excess roaming\n ");
 		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err) {
 			brcmf_err("WLC_DISASSOC failed (%d)\n", err);
 		}
-		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
-		cfg80211_disconnected(vif->wdev.netdev, reason, NULL, 0,
-				      true, GFP_KERNEL);
-
+		if ((vif->wdev.iftype == NL80211_IFTYPE_STATION) ||
+		    (vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT))
+			cfg80211_disconnected(vif->wdev.netdev, reason, NULL, 0,
+					      true, GFP_KERNEL);
 	}
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
 	clear_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status);
@@ -2697,8 +2697,8 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	return err;
 }
 
-static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
-			  struct net_device *ndev, const u8 *bssid)
+static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
+			     struct net_device *ndev, const u8 *bssid)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel;
@@ -2743,6 +2743,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	freq = ieee80211_channel_to_frequency(ch.chnum, band->band);
+	cfg->channel = freq;
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
 	notify_capability = le16_to_cpu(bi->capability);
@@ -5071,9 +5072,9 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	} else if (brcmf_is_linkup(e)) {
 		brcmf_dbg(CONN, "Linkup\n");
 		if (brcmf_is_ibssmode(ifp->vif)) {
+			brcmf_inform_ibss(cfg, ndev, e->addr);
 			chan = ieee80211_get_channel(cfg->wiphy, cfg->channel);
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
-			wl_inform_ibss(cfg, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, chan, GFP_KERNEL);
 			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
 				  &ifp->vif->sme_state);
-- 
1.9.1

