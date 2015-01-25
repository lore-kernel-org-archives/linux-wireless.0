Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:55446 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbbAYMbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 07:31:07 -0500
From: Dedy Lansky <dlansky@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: [PATCH] nl80211: add new scan flag to indicate P2P search
Date: Sun, 25 Jan 2015 14:30:52 +0200
Message-Id: <1422189052-25602-1-git-send-email-dlansky@codeaurora.org> (sfid-20150125_133111_186132_D4506291)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scan request (NL80211_CMD_TRIGGER_SCAN) is used for triggering both scan
and P2P search.
At driver/firmware layer, scan and P2P search might be handled differently.

Add new scan flag to indicate P2P search. This flag can be used
by applications (e.g. wpa_supplicant) to explicitly request P2P search.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 include/uapi/linux/nl80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f52797a..d7d07d6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4383,12 +4383,14 @@ enum nl80211_connect_failed_reason {
  *	locally administered 1, multicast 0) is assumed.
  *	This flag must not be requested when the feature isn't supported, check
  *	the nl80211 feature flags for the device.
+ * @NL80211_SCAN_FLAG_P2P: indicate this is a request for a P2P search
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 	NL80211_SCAN_FLAG_RANDOM_ADDR			= 1<<3,
+	NL80211_SCAN_FLAG_P2P				= 1<<4,
 };
 
 /**
-- 
1.9.1

