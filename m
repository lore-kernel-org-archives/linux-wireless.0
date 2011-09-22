Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1IVPu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:50:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lXf-0002Rg-SD
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:50:27 +0200
Message-Id: <20110922154851.859347080@sipsolutions.net> (sfid-20110922_175033_652097_0C4A3200)
Date: Thu, 22 Sep 2011 17:47:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 12/15] mac80211: add missing station flags to debugfs
References: <20110922154726.521122680@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My work and some previous work didn't add
all the flags, add them now and while at it
simplify the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/net/mac80211/debugfs_sta.c	2011-09-22 15:12:26.000000000 +0200
+++ b/net/mac80211/debugfs_sta.c	2011-09-22 15:15:29.000000000 +0200
@@ -56,19 +56,21 @@ STA_FILE(last_signal, last_signal, D);
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
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
+			    TEST(PS_DRIVER), TEST(AUTHORIZED),
+			    TEST(SHORT_PREAMBLE), TEST(ASSOC_AP),
+			    TEST(WME), TEST(WDS), TEST(CLEAR_PS_FILT),
+			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
+			    TEST(UAPSD), TEST(SP));
+#undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 STA_OPS(flags);


