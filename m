Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2G0LRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 02/20] mac80211: introduce new ieee80211_ops
Date: Fri, 27 Jul 2012 13:16:38 +0200
Message-Id: <1343387816-9414-3-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131726_864047_315838EB)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Introduces channel context callbacks. Channel on a
context channel is immutable. Channel type will be
changeable later though, thus change_chantype is
advertised.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6d19726..969eb20 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2292,6 +2292,16 @@ enum ieee80211_rate_control_changed {
  *	The callback will be called before each transmission and upon return
  *	mac80211 will transmit the frame right away.
  *	The callback is optional and can (should!) sleep.
+ *
+ * @add_chanctx: Notifies device driver about new channel context creation.
+ * @remove_chanctx: Notifies device driver about channel context destruction.
+ * @change_chantype: Notifies device driver about channel context channel_type
+ *	change which may happen when combining different vifs on a same channel
+ *	with different HTs.
+ * @assign_vif_chanctx: Notifies device driver about channel context being bound
+ *	to vif. Possible use is for hw queue remapping.
+ * @unassign_vif_chanctx: Notifies device driver about channel context being
+ *	unbound from vif.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2434,6 +2444,19 @@ struct ieee80211_ops {
 
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
+
+	void (*add_chanctx)(struct ieee80211_hw *hw,
+			    struct ieee80211_chanctx_conf *ctx);
+	void (*remove_chanctx)(struct ieee80211_hw *hw,
+			       struct ieee80211_chanctx_conf *ctx);
+	void (*change_chantype)(struct ieee80211_hw *hw,
+				struct ieee80211_chanctx_conf *ctx);
+	void (*assign_vif_chanctx)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_chanctx_conf *ctx);
+	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_chanctx_conf *ctx);
 };
 
 /**
-- 
1.7.10.4

