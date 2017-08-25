Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754347AbdHYCas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:48 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 02/27] qtnfmac: make "Channel change" event report full channel info
Date: Thu, 24 Aug 2017 19:29:59 -0700
Message-Id: <20170825023024.10565-3-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043101_255490_2FB85B1B)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Specifically, it has to report center frequency, secondary center
frequency (for 80+80) and BW.
Introduce channel definition structure to qlink and modify channel
change event processing function accordingly.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c     | 34 +++++++-------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 18 +++++++-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 52 ++++++++++++++++++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  4 ++
 4 files changed, 87 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 0fc2814..52e2652 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -25,6 +25,7 @@
 #include "trans.h"
 #include "util.h"
 #include "event.h"
+#include "qlink_util.h"
 
 static int
 qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
@@ -358,41 +359,36 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 			      u16 len)
 {
 	struct wiphy *wiphy = priv_to_wiphy(mac);
-	struct cfg80211_chan_def chandef;
-	struct ieee80211_channel *chan;
+	struct cfg80211_chan_def chdef;
 	struct qtnf_vif *vif;
-	int freq;
 	int i;
 
 	if (len < sizeof(*data)) {
-		pr_err("payload is too short\n");
+		pr_err("MAC%u: payload is too short\n", mac->macid);
 		return -EINVAL;
 	}
 
-	freq = le32_to_cpu(data->freq);
-	chan = ieee80211_get_channel(wiphy, freq);
-	if (!chan) {
-		pr_err("channel at %d MHz not found\n", freq);
+	qlink_chandef_q2cfg(wiphy, &data->chan, &chdef);
+
+	if (!cfg80211_chandef_valid(&chdef)) {
+		pr_err("MAC%u: bad channel freq1=%u bw=%u\n", mac->macid,
+		       chdef.center_freq1, chdef.width);
 		return -EINVAL;
 	}
 
-	pr_debug("MAC%d switch to new channel %u MHz\n", mac->macid, freq);
+	pr_debug("MAC%d: new channel ieee=%u freq1=%u freq2=%u bw=%u\n",
+		 mac->macid, chdef.chan->hw_value, chdef.center_freq1,
+		 chdef.center_freq2, chdef.width);
 
 	if (mac->status & QTNF_MAC_CSA_ACTIVE) {
 		mac->status &= ~QTNF_MAC_CSA_ACTIVE;
-		if (chan->hw_value != mac->csa_chandef.chan->hw_value)
+		if (chdef.chan->hw_value != mac->csa_chandef.chan->hw_value)
 			pr_warn("unexpected switch to %u during CSA to %u\n",
-				chan->hw_value,
+				chdef.chan->hw_value,
 				mac->csa_chandef.chan->hw_value);
 	}
 
-	/* FIXME: need to figure out proper nl80211_channel_type value */
-	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
-	/* fall-back to minimal safe chandef description */
-	if (!cfg80211_chandef_valid(&chandef))
-		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
-
-	memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
+	memcpy(&mac->chandef, &chdef, sizeof(mac->chandef));
 
 	for (i = 0; i < QTNF_MAX_INTF; i++) {
 		vif = &mac->iflist[i];
@@ -401,7 +397,7 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 
 		if (vif->netdev) {
 			mutex_lock(&vif->wdev.mtx);
-			cfg80211_ch_switch_notify(vif->netdev, &chandef);
+			cfg80211_ch_switch_notify(vif->netdev, &chdef);
 			mutex_unlock(&vif->wdev.mtx);
 		}
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index a69fd470..5936854 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -118,6 +118,20 @@ enum qlink_channel_width {
 	QLINK_CHAN_WIDTH_160,
 };
 
+/**
+ * struct qlink_chandef - qlink channel definition
+ *
+ * @center_freq1: center frequency of first segment
+ * @center_freq2: center frequency of second segment (80+80 only)
+ * @width: channel width, one of @enum qlink_channel_width
+ */
+struct qlink_chandef {
+	__le16 center_freq1;
+	__le16 center_freq2;
+	u8 width;
+	u8 rsvd[3];
+} __packed;
+
 /* QLINK Command messages related definitions
  */
 
@@ -764,11 +778,11 @@ struct qlink_event_bss_leave {
 /**
  * struct qlink_event_freq_change - data for QLINK_EVENT_FREQ_CHANGE event
  *
- * @freq: new operating frequency in MHz
+ * @chan: new operating channel definition
  */
 struct qlink_event_freq_change {
 	struct qlink_event ehdr;
-	__le32 freq;
+	struct qlink_chandef chan;
 } __packed;
 
 enum qlink_rxmgmt_flags {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 369b77d..3c1db5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -75,3 +75,55 @@ u8 qlink_chan_width_mask_to_nl(u16 qlink_mask)
 
 	return result;
 }
+
+static enum nl80211_chan_width qlink_chanwidth_to_nl(u8 qlw)
+{
+	switch (qlw) {
+	case QLINK_CHAN_WIDTH_20_NOHT:
+		return NL80211_CHAN_WIDTH_20_NOHT;
+	case QLINK_CHAN_WIDTH_20:
+		return NL80211_CHAN_WIDTH_20;
+	case QLINK_CHAN_WIDTH_40:
+		return NL80211_CHAN_WIDTH_40;
+	case QLINK_CHAN_WIDTH_80:
+		return NL80211_CHAN_WIDTH_80;
+	case QLINK_CHAN_WIDTH_80P80:
+		return NL80211_CHAN_WIDTH_80P80;
+	case QLINK_CHAN_WIDTH_160:
+		return NL80211_CHAN_WIDTH_160;
+	case QLINK_CHAN_WIDTH_5:
+		return NL80211_CHAN_WIDTH_5;
+	case QLINK_CHAN_WIDTH_10:
+		return NL80211_CHAN_WIDTH_10;
+	default:
+		return -1;
+	}
+}
+
+void qlink_chandef_q2cfg(struct wiphy *wiphy,
+			 const struct qlink_chandef *qch,
+			 struct cfg80211_chan_def *chdef)
+{
+	chdef->center_freq1 = le16_to_cpu(qch->center_freq1);
+	chdef->center_freq2 = le16_to_cpu(qch->center_freq2);
+	chdef->width = qlink_chanwidth_to_nl(qch->width);
+
+	switch (chdef->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+		chdef->chan = ieee80211_get_channel(wiphy, chdef->center_freq1);
+		break;
+	case NL80211_CHAN_WIDTH_40:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		chdef->chan = ieee80211_get_channel(wiphy,
+						    chdef->center_freq1 - 10);
+		break;
+	default:
+		chdef->chan = NULL;
+		break;
+	}
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index de06c1e..5e49a8a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -19,6 +19,7 @@
 
 #include <linux/types.h>
 #include <linux/skbuff.h>
+#include <net/cfg80211.h>
 
 #include "qlink.h"
 
@@ -62,5 +63,8 @@ static inline void qtnf_cmd_skb_put_tlv_u16(struct sk_buff *skb,
 
 u16 qlink_iface_type_to_nl_mask(u16 qlink_type);
 u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
+void qlink_chandef_q2cfg(struct wiphy *wiphy,
+			 const struct qlink_chandef *qch,
+			 struct cfg80211_chan_def *chdef);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.9.5
