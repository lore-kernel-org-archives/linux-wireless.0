Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33956 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbcESIgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 04:36:09 -0400
Received: by mail-lf0-f52.google.com with SMTP id m64so31605402lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 01:36:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv5 5/5] mac80211: add debug knobs for codel
Date: Thu, 19 May 2016 10:37:52 +0200
Message-Id: <1463647072-16201-6-git-send-email-michal.kazior@tieto.com> (sfid-20160519_103621_556530_AEF7DFB5)
In-Reply-To: <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
 <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few debugfs entries to make it easier
to test, debug and experiment.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v5:
     * use the single "aqm" debugfs knob [Dave]
    
    v4:
     * stats adjustments (in-kernel codel has more of them)

 net/mac80211/debugfs.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2906c1004e1a..53a315401a4b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -126,13 +126,31 @@ static int aqm_open(struct inode *inode, struct file *file)
 			 "R fq_overlimit %u\n"
 			 "R fq_collisions %u\n"
 			 "RW fq_limit %u\n"
-			 "RW fq_quantum %u\n",
+			 "RW fq_quantum %u\n"
+			 "R codel_maxpacket %u\n"
+			 "R codel_drop_count %u\n"
+			 "R codel_drop_len %u\n"
+			 "R codel_ecn_mark %u\n"
+			 "R codel_ce_mark %u\n"
+			 "RW codel_interval %u\n"
+			 "RW codel_target %u\n"
+			 "RW codel_mtu %u\n"
+			 "RW codel_ecn %u\n",
 			 fq->flows_cnt,
 			 fq->backlog,
 			 fq->overlimit,
 			 fq->collisions,
 			 fq->limit,
-			 fq->quantum);
+			 fq->quantum,
+			 local->cstats.maxpacket,
+			 local->cstats.drop_count,
+			 local->cstats.drop_len,
+			 local->cstats.ecn_mark,
+			 local->cstats.ce_mark,
+			 local->cparams.interval,
+			 local->cparams.target,
+			 local->cparams.mtu,
+			 local->cparams.ecn ? 1U : 0U);
 
 	len += scnprintf(info->buf + len,
 			 info->size - len,
@@ -214,6 +232,7 @@ static ssize_t aqm_write(struct file *file,
 	struct ieee80211_local *local = info->local;
 	char buf[100];
 	size_t len;
+	unsigned int ecn;
 
 	if (count > sizeof(buf))
 		return -EINVAL;
@@ -230,6 +249,16 @@ static ssize_t aqm_write(struct file *file,
 		return count;
 	else if (sscanf(buf, "fq_quantum %u", &local->fq.quantum) == 1)
 		return count;
+	else if (sscanf(buf, "codel_interval %u", &local->cparams.interval) == 1)
+		return count;
+	else if (sscanf(buf, "codel_target %u", &local->cparams.target) == 1)
+		return count;
+	else if (sscanf(buf, "codel_mtu %u", &local->cparams.mtu) == 1)
+		return count;
+	else if (sscanf(buf, "codel_ecn %u", &ecn) == 1) {
+		local->cparams.ecn = !!ecn;
+		return count;
+	}
 
 	return -EINVAL;
 }
-- 
2.1.4

