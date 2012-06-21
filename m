Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56507 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab2FUMDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 08:03:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 2/7] mac80211: introduce new ieee80211_ops
Date: Thu, 21 Jun 2012 14:03:31 +0200
Message-ID: <1340280216-18807-3-git-send-email-michal.kazior@tieto.com> (sfid-20120621_140345_074456_166E8587)
In-Reply-To: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Introduces channel context callbacks. Channel on a
context channel is immutable. Channel type will be
changable later though, thus change_channel_type is
adveristed.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0089798..5040d6d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2295,6 +2295,15 @@ enum ieee80211_rate_control_changed {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
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
@@ -2434,6 +2443,19 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
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
1.7.0.4

