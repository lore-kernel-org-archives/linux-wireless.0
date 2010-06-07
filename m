Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0FGTUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 15:20:43 -0400
Subject: [PATCH] iwlwifi: add missing rcu_read_lock
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Miles Lane <miles.lane@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 21:20:38 +0200
Message-ID: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using ieee80211_find_sta() needs to be under
RCU read lock, which iwlwifi currently misses,
so fix it.

Cc: stable@kernel.org
Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-06-07 21:17:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-06-07 21:18:04.000000000 +0200
@@ -1146,6 +1146,7 @@ static void iwlagn_tx_status(struct iwl_
 	struct ieee80211_sta *sta;
 	struct iwl_station_priv *sta_priv;
 
+	rcu_read_lock();
 	sta = ieee80211_find_sta(priv->vif, hdr->addr1);
 	if (sta) {
 		sta_priv = (void *)sta->drv_priv;
@@ -1154,6 +1155,7 @@ static void iwlagn_tx_status(struct iwl_
 		    atomic_dec_return(&sta_priv->pending_frames) == 0)
 			ieee80211_sta_block_awake(priv->hw, sta, false);
 	}
+	rcu_read_unlock();
 
 	ieee80211_tx_status_irqsafe(priv->hw, skb);
 }


