Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22116 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1CNSLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:11:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:10:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 36/38] ath6kl: remove-typedef WINDOW_SNAPSHOT
Date: Mon, 14 Mar 2011 10:59:10 -0700
Message-ID: <1300125552-24422-37-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s WINDOW_SNAPSHOT \
	"struct window_snapshot" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/reorder/aggr_rx_internal.h b/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
index becbab9..1112596 100644
--- a/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
+++ b/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
@@ -67,10 +67,11 @@ struct osbuf_hold_q {
 
 
 #if 0
-typedef struct {
+/* XXX: unused ? */
+struct window_snapshot {
     u16 seqno_st;
     u16 seqno_end;
-}WINDOW_SNAPSHOT;
+};
 #endif
 
 struct rxtid {
@@ -82,7 +83,7 @@ struct rxtid {
     u32 hold_q_sz;  /* Num of frames that can be held in hold q */
     struct osbuf_hold_q        *hold_q;    /* Hold q for re-order */
 #if 0    
-    WINDOW_SNAPSHOT     old_win;    /* Sliding window snapshot - for timeout */
+    struct window_snapshot     old_win;    /* Sliding window snapshot - for timeout */
 #endif    
     A_NETBUF_QUEUE_T    q;          /* q head for enqueuing frames for dispatch */
     A_MUTEX_T           lock;
-- 
1.7.4.15.g7811d

