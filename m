Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45063 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbeBABEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 20:04:34 -0500
Received: by mail-pf0-f193.google.com with SMTP id a88so14473015pfe.12
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 17:04:34 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v4 5/6] mac80211: Add support for tx_control_port
Date: Wed, 31 Jan 2018 19:04:19 -0600
Message-Id: <20180201010420.6102-6-denkenz@gmail.com> (sfid-20180201_020438_525543_6D56A96C)
In-Reply-To: <20180201010420.6102-1-denkenz@gmail.com>
References: <20180201010420.6102-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/tx.c          | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e12e216..fb3cf38d674f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3785,4 +3785,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
+	.tx_control_port = ieee80211_tx_control_port,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 26900025de2f..c78f30555b6d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1734,6 +1734,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta);
 void ieee80211_check_fast_xmit_all(struct ieee80211_local *local);
 void ieee80211_check_fast_xmit_iface(struct ieee80211_sub_if_data *sdata);
 void ieee80211_clear_fast_xmit(struct sta_info *sta);
+int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *buf, size_t len,
+			      const u8 *dest, __be16 proto, bool unencrypted);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 25904af38839..99934bc3cd83 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4754,3 +4754,49 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	ieee80211_xmit(sdata, NULL, skb);
 	local_bh_enable();
 }
+
+int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *buf, size_t len,
+			      const u8 *dest, __be16 proto, bool unencrypted)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ethhdr *ehdr;
+	u32 flags;
+
+	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
+	 * or Pre-Authentication
+	 */
+	if (proto != sdata->control_port_protocol &&
+	    proto != cpu_to_be16(ETH_P_PREAUTH))
+		return -EINVAL;
+
+	if (unencrypted)
+		flags = IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	else
+		flags = 0;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    sizeof(struct ethhdr) + len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom + sizeof(struct ethhdr));
+
+	skb_put_data(skb, buf, len);
+
+	ehdr = skb_push(skb, sizeof(struct ethhdr));
+	memcpy(ehdr->h_dest, dest, ETH_ALEN);
+	memcpy(ehdr->h_source, sdata->vif.addr, ETH_ALEN);
+	ehdr->h_proto = proto;
+
+	skb->dev = dev;
+	skb->protocol = htons(ETH_P_802_3);
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+
+	return 0;
+}
-- 
2.13.5
