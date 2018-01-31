Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:40454 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbeAaVdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:33:44 -0500
Received: by mail-pg0-f67.google.com with SMTP id g16so11125473pgn.7
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 13:33:44 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 4/6] mac80211: Send control port frames over nl80211
Date: Wed, 31 Jan 2018 15:33:27 -0600
Message-Id: <20180131213329.25322-5-denkenz@gmail.com> (sfid-20180131_223355_270289_971C06E1)
In-Reply-To: <20180131213329.25322-1-denkenz@gmail.com>
References: <20180131213329.25322-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If userspace requested control port frames to go over 80211, then do so.
The control packets are intercepted just prior to delivery of the packet
to the underlying network device.

Pre-authentication type frames (protocol: 0x88c7) are also forwarded
over nl80211.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/cfg.c         |  2 ++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        |  2 ++
 net/mac80211/rx.c          | 34 +++++++++++++++++++++++++++++-----
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e12e216..f53bfb27295f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -925,6 +925,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	sdata->control_port_protocol = params->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
+	sdata->control_port_over_nl80211 = false;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(sdata->local,
 							&params->crypto,
 							sdata->vif.type);
@@ -934,6 +935,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			params->crypto.control_port_ethertype;
 		vlan->control_port_no_encrypt =
 			params->crypto.control_port_no_encrypt;
+		vlan->control_port_over_nl80211 = false;
 		vlan->encrypt_headroom =
 			ieee80211_cs_headroom(sdata->local,
 					      &params->crypto,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 26900025de2f..6f91aea6a4cb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -899,6 +899,7 @@ struct ieee80211_sub_if_data {
 	u16 sequence_number;
 	__be16 control_port_protocol;
 	bool control_port_no_encrypt;
+	bool control_port_over_nl80211;
 	int encrypt_headroom;
 
 	atomic_t num_tx_queued;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b9a908..fc71a906939b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4830,6 +4830,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->control_port_protocol = req->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
+	sdata->control_port_over_nl80211 =
+					req->crypto.control_port_over_nl80211;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
 							sdata->vif.type);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e755f93ad735..c3abf9e44079 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2243,6 +2243,33 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
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
+		if (!cfg80211_rx_control_port(dev, skb->data, skb->len,
+					      ehdr->h_source,
+					      be16_to_cpu(skb->protocol),
+					      noencrypt))
+			dev_kfree_skb(skb);
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
@@ -2327,13 +2354,10 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
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
