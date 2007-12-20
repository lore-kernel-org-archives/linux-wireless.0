Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34023 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbXLTJse (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 04:48:34 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/8 v2] mac80211: A-MPDU Rx add low level driver API
Date: Thu, 20 Dec 2007 11:39:05 +0200
Message-Id: <11981435614092-git-send-email-ron.rindjunsky@intel.com> (sfid-20071220_094842_754848_B6AA4869)
In-Reply-To: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the API to perform A-MPDU actions between mac80211 and low
level driver.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0d67b33..418cd38 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -915,6 +915,18 @@ enum ieee80211_erp_change_flags {
 	IEEE80211_ERP_CHANGE_PREAMBLE	= 1<<1,
 };
 
+/**
+ * enum ieee80211_ampdu_mlme_action - A-MPDU actions
+ *
+ * These flags are used with the ampdu_action() callback in
+ * &struct ieee80211_ops to indicate which action is needed.
+ * @IEEE80211_AMPDU_RX_START: start Rx aggregation
+ * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
+ */
+enum ieee80211_ampdu_mlme_action {
+	IEEE80211_AMPDU_RX_START,
+	IEEE80211_AMPDU_RX_STOP,
+};
 
 /**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
@@ -1043,6 +1055,12 @@ enum ieee80211_erp_change_flags {
  *	used to determine whether to reply to Probe Requests.
  *
  * @conf_ht: Configures low level driver with 802.11n HT data. Must be atomic.
+ *
+ * @ampdu_action: Perform a certain A-MPDU action
+ * 	The RA/TID combination determines the destination and TID we want
+ * 	the ampdu action to be performed for. The action is defined through
+ * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
+ * 	is the first frame we expect to perform the action on.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -1089,6 +1107,9 @@ struct ieee80211_ops {
 			     struct ieee80211_tx_control *control);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
+	int (*ampdu_action)(struct ieee80211_hw *hw,
+			    enum ieee80211_ampdu_mlme_action action,
+			    const u8 *ra, u16 tid, u16 ssn);
 };
 
 /**
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

