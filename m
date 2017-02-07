Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47886 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754587AbdBGNVJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 08:21:09 -0500
Date: Tue, 7 Feb 2017 16:20:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: check for allocation failure in debugfs code
Message-ID: <20170207132052.GE27416@mwanda> (sfid-20170207_142122_696541_22DF4450)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kmalloc() can fail.  Also let's move the allocation out of the
declaration block so it's easier to read.

Fixes: 4a5eccaa9350 ("mac80211: Show pending txqlen in debugfs.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index f62cd0e13c58..4689353aa263 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -249,12 +249,19 @@ static ssize_t misc_read(struct file *file, char __user *user_buf,
 	struct ieee80211_local *local = file->private_data;
 	/* Max len of each line is 16 characters, plus 9 for 'pending:\n' */
 	size_t bufsz = IEEE80211_MAX_QUEUES * 16 + 9;
-	char *buf = kzalloc(bufsz, GFP_KERNEL);
-	char *pos = buf, *end = buf + bufsz - 1;
+	char *buf;
+	char *pos, *end;
 	ssize_t rv;
 	int i;
 	int ln;
 
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	pos = buf;
+	end = buf + bufsz - 1;
+
 	pos += scnprintf(pos, end - pos, "pending:\n");
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
