Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39369 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1K0WQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 17:16:18 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so3310820vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 14:16:17 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 2/2] mac80211: add session timeout to agg_status debugfs file
Date: Sun, 27 Nov 2011 17:15:53 -0500
Message-Id: <1322432153-17425-3-git-send-email-mar.kolya@gmail.com> (sfid-20111127_231621_180421_D01466C2)
In-Reply-To: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
References: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Add session timeout value for both rx and tx agg sessions to
agg_status debugfs file.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/debugfs_sta.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2406b3e..c2a0063 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -154,24 +154,29 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, sizeof(buf) + buf - p,
-		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
+		       "TID\t\tRX active\tDTKN\tSSN\ttimeout\t\t"
+		       "TX active\tDTKN\tpending\ttimeout\n");
 
 	for (i = 0; i < STA_TID_NUM; i++) {
 		tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[i]);
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[i]);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_rx);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t\t%x", !!tid_rx);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
 				tid_rx ? tid_rx->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
 				tid_rx ? tid_rx->ssn : 0);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%d",
+				tid_rx ? tid_rx->timeout : 0);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_tx);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
 				tid_tx ? tid_tx->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%03d",
 				tid_tx ? skb_queue_len(&tid_tx->pending) : 0);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%d",
+				tid_tx ? tid_tx->timeout : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\n");
 	}
 	rcu_read_unlock();
-- 
1.7.4.1

