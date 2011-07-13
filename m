Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46038 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243Ab1GML5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 07:57:39 -0400
Received: by mail-bw0-f54.google.com with SMTP id 20so6731592bwa.41
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 04:57:37 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH 1/2] nl80211/cfg80211: add max_sched_scan_ssids in the hw description
Date: Wed, 13 Jul 2011 14:57:28 +0300
Message-Id: <1310558249-15944-2-git-send-email-coelho@ti.com> (sfid-20110713_135742_938573_690EEA16)
In-Reply-To: <1310558249-15944-1-git-send-email-coelho@ti.com>
References: <1310558249-15944-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chips can scan more SSIDs with a single scheduled scan command
than with a single normal scan command (eg. wl12xx chips).

To support this, this patch creates a separate hardware description
element that describes the amount of SSIDs supported in scheduled
scans.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |    4 +++-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3ec2f94..4a94cee 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -755,6 +755,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MAX_NUM_SCAN_SSIDS: number of SSIDs you can scan with
  *	a single scan request, a wiphy attribute.
+ * @NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS: number of SSIDs you can
+ *	scan with a single scheduled scan request, a wiphy attribute.
  * @NL80211_ATTR_MAX_SCAN_IE_LEN: maximum length of information elements
  *	that can be added to a scan request
  *
@@ -1209,6 +1211,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_REKEY_DATA,
 
+	NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4bf101b..bf3c4ae 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1742,6 +1742,8 @@ struct wiphy_wowlan_support {
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
  *	any given scan
+ * @max_sched_scan_ssids: maximum number of SSIDs the device can scan
+ *	for in any given scheduled scan
  * @max_scan_ie_len: maximum length of user-controlled IEs device can
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
@@ -1796,6 +1798,7 @@ struct wiphy {
 
 	int bss_priv_size;
 	u8 max_scan_ssids;
+	u8 max_sched_scan_ssids;
 	u16 max_scan_ie_len;
 
 	int n_cipher_suites;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6a82c89..348dc45 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -692,6 +692,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    dev->wiphy.coverage_class);
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
+	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
+		   dev->wiphy.max_sched_scan_ssids);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
 		    dev->wiphy.max_scan_ie_len);
 
@@ -3497,7 +3499,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 				    tmp)
 			n_ssids++;
 
-	if (n_ssids > wiphy->max_scan_ssids)
+	if (n_ssids > wiphy->max_sched_scan_ssids)
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_IE])
-- 
1.7.1

