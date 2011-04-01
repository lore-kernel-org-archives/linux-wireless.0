Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1DAW6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 18:58:25 -0400
Received: by bwz15 with SMTP id 15so2853096bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 15:58:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFT] p54: implement multicast + arp req PS filter
Date: Sat, 2 Apr 2011 00:58:16 +0200
Cc: Michael Buesch <mb@bu3sch.de>, Max Filippov <jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104020058.17232.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"For best CPU usage and power consumption, having as few
frames as possible percolate through the stack is
desirable. Hence, the hardware should filter as much
as possible."

Note: The available stlc45xx softmac specification does not
specify whenever these features are implemented in the
common [pci/usb] branches, or not . At least from the data
I could gather, it doesn't look like this is the case.
Therefore, I'm looking for test results from p54spi users.
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 2fab7d2..e8c7d02 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -727,3 +727,67 @@ int p54_fetch_statistics(struct p54_common *priv)
 	p54_tx(priv, skb);
 	return 0;
 }
+
+int p54_set_arpfilter(struct p54_common *priv)
+{
+	struct p54_arp_table *arp;
+	struct sk_buff *skb;
+	struct ieee80211_bss_conf *bss_conf = NULL;
+	bool on = false;
+
+	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*arp),
+			    P54_CONTROL_TYPE_ARPTABLE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	arp = (struct p54_arp_table *)skb_put(skb, sizeof(*arp));
+	if (priv->vif) {
+		bss_conf = &priv->vif->bss_conf;
+
+		on = bss_conf->arp_filter_enabled &&
+		     bss_conf->arp_addr_cnt == 1;
+	}
+
+	if (on) {
+		arp->filter_enable = cpu_to_le16(1);
+		memcpy(arp->ipv4_addr, &bss_conf->arp_addr_list[0],
+		       sizeof(arp->ipv4_addr));
+	} else {
+		arp->filter_enable = cpu_to_le16(0);
+		memset(arp->ipv4_addr, 0, sizeof(arp->ipv4_addr));
+	}
+
+	p54_tx(priv, skb);
+	return 0;
+}
+
+int p54_set_groupfilter(struct p54_common *priv)
+{
+	struct p54_group_address_table *grp;
+	struct sk_buff *skb;
+	bool on = false;
+
+	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*grp),
+			    P54_CONTROL_TYPE_GROUP_ADDRESS_TABLE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	grp = (struct p54_group_address_table *)skb_put(skb, sizeof(*grp));
+
+	on = !(priv->filter_flags & FIF_ALLMULTI) &&
+	     (priv->mc_maclist_num > 0 &&
+	      priv->mc_maclist_num < MC_FILTER_ADDRESS_NUM);
+
+	if (on) {
+		grp->filter_enable = cpu_to_le16(1);
+		grp->num_address = cpu_to_le16(priv->mc_maclist_num);
+		memcpy(grp->mac_list, priv->mc_maclist, sizeof(grp->mac_list));
+	} else {
+		grp->filter_enable = cpu_to_le16(0);
+		grp->num_address = cpu_to_le16(0);
+		memset(grp->mac_list, 0, sizeof(grp->mac_list));
+	}
+
+	p54_tx(priv, skb);
+	return 0;
+}
diff --git a/drivers/net/wireless/p54/lmac.h b/drivers/net/wireless/p54/lmac.h
index f666482..2990715 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -540,6 +540,8 @@ int p54_update_beacon_tim(struct p54_common *priv, u16 aid, bool set);
 int p54_setup_mac(struct p54_common *priv);
 int p54_set_ps(struct p54_common *priv);
 int p54_fetch_statistics(struct p54_common *priv);
+int p54_set_arpfilter(struct p54_common *priv);
+int p54_set_groupfilter(struct p54_common *priv);
 
 /* e/v DCF setup */
 int p54_set_edcf(struct p54_common *priv);
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index e6205e4..ef612f5 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -308,6 +308,27 @@ out:
 	return ret;
 }
 
+static u64 p54_prepare_multicast(struct ieee80211_hw *dev,
+				 struct netdev_hw_addr_list *mc_list)
+{
+	struct p54_common *priv = dev->priv;
+	struct netdev_hw_addr *ha;
+	int i = 0;
+
+	BUILD_BUG_ON(ARRAY_SIZE(priv->mc_maclist) !=
+		ARRAY_SIZE(((struct p54_group_address_table *)NULL)->mac_list));
+
+	priv->mc_maclist_num = netdev_hw_addr_list_count(mc_list);
+	netdev_hw_addr_list_for_each(ha, mc_list) {
+		memcpy(&priv->mc_maclist[i], ha->addr, ETH_ALEN);
+		i++;
+		if (i >= ARRAY_SIZE(priv->mc_maclist))
+			break;
+	}
+
+	return 1; /* update */
+}
+
 static void p54_configure_filter(struct ieee80211_hw *dev,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
@@ -316,12 +337,16 @@ static void p54_configure_filter(struct ieee80211_hw *dev,
 	struct p54_common *priv = dev->priv;
 
 	*total_flags &= FIF_PROMISC_IN_BSS |
+			FIF_ALLMULTI |
 			FIF_OTHER_BSS;
 
 	priv->filter_flags = *total_flags;
 
 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS))
 		p54_setup_mac(priv);
+
+	if (changed_flags & FIF_ALLMULTI || multicast)
+		p54_set_groupfilter(priv);
 }
 
 static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
@@ -412,6 +437,9 @@ static void p54_bss_info_changed(struct ieee80211_hw *dev,
 		}
 	}
 
+	if (changed & BSS_CHANGED_ARP_FILTER)
+		WARN_ON(p54_set_arpfilter(priv));
+
 	mutex_unlock(&priv->conf_mutex);
 }
 
@@ -591,6 +619,7 @@ static const struct ieee80211_ops p54_ops = {
 	.config			= p54_config,
 	.flush			= p54_flush,
 	.bss_info_changed	= p54_bss_info_changed,
+	.prepare_multicast	= p54_prepare_multicast,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 50730fc..799d05e 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -211,8 +211,10 @@ struct p54_common {
 	/* BBP/MAC state */
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
+	u8 mc_maclist[4][ETH_ALEN];
 	u16 wakeup_timer;
 	unsigned int filter_flags;
+	int mc_maclist_num;
 	int mode;
 	u32 tsf_low32, tsf_high32;
 	u32 basic_rate_mask;
