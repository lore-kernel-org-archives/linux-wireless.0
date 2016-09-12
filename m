Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36033 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbcILJn1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:27 -0400
Received: by mail-pa0-f67.google.com with SMTP id p2so1326131pap.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:27 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 3/9] rsi: Added freeing of allocated buffers (sbands and dfsentry)      Cleanup (spelling mistakes, code format corrections,          empty lines after declaration)
Date: Mon, 12 Sep 2016 15:08:18 +0530
Message-Id: <9e848b4549d9e919eb3a772e0d292db5eee39b43.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114332_590493_6437BBB6)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..29abedc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -194,6 +194,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 void rsi_mac80211_detach(struct rsi_hw *adapter)
 {
 	struct ieee80211_hw *hw = adapter->hw;
+	int i;
 
 	if (hw) {
 		ieee80211_stop_queues(hw);
@@ -201,7 +202,17 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
 		ieee80211_free_hw(hw);
 	}
 
+	for(i = 0; i < 2; i++) {
+		struct ieee80211_supported_band *sbands = &adapter->sbands[i];
+
+		if (sbands->channels)
+			kfree(sbands->channels);
+	}
+
+#ifdef CONFIG_RSI_DEBUGFS
 	rsi_remove_dbgfs(adapter);
+	kfree(adapter->dfsentry);
+#endif
 }
 EXPORT_SYMBOL_GPL(rsi_mac80211_detach);
 
@@ -304,7 +315,8 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 		if (!adapter->sc_nvifs) {
 			++adapter->sc_nvifs;
 			adapter->vifs[0] = vif;
-			ret = rsi_set_vap_capabilities(common, STA_OPMODE);
+			ret = rsi_set_vap_capabilities(common,
+						       STA_OPMODE);
 		}
 		break;
 	default:
@@ -429,9 +441,11 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 u16 rsi_get_connected_channel(struct rsi_hw *adapter)
 {
 	struct ieee80211_vif *vif = adapter->vifs[0];
+
 	if (vif) {
 		struct ieee80211_bss_conf *bss = &vif->bss_conf;
 		struct ieee80211_channel *channel = bss->chandef.chan;
+
 		return channel->hw_value;
 	}
 
@@ -819,8 +833,6 @@ static void rsi_perform_cqm(struct rsi_common *common,
 	common->cqm_info.last_cqm_event_rssi = rssi;
 	rsi_dbg(INFO_ZONE, "CQM: Notifying event: %d\n", event);
 	ieee80211_cqm_rssi_notify(adapter->vifs[0], event, GFP_KERNEL);
-
-	return;
 }
 
 /**
@@ -875,16 +887,14 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 	}
 
 	/* CQM only for connected AP beacons, the RSSI is a weighted avg */
-	if (bss->assoc && !(memcmp(bss->bssid, hdr->addr2, ETH_ALEN))) {
+	if (bss->assoc && ether_addr_equal(bss->bssid, hdr->addr2)) {
 		if (ieee80211_is_beacon(hdr->frame_control))
 			rsi_perform_cqm(common, hdr->addr2, rxs->signal);
 	}
-
-	return;
 }
 
 /**
- * rsi_indicate_pkt_to_os() - This function sends recieved packet to mac80211.
+ * rsi_indicate_pkt_to_os() - This function sends received packet to mac80211.
  * @common: Pointer to the driver private structure.
  * @skb: Pointer to the socket buffer structure.
  *
-- 
2.4.11
