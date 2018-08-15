Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:7323 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727842AbeHOD0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 23:26:09 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH 1/3] nl80211: add support to configure FTM responder functionality
Date: Tue, 14 Aug 2018 17:30:16 -0700
Message-Id: <1534293018-4930-2-git-send-email-pradeepc@codeaurora.org> (sfid-20180815_023634_636194_3129F7BD)
In-Reply-To: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow userspace to enable or disable fine timing measurement
responder functionality in AP mode. This can be done at AP start.

A new EXT_FEATURE flag is introduced for drivers to advertise
the capability.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 20 ++++++++++++++++++++
 net/wireless/nl80211.c       | 19 +++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9a850973e09a..beb383a41657 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -851,6 +851,7 @@ struct cfg80211_bitrate_mask {
  * @vht_cap: VHT capabilities (or %NULL if VHT isn't enabled)
  * @ht_required: stations must support HT
  * @vht_required: stations must support VHT
+ * @ftm_responder: enable or disable FTM responder functionality
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -875,6 +876,7 @@ struct cfg80211_ap_settings {
 	const struct ieee80211_ht_cap *ht_cap;
 	const struct ieee80211_vht_cap *vht_cap;
 	bool ht_required, vht_required;
+	int ftm_responder;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f34942..0a64034343c7 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2241,6 +2241,11 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_FTM_RESPONDER: attribute which user-space can include in
+ *	%NL80211_CMD_START_AP to enable(1) or disable(0) fine timing measurement
+ *	(FTM) responder functionality.  If not set, it means don't care and
+ *	the device will decide what to use.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2687,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_FTM_RESPONDER,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5223,6 +5230,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT: Driver/device can omit all data
  *	except for supported rates from the probe request content if requested
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
+ * @NL80211_EXT_FEATURE_SET_FTM_RESPONDER: Driver supports enabling and
+ *	disabling fine timing measurement responder role.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5259,6 +5268,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_TXQS,
 	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
+	NL80211_EXT_FEATURE_SET_FTM_RESPONDER,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5798,4 +5808,14 @@ enum nl80211_external_auth_action {
 	NL80211_EXTERNAL_AUTH_ABORT,
 };
 
+/**
+ * enum nl80211_ftm_responder_state - fine timing measurement responder state
+ * @NL80211_FTM_RESP_DISABLED: FTM responder is disabled
+ * @NL80211_FTM_RESP_ENABLED: FTM responder is enabled
+ */
+enum nl80211_ftm_responder_state {
+	NL80211_FTM_RESP_DISABLED,
+	NL80211_FTM_RESP_ENABLED,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5fb9b7dd9831..dfdc1cb07add 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -430,6 +430,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
+	[NL80211_ATTR_FTM_RESPONDER] = { .type = NLA_U32},
 };
 
 /* policy for the key attributes */
@@ -4339,6 +4340,24 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	params.ftm_responder = -1;
+	if (info->attrs[NL80211_ATTR_FTM_RESPONDER]) {
+		if (!wiphy_ext_feature_isset(
+			    &rdev->wiphy,
+			    NL80211_EXT_FEATURE_SET_FTM_RESPONDER)) {
+			GENL_SET_ERR_MSG(info,
+					 "FTM Responder config not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		params.ftm_responder =
+			nla_get_u32(info->attrs[NL80211_ATTR_FTM_RESPONDER]);
+
+		if (params.ftm_responder != NL80211_FTM_RESP_DISABLED &&
+		    params.ftm_responder != NL80211_FTM_RESP_ENABLED)
+			return -EINVAL;
+	}
+
 	nl80211_calculate_ap_params(&params);
 
 	wdev_lock(wdev);
-- 
1.9.1
