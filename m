Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab1KWPlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:41:10 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so572756vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:41:09 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 2/5] cfg80211: add support to immediately apply reg settings
Date: Wed, 23 Nov 2011 10:40:55 -0500
Message-Id: <1322062858-15276-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_164114_908482_5AFBED2B)
In-Reply-To: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is useful to apply reguatory settings immediately. We already
handle applying regulatory hints immediatey for most hints but
for user hints and country IE hints we want to kick hardware
immediately to make these changes take effect. This adds supports
to let us kick hardware to make the changes take effect as soon
as possible.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/linux/nl80211.h |    4 ++++
 net/wireless/core.c     |   23 +++++++++++++++++++++++
 net/wireless/core.h     |    2 ++
 net/wireless/nl80211.c  |    5 +++++
 net/wireless/reg.c      |    8 ++++++++
 5 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 97bfebf..5f68f60 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2452,11 +2452,15 @@ enum nl80211_cqm_rssi_threshold_event {
  * @NL80211_TX_POWER_AUTOMATIC: automatically determine transmit power
  * @NL80211_TX_POWER_LIMITED: limit TX power by the mBm parameter
  * @NL80211_TX_POWER_FIXED: fix TX power to the mBm parameter
+ * @NL80211_TX_POWER_REG: adjust tx power based on the latest
+ *	regulatory update. The driver must inspect the chan->max_power,
+ *	the mBm power passed will always be 0 and can be ignored.
  */
 enum nl80211_tx_power_setting {
 	NL80211_TX_POWER_AUTOMATIC,
 	NL80211_TX_POWER_LIMITED,
 	NL80211_TX_POWER_FIXED,
+	NL80211_TX_POWER_REG,
 };
 
 /**
diff --git a/net/wireless/core.c b/net/wireless/core.c
index ccdfed8..9cac8c3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -478,6 +478,29 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	return 0;
 }
 
+/*
+ * Kicks the hardware to apply immediately any needed regulatory
+ * changes. This is an optimization to ensure values are propagated
+ * to hardware right away. Most regulatory hints are applied immediately
+ * but for country IE hints and user hints this will ensure we apply the
+ * changes immediately.
+ */
+int wiphy_reg_config_update(struct wiphy *wiphy)
+{
+	int r;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	if (!rdev || !rdev->ops->set_tx_power)
+		return -EINVAL;
+	r = rdev->ops->set_tx_power(wiphy, NL80211_TX_POWER_REG, 0);
+	/*
+	 * XXX: trigger disconnect if operating channel / channel type
+	 * is not allowed due to a new regulatory update. What do we
+	 * want to do here?
+	 */
+	return r;
+}
+
 int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index fb08c28..6c852d3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -462,6 +462,8 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int);
 
+int wiphy_reg_config_update(struct wiphy *wiphy);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a1cabde..3dd2e91 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1329,6 +1329,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		idx = NL80211_ATTR_WIPHY_TX_POWER_SETTING;
 		type = nla_get_u32(info->attrs[idx]);
 
+		if (type == NL80211_TX_POWER_REG) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
 		if (!info->attrs[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] &&
 		    (type != NL80211_TX_POWER_AUTOMATIC)) {
 			result = -EINVAL;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3f9f318..38b1214 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1142,6 +1142,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
+	int r;
 
 	assert_reg_lock();
 
@@ -1159,6 +1160,13 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	reg_process_ht_flags(wiphy);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
+
+	r = wiphy_reg_config_update(wiphy);
+	if (!r) {
+		REG_DBG_PRINT("Unable to immediately apply "
+			      "regulatory updates on %s\n",
+			      wiphy_name(wiphy));
+	}
 }
 
 void regulatory_update(struct wiphy *wiphy,
-- 
1.7.4.15.g7811d

