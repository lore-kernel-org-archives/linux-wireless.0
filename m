Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45535 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752981AbeCMWAE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 18:00:04 -0400
Received: by mail-pg0-f66.google.com with SMTP id s13so465125pgn.12
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2018 15:00:04 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v5 8/9] mac80211: Add support for tx_control_port
Date: Tue, 13 Mar 2018 16:59:41 -0500
Message-Id: <20180313215942.29176-9-denkenz@gmail.com> (sfid-20180313_230011_551967_80502E96)
In-Reply-To: <20180313215942.29176-1-denkenz@gmail.com>
References: <20180313215942.29176-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/tx.c          | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fd68f6fb02d7..9294acb495ee 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3786,4 +3786,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
+	.tx_control_port = ieee80211_tx_control_port,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae9c33cd8ada..a52bd2a61a27 100644
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
index 7643178ef132..6ae8fe121500 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4749,3 +4749,49 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
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
