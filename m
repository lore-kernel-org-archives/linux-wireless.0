Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5736 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3IQTb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:58 -0400
From: Chet Lanctot <clanctot@codeaurora.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chet Lanctot <clanctot@codeaurora.org>
Subject: [PATCH 1/2] nl80211/cfg80211: Driver with AP SME advertises need for PMF SA Query
Date: Tue, 17 Sep 2013 12:31:35 -0700
Message-Id: <1379446296-22236-2-git-send-email-clanctot@codeaurora.org> (sfid-20130917_213226_743831_B2F42172)
In-Reply-To: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for drivers that have AP SME integrated but do not implement
The SA Query procedure that is part of Protected Management Frames
(PMF, 802.11w).  Instead, the need for upper layer software to do
this procedure is advertised through nl80211/cfg80211.

Signed-off-by: Chet Lanctot <clanctot@codeaurora.org>
---
 include/uapi/linux/nl80211.h | 11 ++++++++---
 net/wireless/nl80211.c       |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index eb68735..aa1d122 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1891,6 +1891,9 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with drivers
  *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
  *	previously added station into associated state
+ * @NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED: no SA Query procedure is needed
+ *	when an association request is received from a station with which there
+ *	is already a MFP connection
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1903,6 +1906,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_AUTHENTICATED,
 	NL80211_STA_FLAG_TDLS_PEER,
 	NL80211_STA_FLAG_ASSOCIATED,
+	NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -3648,11 +3652,12 @@ enum nl80211_tdls_operation {
 
 /*
  * enum nl80211_ap_sme_features - device-integrated AP features
- * Reserved for future use, no bits are defined in
- * NL80211_ATTR_DEVICE_AP_SME yet.
+ * @NL80211_ATTR_AP_SME_NO_SA_QUERY: This device is not able to do
+ *	the MFP SA query procedure and needs hostapd to do this procedure
+ */
 enum nl80211_ap_sme_features {
+	NL80211_AP_SME_FEATURE_NO_SA_QUERY
 };
- */
 
 /**
  * enum nl80211_feature_flags - device/driver features
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 587ff84..14a14d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3766,7 +3766,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_ASSOCIATED) |
 				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
 				  BIT(NL80211_STA_FLAG_WME) |
-				  BIT(NL80211_STA_FLAG_MFP)))
+				  BIT(NL80211_STA_FLAG_MFP) |
+				  BIT(NL80211_STA_FLAG_SA_QUERY_REQUIRED)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
-- 
1.7.12.rc0.22.gcdd159b

