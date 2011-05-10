Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36968 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1EJSwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 14:52:30 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	greearb@candelatech.com
Subject: [PATCH v2 2.6.39] ath9k: fix a regression in PS frame filter handling
Date: Tue, 10 May 2011 20:52:22 +0200
Message-Id: <1305053542-29435-1-git-send-email-nbd@openwrt.org> (sfid-20110510_205234_244196_65D78F7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only leave filtering enabled for AP or VLAN interfaces, clear the
destination mask for all other interfaces.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++++
 drivers/net/wireless/ath/ath9k/xmit.c |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3de115d..3d999b7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1778,6 +1778,11 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ieee80211_key_conf ps_key = { };
 
 	ath_node_attach(sc, sta);
+
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_AP_VLAN)
+		return 0;
+
 	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 744779d..97dd1fa 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1845,6 +1845,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = info->control.sta;
+	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
 	struct ath_buf *bf;
@@ -1882,6 +1883,11 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
+	if ((vif && vif->type != NL80211_IFTYPE_AP &&
+	            vif->type != NL80211_IFTYPE_AP_VLAN) ||
+	    !ieee80211_is_data(hdr->frame_control))
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+
 	setup_frame_info(hw, skb, frmlen);
 
 	/*
-- 
1.7.3.2

