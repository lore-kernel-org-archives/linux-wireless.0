Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43813 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967028Ab2ERMDT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:19 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/6] mac80211: introduce new ieee80211_ops
Date: Fri, 18 May 2012 14:03:05 +0200
Message-ID: <1337342589-10617-3-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140336_783499_FFAF60D1)
In-Reply-To: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduces channel context callbacks. Channel on a
context channel is immutable. Channel type will be
changable later though, thus change_channel_type is
adveristed.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 75a613f..1e5722b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2262,6 +2262,18 @@ enum ieee80211_rate_control_changed {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
+ * @add_channel_context: Notifies device driver about new channel
+ *	context creation.
+ * @remove_channel_context: Notifies device driver about channel context
+ *	destruction.
+ * @change_channel_type: Notifies device driver about channel context
+ *	channel_type change which may happen when combining different vifs on
+ *	a same channel with different HTs.
+ * @assign_vif_channel_context: Notifies device driver about channel
+ *	context being bound to vif. Possible use is for hw queue
+ *	remapping.
+ * @unassign_vif_channel_context: Notifies device driver about channel
+ *	context being unbound from vif.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2401,6 +2413,19 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
+
+	void (*add_channel_context)(struct ieee80211_hw *hw,
+				    struct ieee80211_channel_context *ctx);
+	void (*remove_channel_context)(struct ieee80211_hw *hw,
+				       struct ieee80211_channel_context *ctx);
+	void (*change_channel_type)(struct ieee80211_hw *hw,
+				    struct ieee80211_channel_context *ctx);
+	void (*assign_vif_channel_context)(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   struct ieee80211_channel_context *ctx);
+	void (*unassign_vif_channel_context)(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_channel_context *ctx);
 };
 
 /**
-- 
1.7.0.4

