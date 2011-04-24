Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55428 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab1DXPzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 11:55:25 -0400
Received: by bwz15 with SMTP id 15so1205937bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 08:55:23 -0700 (PDT)
Message-Id: <060ac4fbe5b4c314227ae3867e1dce0919772ccd.1303660092.git.chunkeey@googlemail.com> (sfid-20110424_175539_335525_30B9B0AB)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 24 Apr 2011 17:22:59 +0200
Subject: [PATCH 1/2] p54: implement multicast filter
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jcmvbkbc@gmail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"For best CPU usage and power consumption, having as few
frames as possible percolate through the stack is
desirable. Hence, the hardware should filter as much
as possible."

Note: Not all firmwares include the multicast filter
feature and the stack does not filter them either.
The ARP filter on the other hand was dropped from the
patch since it does not work correctly:

Quote from: Max Filippov <jcmvbkbc@gmail.com>
<http://www.spinics.net/lists/linux-wireless/msg67466.html>
"In the ARP case, when there's no other traffic on p54spi,
all ARP requests are dropped. But if there's some egress
traffic from p54spi, filter seems to work correctly:
only ARP requests that match filter pass through.

In the multicast case filter seems to work correctly, but
it treats broadcast as subject to that filtering too. By
default only 01:00:5e:00:00:01 gets into priv->mc_maclist,
so we miss all broadcasts.

These two filters seem to interfere:
- if we set ARP filter and multicast filter without bc
	=>  we miss all ARPs if there's no egress traffic;
- if we set ARP filter and multicast filter with bc or
	don't set mc filter at all => we get all ARPs.

This effect does not depend on filter setup order."

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/fwio.c |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/p54/lmac.h |    1 +
 drivers/net/wireless/p54/main.c |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/p54/p54.h  |    2 ++
 4 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 2fab7d2..b6a061c 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -727,3 +727,34 @@ int p54_fetch_statistics(struct p54_common *priv)
 	p54_tx(priv, skb);
 	return 0;
 }
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
+	      priv->mc_maclist_num <= MC_FILTER_ADDRESS_NUM);
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
index f666482..f9d0dc8 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -540,6 +540,7 @@ int p54_update_beacon_tim(struct p54_common *priv, u16 aid, bool set);
 int p54_setup_mac(struct p54_common *priv);
 int p54_set_ps(struct p54_common *priv);
 int p54_fetch_statistics(struct p54_common *priv);
+int p54_set_groupfilter(struct p54_common *priv);
 
 /* e/v DCF setup */
 int p54_set_edcf(struct p54_common *priv);
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index fb26773..03198ed 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -308,6 +308,31 @@ out:
 	return ret;
 }
 
+static u64 p54_prepare_multicast(struct ieee80211_hw *dev,
+				 struct netdev_hw_addr_list *mc_list)
+{
+	struct p54_common *priv = dev->priv;
+	struct netdev_hw_addr *ha;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(priv->mc_maclist) !=
+		ARRAY_SIZE(((struct p54_group_address_table *)NULL)->mac_list));
+	/*
+	 * The first entry is reserved for the global broadcast MAC.
+	 * Otherwise the firmware will drop it and ARP will no longer work.
+	 */
+	i = 1;
+	priv->mc_maclist_num = netdev_hw_addr_list_count(mc_list) + i;
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
@@ -316,12 +341,16 @@ static void p54_configure_filter(struct ieee80211_hw *dev,
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
@@ -591,6 +620,7 @@ static const struct ieee80211_ops p54_ops = {
 	.config			= p54_config,
 	.flush			= p54_flush,
 	.bss_info_changed	= p54_bss_info_changed,
+	.prepare_multicast	= p54_prepare_multicast,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
@@ -660,6 +690,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	init_completion(&priv->beacon_comp);
 	INIT_DELAYED_WORK(&priv->work, p54_work);
 
+	memset(&priv->mc_maclist[0], ~0, ETH_ALEN);
 	return dev;
 }
 EXPORT_SYMBOL_GPL(p54_init_common);
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
-- 
1.7.4.4

