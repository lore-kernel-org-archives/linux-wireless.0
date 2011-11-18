Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52456 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1KRNVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 08:21:18 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv4 3/3] mac80211: Add NoAck per tid support
Date: Fri, 18 Nov 2011 14:20:44 +0100
Message-Id: <1321622446-2477-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111118_142122_393233_CEDBDD38)
In-Reply-To: <1321622446-2477-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321622446-2477-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains the processing changes in mac80211.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/cfg.c         |   11 +++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    2 ++
 net/mac80211/wme.c         |    7 ++++++-
 4 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1063a7e..e1a8d89 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -102,6 +102,16 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_noack_map(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  u16 noack_map)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	sdata->noack_map = noack_map;
+	return 0;
+}
+
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr,
 			     struct key_params *params)
@@ -2698,4 +2708,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.tdls_mgmt = ieee80211_tdls_mgmt,
 	.probe_client = ieee80211_probe_client,
 	.get_channel = ieee80211_wiphy_get_channel,
+	.set_noack_map = ieee80211_set_noack_map,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5c62579..e93c496 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -607,6 +607,9 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
 
+	/* TID bitmap for NoAck policy */
+	u16 noack_map;
+
 	struct ieee80211_key __rcu *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *default_unicast_key;
 	struct ieee80211_key __rcu *default_multicast_key;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b34ca0c..be1d61e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -866,6 +866,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
 	sdata->control_port_no_encrypt = false;
 
+	sdata->noack_map = 0;
+
 	/* only monitor differs */
 	sdata->dev->type = ARPHRD_ETHER;
 
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 74b3d10..a98f24a 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -139,6 +139,7 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	/* Fill in the QoS header if there is one. */
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
@@ -150,8 +151,12 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 		/* preserve EOSP bit */
 		ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
 
-		if (is_multicast_ether_addr(hdr->addr1))
+		if (is_multicast_ether_addr(hdr->addr1) ||
+		    sdata->noack_map & BIT(tid)) {
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
+			info->flags |= IEEE80211_TX_CTL_NO_ACK;
+		}
+
 		/* qos header is 2 bytes */
 		*p++ = ack_policy | tid;
 		*p = ieee80211_vif_is_mesh(&sdata->vif) ?
-- 
1.7.7.3

