Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58746 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdBXA3K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:29:10 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 101/306] mac80211-hwsim: Pass rate-ctrl flags and tx-power to user-space
Date: Thu, 23 Feb 2017 16:28:25 -0800
Message-Id: <1487896109-23851-3-git-send-email-greearb@candelatech.com> (sfid-20170224_012922_365111_F1EE0FCA)
In-Reply-To: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The flags field allows user-space to properly decode what the
rate->idx really means.  The tx-power field is useful as well,
in case user-space is interested in doing something clever with
path-loss calculations.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 21 ++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  8 ++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b8189b9..853c7ae 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -629,6 +629,9 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_RADIO_NAME] = { .type = NLA_STRING },
 	[HWSIM_ATTR_NO_VIF] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_FREQ] = { .type = NLA_U32 },
+	[HWSIM_ATTR_TX_INFO2] = { .type = NLA_UNSPEC,
+				  .len = IEEE80211_TX_MAX_RATES *
+				         sizeof(struct hwsim_tx_rate2)},
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -1064,6 +1067,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
 	uintptr_t cookie;
+	struct hwsim_tx_rate2 tx_attempts2[IEEE80211_TX_MAX_RATES];
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1115,6 +1119,8 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		tx_attempts[i].idx = info->status.rates[i].idx;
 		tx_attempts[i].count = info->status.rates[i].count;
+		tx_attempts2[i].rc_flags = info->status.rates[i].flags;
+		tx_attempts2[i].power_level = data->power_level;
 	}
 
 	if (nla_put(skb, HWSIM_ATTR_TX_INFO,
@@ -1122,6 +1128,11 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		    tx_attempts))
 		goto nla_put_failure;
 
+	if (nla_put(skb, HWSIM_ATTR_TX_INFO2,
+		    sizeof(struct hwsim_tx_rate2)*IEEE80211_TX_MAX_RATES,
+		    tx_attempts2))
+		goto nla_put_failure;
+
 	/* We create a cookie to identify this skb */
 	data->pending_cookie++;
 	cookie = data->pending_cookie;
@@ -2898,6 +2909,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct ieee80211_tx_info *txi;
 	struct hwsim_tx_rate *tx_attempts;
 	u64 ret_skb_cookie;
+	struct hwsim_tx_rate2 *tx_attempts2;
 	struct sk_buff *skb, *tmp;
 	const u8 *src;
 	unsigned int hwsim_flags;
@@ -2949,6 +2961,12 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	tx_attempts = (struct hwsim_tx_rate *)nla_data(
 		       info->attrs[HWSIM_ATTR_TX_INFO]);
 
+	if (info->attrs[HWSIM_ATTR_TX_INFO2])
+		tx_attempts2 = (struct hwsim_tx_rate2 *)nla_data(
+		       info->attrs[HWSIM_ATTR_TX_INFO2]);
+	else
+		tx_attempts2 = NULL;
+
 	/* now send back TX status */
 	txi = IEEE80211_SKB_CB(skb);
 
@@ -2957,7 +2975,8 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		txi->status.rates[i].idx = tx_attempts[i].idx;
 		txi->status.rates[i].count = tx_attempts[i].count;
-		/*txi->status.rates[i].flags = 0;*/
+		if (tx_attempts2)
+			txi->status.rates[i].flags = tx_attempts2[i].rc_flags;
 	}
 
 	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 73646b1..480c0a7 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -129,6 +129,7 @@ enum {
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
  * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
  * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
+ * @HWSIM_ATTR_TX_INFO2: hwsim_tx_rate2 array
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -155,6 +156,7 @@ enum {
 	HWSIM_ATTR_NO_VIF,
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
+	HWSIM_ATTR_TX_INFO2,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
@@ -177,4 +179,10 @@ struct hwsim_tx_rate {
 	u8 count;
 } __packed;
 
+/* Auxilary info to allow user-space to better understand the rate */
+struct hwsim_tx_rate2 {
+	u16 rc_flags; /* rate-ctrl flags (see mac80211_rate_control_flags) */
+	s16 power_level;
+} __packed;
+
 #endif /* __MAC80211_HWSIM_H */
-- 
2.4.11
