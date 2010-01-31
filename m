Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9763 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0AaAzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 19:55:38 -0500
Subject: [PATCH 2/2] mac80211: reduce stack usage in sta_agg_status_read()
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 30 Jan 2010 19:55:27 -0500
Message-ID: <20100131005527.22303.97956.stgit@mj.roinet.com>
In-Reply-To: <20100131005509.22303.74752.stgit@mj.roinet.com>
References: <20100131005509.22303.74752.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a more compact and readable format for "agg_status" to reduce the
stack frame to less than 1024 bytes.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/mac80211/debugfs_sta.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 84865e7..d92800b 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -120,36 +120,38 @@ STA_OPS(last_seq_ctrl);
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
-	char buf[30 + STA_TID_NUM * 70], *p = buf;
+	char buf[64 + STA_TID_NUM * 40], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
 
 	spin_lock_bh(&sta->lock);
-	p += scnprintf(p, sizeof(buf)+buf-p, "next dialog_token is %#02x\n",
+	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
+	p += scnprintf(p, sizeof(buf) + buf - p,
+		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tSSN\tpending\n");
 	for (i = 0; i < STA_TID_NUM; i++) {
-		p += scnprintf(p, sizeof(buf)+buf-p, "TID %02d:", i);
-		p += scnprintf(p, sizeof(buf)+buf-p, " RX=%x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
 				sta->ampdu_mlme.tid_state_rx[i]);
-		p += scnprintf(p, sizeof(buf)+buf-p, "/DTKN=%#.2x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
 				sta->ampdu_mlme.tid_state_rx[i] ?
 				sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
-		p += scnprintf(p, sizeof(buf)+buf-p, "/SSN=%#.3x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
 				sta->ampdu_mlme.tid_state_rx[i] ?
 				sta->ampdu_mlme.tid_rx[i]->ssn : 0);
 
-		p += scnprintf(p, sizeof(buf)+buf-p, " TX=%x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
 				sta->ampdu_mlme.tid_state_tx[i]);
-		p += scnprintf(p, sizeof(buf)+buf-p, "/DTKN=%#.2x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
 				sta->ampdu_mlme.tid_state_tx[i] ?
 				sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
-		p += scnprintf(p, sizeof(buf)+buf-p, "/SSN=%#.3x",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
 				sta->ampdu_mlme.tid_state_tx[i] ?
 				sta->ampdu_mlme.tid_tx[i]->ssn : 0);
-		p += scnprintf(p, sizeof(buf)+buf-p, "/pending=%03d",
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t%03d",
 				sta->ampdu_mlme.tid_state_tx[i] ?
 				skb_queue_len(&sta->ampdu_mlme.tid_tx[i]->pending) : 0);
-		p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+		p += scnprintf(p, sizeof(buf) + buf - p, "\n");
 	}
 	spin_unlock_bh(&sta->lock);
 
