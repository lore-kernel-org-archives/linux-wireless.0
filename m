Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48330 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1IFIMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 04:12:37 -0400
Received: by wwe5 with SMTP id 5so593159wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 01:12:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211/cfg80211/mac80211: fix wme docs
Date: Tue,  6 Sep 2011 11:14:32 +0300
Message-Id: <1315296872-20424-1-git-send-email-eliad@wizery.com> (sfid-20110906_101241_755344_36AF25A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add/fix some missing docs.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
(thanks johannes for pointing out)

 include/linux/nl80211.h |    2 +-
 include/net/cfg80211.h  |    2 ++
 include/net/mac80211.h  |    3 +++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a3f352f..c37f9e7 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2493,7 +2493,7 @@ enum nl80211_hidden_ssid {
 /**
  * enum nl80211_sta_wme_attr - station WME attributes
  * @__NL80211_STA_WME_INVALID: invalid number for nested attribute
- * @NL80211_STA_WME_QUEUES: bitmap of uapsd queues.
+ * @NL80211_STA_WME_UAPSD_QUEUES: bitmap of uapsd queues.
  * @NL80211_STA_WME_MAX_SP: max service period.
  * @__NL80211_STA_WME_AFTER_LAST: internal
  * @NL80211_STA_WME_MAX: highest station WME attribute
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5390a89..f1659ea 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -441,6 +441,8 @@ enum plink_actions {
  * @plink_action: plink action to take
  * @plink_state: set the peer link state for a station
  * @ht_capa: HT capabilities of station
+ * @uapsd_queues: bitmap of queues configured for uapsd
+ * @max_sp: max Service Period
  */
 struct station_parameters {
 	u8 *supported_rates;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2e752df..df1b53f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -947,6 +947,9 @@ enum set_key_cmd {
  * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
+ * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
+ *	if wme is supported.
+ * @max_sp: max Service Period. Only valid if wme is supported.
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
-- 
1.7.6.401.g6a319

