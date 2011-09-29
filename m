Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1I2OG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 10:06:58 -0400
Message-Id: <20110929140501.919286960@sipsolutions.net> (sfid-20110929_160702_425958_9FCCDC22)
Date: Thu, 29 Sep 2011 16:04:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 12/16] mac80211: add missing station flags to debugfs
References: <20110929140425.390322480@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My work and some previous work didn't add
all the flags, add them now and while at it
simplify the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/net/mac80211/debugfs_sta.c	2011-09-29 16:03:25.000000000 +0200
+++ b/net/mac80211/debugfs_sta.c	2011-09-29 16:03:28.000000000 +0200
@@ -56,19 +56,22 @@ STA_FILE(last_signal, last_signal, D);
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)
 {
-	char buf[100];
+	char buf[121];
 	struct sta_info *sta = file->private_data;
 
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
-		test_sta_flag(sta, WLAN_STA_AUTH) ? "AUTH\n" : "",
-		test_sta_flag(sta, WLAN_STA_ASSOC) ? "ASSOC\n" : "",
-		test_sta_flag(sta, WLAN_STA_PS_STA) ? "PS (sta)\n" : "",
-		test_sta_flag(sta, WLAN_STA_PS_DRIVER) ? "PS (driver)\n" : "",
-		test_sta_flag(sta, WLAN_STA_AUTHORIZED) ? "AUTHORIZED\n" : "",
-		test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE) ? "SHORT PREAMBLE\n" : "",
-		test_sta_flag(sta, WLAN_STA_WME) ? "WME\n" : "",
-		test_sta_flag(sta, WLAN_STA_WDS) ? "WDS\n" : "",
-		test_sta_flag(sta, WLAN_STA_MFP) ? "MFP\n" : "");
+#define TEST(flg) \
+	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
+
+	int res = scnprintf(buf, sizeof(buf),
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
+			    TEST(PS_DRIVER), TEST(AUTHORIZED),
+			    TEST(SHORT_PREAMBLE), TEST(ASSOC_AP),
+			    TEST(WME), TEST(WDS), TEST(CLEAR_PS_FILT),
+			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
+			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
+			    TEST(TDLS_PEER_AUTH));
+#undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 STA_OPS(flags);


