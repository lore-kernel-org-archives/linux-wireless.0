Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:47323 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1KPMbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:31:48 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2 1/2] mac80211: Add NoAck per WMM Queue Support
Date: Wed, 16 Nov 2011 13:31:05 +0100
Message-Id: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111116_133151_852630_8E8411B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for NoAck per WMM Queue. The Unicast QoS
Header is adapted accordingly for each outgoing frame.
The support is turned on and off through nl80211 by extending
the WMM TX Queue Parameters, but can be triggered separately.

I have tested this feature on ath9k as well as ath5k devices. There is
an iw patch as well to make use of this feature.

It should apply well on the latest wireless-testing kernel.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Changes to PATCH:

consider NO_ACK flag when calculating duration
check if set_txq_noack op is implemented before calling it

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    7 +++++++
 include/net/mac80211.h  |    2 ++
 net/mac80211/cfg.c      |   21 +++++++++++++++++++++
 net/mac80211/tx.c       |   10 +++++++++-
 net/mac80211/util.c     |    1 +
 net/mac80211/wme.c      |    5 ++++-
 net/wireless/nl80211.c  |   34 +++++++++++++++++++++++++++++-----
 8 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f9261c2..6b0ecb4 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2137,6 +2137,7 @@ enum nl80211_mesh_setup_params {
  * @NL80211_TXQ_ATTR_CWMAX: Maximum contention window [a value of the form
  *	2^n-1 in the range 1..32767]
  * @NL80211_TXQ_ATTR_AIFS: Arbitration interframe space [0..255]
+ * @NL80211_TXQ_ATTR_NOACK: NoAck Mode, 0 meaning normal Ack operation
  * @__NL80211_TXQ_ATTR_AFTER_LAST: Internal
  * @NL80211_TXQ_ATTR_MAX: Maximum TXQ attribute number
  */
@@ -2147,6 +2148,7 @@ enum nl80211_txq_attr {
 	NL80211_TXQ_ATTR_CWMIN,
 	NL80211_TXQ_ATTR_CWMAX,
 	NL80211_TXQ_ATTR_AIFS,
+	NL80211_TXQ_ATTR_NOACK,
 
 	/* keep last */
 	__NL80211_TXQ_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8d7ba09..10884ef 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -825,6 +825,7 @@ struct mesh_setup {
  * @cwmax: Maximum contention window [a value of the form 2^n-1 in the range
  *	1..32767]
  * @aifs: Arbitration interframe space [0..255]
+ * @noack: NoAck Policy, false meaning normal Ack operation
  */
 struct ieee80211_txq_params {
 	enum nl80211_txq_q queue;
@@ -832,6 +833,7 @@ struct ieee80211_txq_params {
 	u16 cwmin;
 	u16 cwmax;
 	u8 aifs;
+	bool noack;
 };
 
 /* from net/wireless.h */
@@ -1341,6 +1343,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @set_txq_params: Set TX queue parameters
  *
+ * @set_txq_noack: Set TX queue NoAck Parameter
+ *
  * @set_channel: Set channel for a given wireless interface. Some devices
  *	may support multi-channel operation (by channel hopping) so cfg80211
  *	doesn't verify much. Note, however, that the passed netdev may be
@@ -1521,6 +1525,9 @@ struct cfg80211_ops {
 	int	(*set_txq_params)(struct wiphy *wiphy, struct net_device *dev,
 				  struct ieee80211_txq_params *params);
 
+	int	(*set_txq_noack)(struct wiphy *wiphy, struct net_device *dev,
+				  struct ieee80211_txq_params *params);
+
 	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0756049..1bfcc21 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -122,6 +122,7 @@ enum ieee80211_ac_numbers {
  *	2^n-1 in the range 1..32767]
  * @cw_max: maximum contention window [like @cw_min]
  * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
+ * @noack: NoAck Policy, false meaning normal Ack operation
  * @uapsd: is U-APSD mode enabled for the queue
  */
 struct ieee80211_tx_queue_params {
@@ -129,6 +130,7 @@ struct ieee80211_tx_queue_params {
 	u16 cw_min;
 	u16 cw_max;
 	u8 aifs;
+	bool noack;
 	bool uapsd;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1063a7e..8298c51 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1393,6 +1393,7 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	p.cw_max = params->cwmax;
 	p.cw_min = params->cwmin;
 	p.txop = params->txop;
+	p.noack = params->noack;
 
 	/*
 	 * Setting tx queue params disables u-apsd because it's only
@@ -1414,6 +1415,25 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_txq_noack(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct ieee80211_txq_params *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (!local->ops->conf_tx)
+		return -EOPNOTSUPP;
+
+	if (params->queue >= local->hw.queues)
+		return -EINVAL;
+
+	sdata->tx_conf[params->queue].noack = params->noack;
+
+	return 0;
+
+}
+
 static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct net_device *netdev,
 				 struct ieee80211_channel *chan,
@@ -2662,6 +2682,7 @@ struct cfg80211_ops mac80211_config_ops = {
 #endif
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
+	.set_txq_noack = ieee80211_set_txq_noack,
 	.set_channel = ieee80211_set_channel,
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f044963..62a3190 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -154,7 +154,10 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	 * (10 bytes + 4-byte FCS = 112 bits) plus SIFS; rounded up
 	 * to closest integer */
 
-	dur = ieee80211_frame_duration(local, 10, rate, erp,
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		dur = 0;
+	else
+		dur = ieee80211_frame_duration(local, 10, rate, erp,
 				tx->sdata->vif.bss_conf.use_short_preamble);
 
 	if (next_frag_len) {
@@ -1161,6 +1164,11 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		 * explicitly unset IEEE80211_TX_CTL_NO_ACK since
 		 * it might already be set for injected frames.
 		 */
+
+		qc = ieee80211_get_qos_ctl(hdr);
+		if (*qc & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
+			info->flags |= IEEE80211_TX_CTL_NO_ACK;
+
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3a00814..d298baf 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -629,6 +629,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 		}
 
 		qparam.uapsd = false;
+		qparam.noack = false;
 
 		sdata->tx_conf[queue] = qparam;
 		drv_conf_tx(local, sdata, queue, &qparam);
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4332711..ba22a08 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -143,13 +143,16 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 	/* Fill in the QoS header if there is one. */
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
-		u8 ack_policy, tid;
+		u8 ack_policy = 0, tid, q;
 
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+		q = ieee802_1d_to_ac[tid];
 
 		/* preserve EOSP bit */
 		ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
 
+		if (sdata->tx_conf[q].noack)
+			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		if (unlikely(sdata->local->wifi_wme_noack_test) ||
 		    is_multicast_ether_addr(hdr->addr1))
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6bc7c4b..a9e0bf8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1081,6 +1081,7 @@ static const struct nla_policy txq_params_policy[NL80211_TXQ_ATTR_MAX + 1] = {
 	[NL80211_TXQ_ATTR_CWMIN]		= { .type = NLA_U16 },
 	[NL80211_TXQ_ATTR_CWMAX]		= { .type = NLA_U16 },
 	[NL80211_TXQ_ATTR_AIFS]			= { .type = NLA_U8 },
+	[NL80211_TXQ_ATTR_NOACK]		= { .type = NLA_U8 },
 };
 
 static int parse_txq_params(struct nlattr *tb[],
@@ -1096,10 +1097,24 @@ static int parse_txq_params(struct nlattr *tb[],
 	txq_params->cwmin = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMIN]);
 	txq_params->cwmax = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMAX]);
 	txq_params->aifs = nla_get_u8(tb[NL80211_TXQ_ATTR_AIFS]);
+	txq_params->noack = false;
 
 	return 0;
 }
 
+static int parse_txq_params_noack(struct nlattr *tb[],
+			    struct ieee80211_txq_params *txq_params)
+{
+	if (!tb[NL80211_TXQ_ATTR_NOACK] || !tb[NL80211_TXQ_ATTR_QUEUE])
+		return -EINVAL;
+
+	txq_params->queue = nla_get_u8(tb[NL80211_TXQ_ATTR_QUEUE]);
+	txq_params->noack = !!nla_get_u8(tb[NL80211_TXQ_ATTR_NOACK]);
+
+	return 0;
+}
+
+
 static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 {
 	/*
@@ -1279,17 +1294,26 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
+			int result_noack, result_param;
 			nla_parse(tb, NL80211_TXQ_ATTR_MAX,
 				  nla_data(nl_txq_params),
 				  nla_len(nl_txq_params),
 				  txq_params_policy);
-			result = parse_txq_params(tb, &txq_params);
-			if (result)
+
+			result_param = parse_txq_params(tb, &txq_params);
+			result_noack = parse_txq_params_noack(tb, &txq_params);
+
+			if (!result_param)
+				result = rdev->ops->set_txq_params(&rdev->wiphy,
+							   netdev,
+							   &txq_params);
+			else if (!result_noack && rdev->ops->set_txq_noack)
+				result = rdev->ops->set_txq_noack(&rdev->wiphy,
+							   netdev,
+							   &txq_params);
+			else
 				goto bad_res;
 
-			result = rdev->ops->set_txq_params(&rdev->wiphy,
-							   netdev,
-							   &txq_params);
 			if (result)
 				goto bad_res;
 		}
-- 
1.7.7.2

