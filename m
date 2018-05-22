Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbeEVJQF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 05:16:05 -0400
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCH] cfg80211: Add cumulative channel survey dump support.
Date: Tue, 22 May 2018 14:45:56 +0530
Message-Id: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180522_111610_168903_E351497E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch provides support to send accumulated survey data to
user if low level drivers provides non-accumulated survey data.

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
 include/net/cfg80211.h |  5 +++++
 net/wireless/core.c    | 21 +++++++++++++++++++++
 net/wireless/nl80211.c | 34 +++++++++++++++++++++++++++++++++-
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc40843..e0ecd7d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -580,6 +580,7 @@ ieee80211_chandef_max_power(struct cfg80211_chan_def *chandef)
  * @SURVEY_INFO_TIME_RX: receive time was filled in
  * @SURVEY_INFO_TIME_TX: transmit time was filled in
  * @SURVEY_INFO_TIME_SCAN: scan time was filled in
+ * @SURVEY_INFO_NON_ACC_DATA: non accumulated survey data filled in
  *
  * Used by the driver to indicate which info in &struct survey_info
  * it has filled in during the get_survey().
@@ -593,6 +594,7 @@ enum survey_info_flags {
 	SURVEY_INFO_TIME_RX		= BIT(5),
 	SURVEY_INFO_TIME_TX		= BIT(6),
 	SURVEY_INFO_TIME_SCAN		= BIT(7),
+	SURVEY_INFO_NON_ACC_DATA        = BIT(8),
 };
 
 /**
@@ -3787,6 +3789,7 @@ struct wiphy_iftype_ext_capab {
  *	bitmap of &enum nl80211_band values.  For instance, for
  *	NL80211_BAND_2GHZ, bit 0 would be set
  *	(i.e. BIT(NL80211_BAND_2GHZ)).
+ * @cumulative_survey: cumulated survey information for all channels.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3921,6 +3924,8 @@ struct wiphy {
 
 	u8 nan_supported_bands;
 
+	struct survey_info *cumulative_survey;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 670aa229..4646769 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -633,6 +633,9 @@ int wiphy_register(struct wiphy *wiphy)
 	struct ieee80211_supported_band *sband;
 	bool have_band = false;
 	int i;
+	int n_channels = 0;
+	int idx = 0;
+
 	u16 ifmodes = wiphy->interface_modes;
 
 #ifdef CONFIG_PM
@@ -782,6 +785,7 @@ int wiphy_register(struct wiphy *wiphy)
 		}
 
 		have_band = true;
+		n_channels += sband->n_channels;
 	}
 
 	if (!have_band) {
@@ -866,6 +870,21 @@ int wiphy_register(struct wiphy *wiphy)
 		}
 	}
 
+	wiphy->cumulative_survey = kcalloc(n_channels,
+					   sizeof(struct survey_info),
+					   GFP_KERNEL);
+	if (!wiphy->cumulative_survey)
+		return -ENOMEM;
+
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+		for (i = 0; i < sband->n_channels; i++)
+			wiphy->cumulative_survey[idx++].channel =
+				&sband->channels[i];
+	}
+
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
@@ -955,6 +974,8 @@ void wiphy_unregister(struct wiphy *wiphy)
 #endif
 	cfg80211_rdev_free_wowlan(rdev);
 	cfg80211_rdev_free_coalesce(rdev);
+
+	kfree(wiphy->cumulative_survey);
 }
 EXPORT_SYMBOL(wiphy_unregister);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fe27ab4..2f22d74 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8024,11 +8024,13 @@ static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nlattr **attrbuf = genl_family_attrbuf(&nl80211_fam);
 	struct survey_info survey;
+	struct survey_info *survey_data = &survey;
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 	int survey_idx = cb->args[2];
 	int res;
 	bool radio_stats;
+	int n_channels;
 
 	rtnl_lock();
 	res = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
@@ -8048,7 +8050,12 @@ static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 		goto out_err;
 	}
 
+	n_channels = ieee80211_get_num_supported_channels(wdev->wiphy);
+
 	while (1) {
+		if (n_channels <= survey_idx)
+			break;
+
 		res = rdev_dump_survey(rdev, wdev->netdev, survey_idx, &survey);
 		if (res == -ENOENT)
 			break;
@@ -8062,10 +8069,35 @@ static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 		}
 
+		if (survey.filled & SURVEY_INFO_NON_ACC_DATA) {
+			struct survey_info *cumulative_survey =
+				&wdev->wiphy->cumulative_survey[survey_idx];
+
+			if (cumulative_survey->channel->center_freq !=
+					survey.channel->center_freq) {
+				survey_idx++;
+				continue;
+			}
+			if (survey.filled & SURVEY_INFO_NOISE_DBM)
+				cumulative_survey->noise = survey.noise;
+			if (survey.filled & SURVEY_INFO_TIME)
+				cumulative_survey->time += survey.time;
+			if (survey.filled & SURVEY_INFO_TIME_BUSY)
+				cumulative_survey->time_busy +=
+							survey.time_busy;
+			if (survey.filled & SURVEY_INFO_TIME_RX)
+				cumulative_survey->time_rx += survey.time_rx;
+			if (survey.filled & SURVEY_INFO_TIME_TX)
+				cumulative_survey->time_tx += survey.time_tx;
+
+			cumulative_survey->filled |= survey.filled;
+			survey_data = cumulative_survey;
+		}
+
 		if (nl80211_send_survey(skb,
 				NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				wdev->netdev, radio_stats, &survey) < 0)
+				wdev->netdev, radio_stats, survey_data) < 0)
 			goto out;
 		survey_idx++;
 	}
-- 
2.7.4
