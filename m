Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44638 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab3I2Tji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 15:39:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.12 1/2] mac80211: use sta_info_get_bss() for nl80211 tx and client probing
Date: Sun, 29 Sep 2013 21:39:33 +0200
Message-Id: <1380483574-88667-1-git-send-email-nbd@openwrt.org> (sfid-20130929_213947_125853_9088A103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows calls for clients in AP_VLANs (e.g. for 4-addr) to succeed

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c | 2 +-
 net/mac80211/tx.c  | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2e7855a..629dee7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3518,7 +3518,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 	band = chanctx_conf->def.chan->band;
-	sta = sta_info_get(sdata, peer);
+	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
 	} else {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3456c04..70b5a05 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1120,7 +1120,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+	} else if (info->flags & (IEEE80211_TX_CTL_INJECTED |
+				  IEEE80211_TX_INTFL_NL80211_FRAME_TX) ||
 		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
-- 
1.8.0.2

