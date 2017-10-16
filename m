Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:54771 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752381AbdJPPGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 11:06:09 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH] fq_impl: Properly enforce memory limit
Date: Mon, 16 Oct 2017 17:05:57 +0200
Message-Id: <20171016150557.19368-1-toke@toke.dk> (sfid-20171016_170633_624958_1B076FBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fq structure would fail to properly enforce the memory limit in the case
where the packet being enqueued was bigger than the packet being removed to
bring the memory usage down. So keep dropping packets until the memory usage is
back below the limit. Also, fix the statistics for memory limit violations.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/fq_impl.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
index 4e6131cd3f43..ac1a2317941e 100644
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -146,6 +146,7 @@ static void fq_tin_enqueue(struct fq *fq,
 			   fq_flow_get_default_t get_default_func)
 {
 	struct fq_flow *flow;
+	bool oom;
 
 	lockdep_assert_held(&fq->lock);
 
@@ -167,8 +168,8 @@ static void fq_tin_enqueue(struct fq *fq,
 	}
 
 	__skb_queue_tail(&flow->queue, skb);
-
-	if (fq->backlog > fq->limit || fq->memory_usage > fq->memory_limit) {
+	oom = (fq->memory_usage > fq->memory_limit);
+	while (fq->backlog > fq->limit || oom) {
 		flow = list_first_entry_or_null(&fq->backlogs,
 						struct fq_flow,
 						backlogchain);
@@ -183,8 +184,10 @@ static void fq_tin_enqueue(struct fq *fq,
 
 		flow->tin->overlimit++;
 		fq->overlimit++;
-		if (fq->memory_usage > fq->memory_limit)
+		if (oom) {
 			fq->overmemory++;
+			oom = (fq->memory_usage > fq->memory_limit);
+		}
 	}
 }
 
-- 
2.14.2
