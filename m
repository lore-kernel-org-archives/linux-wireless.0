Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:56365 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab1GML5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 07:57:42 -0400
Received: by bwg12 with SMTP id 12so5443319bwg.26
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 04:57:39 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH 2/2] nl80211/cfg80211: add max_sched_scan_ie_len in the hw description
Date: Wed, 13 Jul 2011 14:57:29 +0300
Message-Id: <1310558249-15944-3-git-send-email-coelho@ti.com> (sfid-20110713_135745_281061_7C97708C)
In-Reply-To: <1310558249-15944-1-git-send-email-coelho@ti.com>
References: <1310558249-15944-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chips may support different lengths of user-supplied IEs with a
single scheduled scan command than with a single normal scan command.

To support this, this patch creates a separate hardware description
element that describes the maximum size of user-supplied information
element data supported in scheduled scans.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |    4 +++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4a94cee..9fc6392 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -759,6 +759,8 @@ enum nl80211_commands {
  *	scan with a single scheduled scan request, a wiphy attribute.
  * @NL80211_ATTR_MAX_SCAN_IE_LEN: maximum length of information elements
  *	that can be added to a scan request
+ * @NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN: maximum length of information
+ *	elements that can be added to a scheduled scan request
  *
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
@@ -1212,6 +1214,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_REKEY_DATA,
 
 	NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
+	NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bf3c4ae..1d1124a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1747,6 +1747,8 @@ struct wiphy_wowlan_support {
  * @max_scan_ie_len: maximum length of user-controlled IEs device can
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
+ * @max_sched_scan_ie_len: same as max_scan_ie_len, but for scheduled
+ *	scans
  * @coverage_class: current coverage class
  * @fw_version: firmware version for ethtool reporting
  * @hw_version: hardware version for ethtool reporting
@@ -1800,6 +1802,7 @@ struct wiphy {
 	u8 max_scan_ssids;
 	u8 max_sched_scan_ssids;
 	u16 max_scan_ie_len;
+	u16 max_sched_scan_ie_len;
 
 	int n_cipher_suites;
 	const u32 *cipher_suites;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 348dc45..dc2a314 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -696,6 +696,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		   dev->wiphy.max_sched_scan_ssids);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
 		    dev->wiphy.max_scan_ie_len);
+	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
+		    dev->wiphy.max_sched_scan_ie_len);
 
 	if (dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_IBSS_RSN);
@@ -3507,7 +3509,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	else
 		ie_len = 0;
 
-	if (ie_len > wiphy->max_scan_ie_len)
+	if (ie_len > wiphy->max_sched_scan_ie_len)
 		return -EINVAL;
 
 	mutex_lock(&rdev->sched_scan_mtx);
-- 
1.7.1

