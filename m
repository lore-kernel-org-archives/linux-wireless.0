Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50482 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab1KUCXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 21:23:16 -0500
Received: by mail-yx0-f174.google.com with SMTP id q3so4209472yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 18:23:16 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kolya <mar.kolya@gmail.com>
Subject: [PATCH 3/3] mac80211: format debugfs agg_status output
Date: Sun, 20 Nov 2011 21:22:52 -0500
Message-Id: <1321842172-6732-4-git-send-email-mar.kolya@gmail.com> (sfid-20111121_032319_806351_85B2CE38)
In-Reply-To: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
References: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: kolya <mar.kolya@gmail.com>

---
 net/mac80211/debugfs_sta.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index c5f3417..e010419 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -154,7 +154,7 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, sizeof(buf) + buf - p,
-		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
+		       "TID\t\tRX active\tDTKN\tSSN\t\tTX active\tDTKN\ttimeout\tpending\n");
 
 	for (i = 0; i < STA_TID_NUM; i++) {
 		tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[i]);
@@ -162,14 +162,16 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_rx);
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%#.2x",
 				tid_rx ? tid_rx->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
 				tid_rx ? tid_rx->ssn : 0);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_tx);
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%#.2x",
 				tid_tx ? tid_tx->dialog_token : 0);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%d",
+                               tid_tx ? (int)tid_tx->timeout : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%03d",
 				tid_tx ? skb_queue_len(&tid_tx->pending) : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\n");
-- 
1.7.4.1

