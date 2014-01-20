Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaATMAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 07:00:30 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5DWn-0007ie-JV
	for linux-wireless@vger.kernel.org; Mon, 20 Jan 2014 13:00:29 +0100
Message-ID: <1390219227.4335.23.camel@jlt4.sipsolutions.net> (sfid-20140120_130033_724267_C527C083)
Subject: [PATCH] mac80211: fix agg_status debugfs file write
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Jan 2014 13:00:27 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Initialize the buffer to all zeroes, otherwise the stack
data might be interpreted as the TID, which is likely to
fail completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 80194b5..2ecb4de 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -195,7 +195,7 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 static ssize_t sta_agg_status_write(struct file *file, const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	char _buf[12], *buf = _buf;
+	char _buf[12] = {}, *buf = _buf;
 	struct sta_info *sta = file->private_data;
 	bool start, tx;
 	unsigned long tid;
-- 
1.8.5.1



