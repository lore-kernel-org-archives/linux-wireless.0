Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935462AbcCQNDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:03:23 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: clean up station flags debugfs
Date: Thu, 17 Mar 2016 15:02:54 +0200
Message-Id: <1458219775-24450-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_140327_175314_02B79C3D)
In-Reply-To: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Avoid the really strange %s%s%s expression, use an array
of flag names and check that all flags are present.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 63 +++++++++++++++++++++++++++++++---------------
 net/mac80211/sta_info.h    |  4 +++
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index fbbd66c..6f89cd7 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -52,31 +52,54 @@ static const struct file_operations sta_ ##name## _ops = {		\
 
 STA_FILE(aid, sta.aid, D);
 
+static const char * const sta_flag_names[] = {
+#define FLAG(F) [WLAN_STA_##F] = #F
+	FLAG(AUTH),
+	FLAG(ASSOC),
+	FLAG(PS_STA),
+	FLAG(AUTHORIZED),
+	FLAG(SHORT_PREAMBLE),
+	FLAG(WDS),
+	FLAG(CLEAR_PS_FILT),
+	FLAG(MFP),
+	FLAG(BLOCK_BA),
+	FLAG(PS_DRIVER),
+	FLAG(PSPOLL),
+	FLAG(TDLS_PEER),
+	FLAG(TDLS_PEER_AUTH),
+	FLAG(TDLS_INITIATOR),
+	FLAG(TDLS_CHAN_SWITCH),
+	FLAG(TDLS_OFF_CHANNEL),
+	FLAG(TDLS_WIDER_BW),
+	FLAG(UAPSD),
+	FLAG(SP),
+	FLAG(4ADDR_EVENT),
+	FLAG(INSERTED),
+	FLAG(RATE_CONTROL),
+	FLAG(TOFFSET_KNOWN),
+	FLAG(MPSP_OWNER),
+	FLAG(MPSP_RECIPIENT),
+	FLAG(PS_DELIVER),
+#undef FLAG
+};
+
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)
 {
-	char buf[121];
+	char buf[16 * NUM_WLAN_STA_FLAGS], *pos = buf;
+	char *end = buf + sizeof(buf) - 1;
 	struct sta_info *sta = file->private_data;
+	unsigned int flg;
+
+	BUILD_BUG_ON(ARRAY_SIZE(sta_flag_names) != NUM_WLAN_STA_FLAGS);
+
+	for (flg = 0; flg < NUM_WLAN_STA_FLAGS; flg++) {
+		if (test_sta_flag(sta, flg))
+			pos += scnprintf(pos, end - pos, "%s\n",
+					 sta_flag_names[flg]);
+	}
 
-#define TEST(flg) \
-	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
-
-	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
-			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
-			    TEST(PS_DRIVER), TEST(AUTHORIZED),
-			    TEST(SHORT_PREAMBLE),
-			    sta->sta.wme ? "WME\n" : "",
-			    TEST(WDS), TEST(CLEAR_PS_FILT),
-			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
-			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
-			    TEST(TDLS_PEER_AUTH), TEST(TDLS_INITIATOR),
-			    TEST(TDLS_CHAN_SWITCH), TEST(TDLS_OFF_CHANNEL),
-			    TEST(4ADDR_EVENT), TEST(INSERTED),
-			    TEST(RATE_CONTROL), TEST(TOFFSET_KNOWN),
-			    TEST(MPSP_OWNER), TEST(MPSP_RECIPIENT));
-#undef TEST
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
 }
 STA_OPS(flags);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 053f5c4..fc91290 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -69,6 +69,8 @@
  * @WLAN_STA_MPSP_RECIPIENT: local STA is recipient of a MPSP.
  * @WLAN_STA_PS_DELIVER: station woke up, but we're still blocking TX
  *	until pending frames are delivered
+ *
+ * @NUM_WLAN_STA_FLAGS: number of defined flags
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -97,6 +99,8 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+
+	NUM_WLAN_STA_FLAGS,
 };
 
 #define ADDBA_RESP_INTERVAL HZ
-- 
2.5.0

