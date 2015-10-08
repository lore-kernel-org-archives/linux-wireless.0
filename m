Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61824 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbbJHNu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 09:50:56 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] mac80211: Fix hwflags debugfs file format
Date: Thu, 8 Oct 2015 19:20:14 +0530
Message-ID: <1444312214-10669-1-git-send-email-mohammed@qti.qualcomm.com> (sfid-20151008_155108_269433_35A37DEB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Commit 30686bf7f5b3 ("mac80211: convert HW flags to unsigned long
bitmap") accidentally removed the newline delimiter from the hwflags
debugfs file. Fix this by adding back the newline between the HW flags.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
[fix commit log]
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3636b45..4d2aaeb 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -151,7 +151,7 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 
 	for (i = 0; i < NUM_IEEE80211_HW_FLAGS; i++) {
 		if (test_bit(i, local->hw.flags))
-			pos += scnprintf(pos, end - pos, "%s",
+			pos += scnprintf(pos, end - pos, "%s\n",
 					 hw_flag_names[i]);
 	}
 
-- 
1.7.9.5

