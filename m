Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42473 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933445AbeAJRJv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 12:09:51 -0500
Received: by mail-pl0-f67.google.com with SMTP id bd8so7643496plb.9
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 09:09:50 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v2 3/5] mac80211: Send control port frames over nl80211
Date: Wed, 10 Jan 2018 11:09:36 -0600
Message-Id: <20180110170938.2341-4-denkenz@gmail.com> (sfid-20180110_180958_612167_81C26F3A)
In-Reply-To: <20180110170938.2341-1-denkenz@gmail.com>
References: <20180110170938.2341-1-denkenz@gmail.com>
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
 net/mac80211/rx.c          | 31 ++++++++++++++++++++++++++++---
 4 files changed, 33 insertions(+), 3 deletions(-)

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
index b3cff69bfd66..28b74ae1ee48 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2326,16 +2326,41 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	}
 #endif
 
-	if (skb) {
+	if (!skb)
+		goto try_xmit;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+
+	if (unlikely((skb->protocol == sdata->control_port_protocol ||
+		      skb->protocol == cpu_to_be16(0x88c7)) &&
+		     sdata->control_port_over_nl80211)) {
+		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+		bool noencrypt;
+
+		ehdr = eth_hdr(skb);
+
+		if (status->flag & RX_FLAG_DECRYPTED)
+			noencrypt = false;
+		else
+			noencrypt = true;
+
+		if (!cfg80211_rx_control_port(dev, skb->data, skb->len,
+					      ehdr->h_source,
+					      be16_to_cpu(skb->protocol),
+					      noencrypt)) {
+			dev_kfree_skb(skb);
+			skb = NULL;
+		}
+	} else {
 		/* deliver to local stack */
-		skb->protocol = eth_type_trans(skb, dev);
-		memset(skb->cb, 0, sizeof(skb->cb));
 		if (rx->napi)
 			napi_gro_receive(rx->napi, skb);
 		else
 			netif_receive_skb(skb);
 	}
 
+try_xmit:
 	if (xmit_skb) {
 		/*
 		 * Send to wireless media and increase priority by 256 to
-- 
2.13.5
