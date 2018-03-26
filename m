Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:45725 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbeCZRQe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:16:34 -0400
Received: by mail-oi0-f68.google.com with SMTP id 71-v6so16717998oie.12
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:16:34 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v6 11/11] mac80211: Send control port frames over nl80211
Date: Mon, 26 Mar 2018 12:16:14 -0500
Message-Id: <20180326171614.20373-12-denkenz@gmail.com> (sfid-20180326_191639_725518_76D9D181)
In-Reply-To: <20180326171614.20373-1-denkenz@gmail.com>
References: <20180326171614.20373-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If userspace requested control port frames to go over 80211, then do so.
The control packets are intercepted just prior to delivery of the packet
to the underlying network device.

Pre-authentication type frames (protocol: 0x88c7) are also forwarded
over nl80211.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/cfg.c         |  6 ++++++
 net/mac80211/ibss.c        |  1 +
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       |  2 ++
 net/mac80211/main.c        |  2 ++
 net/mac80211/mlme.c        |  2 ++
 net/mac80211/rx.c          | 33 ++++++++++++++++++++++++++++-----
 7 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9294acb495ee..49112378e503 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -925,6 +925,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	sdata->control_port_protocol = params->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
+	sdata->control_port_over_nl80211 =
+				params->crypto.control_port_over_nl80211;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(sdata->local,
 							&params->crypto,
 							sdata->vif.type);
@@ -934,6 +936,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			params->crypto.control_port_ethertype;
 		vlan->control_port_no_encrypt =
 			params->crypto.control_port_no_encrypt;
+		vlan->control_port_over_nl80211 =
+			params->crypto.control_port_over_nl80211;
 		vlan->encrypt_headroom =
 			ieee80211_cs_headroom(sdata->local,
 					      &params->crypto,
@@ -2019,6 +2023,8 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
+	sdata->control_port_over_nl80211 = setup.control_port_over_nl80211;
+
 	/* can mesh use other SMPS modes? */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index db07e0de9a03..05ddc9291ec5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1844,6 +1844,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = local->rx_chains;
+	sdata->control_port_over_nl80211 = params->control_port_over_nl80211;
 
 	ieee80211_queue_work(&local->hw, &sdata->work);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a52bd2a61a27..00dbc6a1b79d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -899,6 +899,7 @@ struct ieee80211_sub_if_data {
 	u16 sequence_number;
 	__be16 control_port_protocol;
 	bool control_port_no_encrypt;
+	bool control_port_over_nl80211;
 	int encrypt_headroom;
 
 	atomic_t num_tx_queued;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d13ba064951f..555e389b7dfa 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -519,6 +519,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			master->control_port_protocol;
 		sdata->control_port_no_encrypt =
 			master->control_port_no_encrypt;
+		sdata->control_port_over_nl80211 =
+			master->control_port_over_nl80211;
 		sdata->vif.cab_queue = master->vif.cab_queue;
 		memcpy(sdata->vif.hw_queue, master->vif.hw_queue,
 		       sizeof(sdata->vif.hw_queue));
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0785d04a80bc..e5a51267c75d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -554,6 +554,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_USERSPACE_MPM |
 			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS_STA);
+	wiphy_ext_feature_set(wiphy,
+			      NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211);
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0024eff9bb84..b3665b857883 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4844,6 +4844,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->control_port_protocol = req->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
+	sdata->control_port_over_nl80211 =
+					req->crypto.control_port_over_nl80211;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
 							sdata->vif.type);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index de7d10732fd5..bbb8bc6cac2a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2245,6 +2245,32 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 	return true;
 }
 
+static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
+						 struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct net_device *dev = sdata->dev;
+
+	if (unlikely((skb->protocol == sdata->control_port_protocol ||
+		      skb->protocol == cpu_to_be16(ETH_P_PREAUTH)) &&
+		     sdata->control_port_over_nl80211)) {
+		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+		bool noencrypt = status->flag & RX_FLAG_DECRYPTED;
+		struct ethhdr *ehdr = eth_hdr(skb);
+
+		cfg80211_rx_control_port(dev, skb->data, skb->len,
+					 ehdr->h_source,
+					 be16_to_cpu(skb->protocol), noencrypt);
+		dev_kfree_skb(skb);
+	} else {
+		/* deliver to local stack */
+		if (rx->napi)
+			napi_gro_receive(rx->napi, skb);
+		else
+			netif_receive_skb(skb);
+	}
+}
+
 /*
  * requires that rx->skb is a frame with ethernet header
  */
@@ -2329,13 +2355,10 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 #endif
 
 	if (skb) {
-		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
 		memset(skb->cb, 0, sizeof(skb->cb));
-		if (rx->napi)
-			napi_gro_receive(rx->napi, skb);
-		else
-			netif_receive_skb(skb);
+
+		ieee80211_deliver_skb_to_local_stack(skb, rx);
 	}
 
 	if (xmit_skb) {
-- 
2.13.5
