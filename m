Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29945 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1CKC4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:09 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:47 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/20] ath6kl: remove-typedef AGGR_INFO
Date: Thu, 10 Mar 2011 18:55:32 -0800
Message-ID: <1299812147-12069-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AGGR_INFO \
	"struct aggr_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h |    4 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c         |   42 ++++++++++----------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ath6kl/reorder/aggr_rx_internal.h b/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
index 523a239..20c894d 100644
--- a/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
+++ b/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
@@ -100,7 +100,7 @@ typedef struct {
     u32 num_bar;            /* num of resets of seq_num, via BAR */
 }RXTID_STATS;
 
-typedef struct {
+struct aggr_info {
     u8 aggr_sz;            /* config value of aggregation size */
     u8 timerScheduled;
     A_TIMER             timer;              /* timer for returning held up pkts in re-order que */    
@@ -111,6 +111,6 @@ typedef struct {
     A_NETBUF_QUEUE_T    freeQ;              /* pre-allocated buffers - for A_MSDU slicing */
     RXTID_STATS         stat[NUM_OF_TIDS];  /* Tid based statistics */
     PACKET_LOG          pkt_log;            /* Log info of the packets */
-}AGGR_INFO;
+};
 
 #endif /* __AGGR_RX_INTERNAL_H__ */
diff --git a/drivers/staging/ath6kl/reorder/rcv_aggr.c b/drivers/staging/ath6kl/reorder/rcv_aggr.c
index adb85eb..8beb00d 100644
--- a/drivers/staging/ath6kl/reorder/rcv_aggr.c
+++ b/drivers/staging/ath6kl/reorder/rcv_aggr.c
@@ -37,24 +37,24 @@ extern int
 wmi_dot3_2_dix(void *osbuf);
 
 static void
-aggr_slice_amsdu(AGGR_INFO *p_aggr, RXTID *rxtid, void **osbuf);
+aggr_slice_amsdu(struct aggr_info *p_aggr, RXTID *rxtid, void **osbuf);
 
 static void
 aggr_timeout(A_ATH_TIMER arg);
 
 static void
-aggr_deque_frms(AGGR_INFO *p_aggr, u8 tid, u16 seq_no, u8 order);
+aggr_deque_frms(struct aggr_info *p_aggr, u8 tid, u16 seq_no, u8 order);
 
 static void
-aggr_dispatch_frames(AGGR_INFO *p_aggr, A_NETBUF_QUEUE_T *q);
+aggr_dispatch_frames(struct aggr_info *p_aggr, A_NETBUF_QUEUE_T *q);
 
 static void *
-aggr_get_osbuf(AGGR_INFO *p_aggr);
+aggr_get_osbuf(struct aggr_info *p_aggr);
 
 void *
 aggr_init(ALLOC_NETBUFS netbuf_allocator)
 {
-    AGGR_INFO   *p_aggr = NULL;
+    struct aggr_info   *p_aggr = NULL;
     RXTID *rxtid;
     u8 i;
     int status = 0;
@@ -62,7 +62,7 @@ aggr_init(ALLOC_NETBUFS netbuf_allocator)
     A_PRINTF("In aggr_init..\n");
 
     do {
-        p_aggr = A_MALLOC(sizeof(AGGR_INFO));
+        p_aggr = A_MALLOC(sizeof(struct aggr_info));
         if(!p_aggr) {
             A_PRINTF("Failed to allocate memory for aggr_node\n");
             status = A_ERROR;
@@ -70,7 +70,7 @@ aggr_init(ALLOC_NETBUFS netbuf_allocator)
         }
 
         /* Init timer and data structures */
-        A_MEMZERO(p_aggr, sizeof(AGGR_INFO));
+        A_MEMZERO(p_aggr, sizeof(struct aggr_info));
         p_aggr->aggr_sz = AGGR_SZ_DEFAULT;
         A_INIT_TIMER(&p_aggr->timer, aggr_timeout, p_aggr);
         p_aggr->timerScheduled = false;
@@ -101,7 +101,7 @@ aggr_init(ALLOC_NETBUFS netbuf_allocator)
 
 /* utility function to clear rx hold_q for a tid */
 static void
-aggr_delete_tid_state(AGGR_INFO *p_aggr, u8 tid)
+aggr_delete_tid_state(struct aggr_info *p_aggr, u8 tid)
 {
     RXTID *rxtid;
     RXTID_STATS *stats;
@@ -133,7 +133,7 @@ aggr_delete_tid_state(AGGR_INFO *p_aggr, u8 tid)
 void
 aggr_module_destroy(void *cntxt)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
     RXTID *rxtid;
     u8 i, k;
     A_PRINTF("%s(): aggr = %p\n",_A_FUNCNAME_, p_aggr);
@@ -177,7 +177,7 @@ aggr_module_destroy(void *cntxt)
 void
 aggr_register_rx_dispatcher(void *cntxt, void * dev, RX_CALLBACK fn)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
 
     A_ASSERT(p_aggr && fn && dev);
 
@@ -189,7 +189,7 @@ aggr_register_rx_dispatcher(void *cntxt, void * dev, RX_CALLBACK fn)
 void
 aggr_process_bar(void *cntxt, u8 tid, u16 seq_no)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
     RXTID_STATS *stats;
 
     A_ASSERT(p_aggr);
@@ -203,7 +203,7 @@ aggr_process_bar(void *cntxt, u8 tid, u16 seq_no)
 void
 aggr_recv_addba_req_evt(void *cntxt, u8 tid, u16 seq_no, u8 win_sz)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
     RXTID *rxtid;
     RXTID_STATS *stats;
 
@@ -255,7 +255,7 @@ aggr_recv_addba_req_evt(void *cntxt, u8 tid, u16 seq_no, u8 win_sz)
 void
 aggr_recv_delba_req_evt(void *cntxt, u8 tid)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
     RXTID *rxtid;
 
     A_ASSERT(p_aggr);
@@ -269,7 +269,7 @@ aggr_recv_delba_req_evt(void *cntxt, u8 tid)
 }
 
 static void
-aggr_deque_frms(AGGR_INFO *p_aggr, u8 tid, u16 seq_no, u8 order)
+aggr_deque_frms(struct aggr_info *p_aggr, u8 tid, u16 seq_no, u8 order)
 {
     RXTID *rxtid;
     OSBUF_HOLD_Q *node;
@@ -334,7 +334,7 @@ aggr_deque_frms(AGGR_INFO *p_aggr, u8 tid, u16 seq_no, u8 order)
 }
 
 static void *
-aggr_get_osbuf(AGGR_INFO *p_aggr)
+aggr_get_osbuf(struct aggr_info *p_aggr)
 {
     void *buf = NULL;
 
@@ -356,7 +356,7 @@ aggr_get_osbuf(AGGR_INFO *p_aggr)
 
 
 static void
-aggr_slice_amsdu(AGGR_INFO *p_aggr, RXTID *rxtid, void **osbuf)
+aggr_slice_amsdu(struct aggr_info *p_aggr, RXTID *rxtid, void **osbuf)
 {
     void *new_buf;
     u16 frame_8023_len, payload_8023_len, mac_hdr_len, amsdu_len;
@@ -428,7 +428,7 @@ aggr_slice_amsdu(AGGR_INFO *p_aggr, RXTID *rxtid, void **osbuf)
 void
 aggr_process_recv_frm(void *cntxt, u8 tid, u16 seq_no, bool is_amsdu, void **osbuf)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
     RXTID *rxtid;
     RXTID_STATS *stats;
     u16 idx, st, cur, end;
@@ -562,7 +562,7 @@ void
 aggr_reset_state(void *cntxt)
 {
     u8 tid;
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
 
     A_ASSERT(p_aggr);
 
@@ -576,7 +576,7 @@ static void
 aggr_timeout(A_ATH_TIMER arg)
 {
     u8 i,j;
-    AGGR_INFO *p_aggr = (AGGR_INFO *)arg;
+    struct aggr_info *p_aggr = (struct aggr_info *)arg;
     RXTID   *rxtid;
     RXTID_STATS *stats;
     /*
@@ -630,7 +630,7 @@ aggr_timeout(A_ATH_TIMER arg)
 }
 
 static void
-aggr_dispatch_frames(AGGR_INFO *p_aggr, A_NETBUF_QUEUE_T *q)
+aggr_dispatch_frames(struct aggr_info *p_aggr, A_NETBUF_QUEUE_T *q)
 {
     void *osbuf;
 
@@ -642,7 +642,7 @@ aggr_dispatch_frames(AGGR_INFO *p_aggr, A_NETBUF_QUEUE_T *q)
 void
 aggr_dump_stats(void *cntxt, PACKET_LOG **log_buf)
 {
-    AGGR_INFO *p_aggr = (AGGR_INFO *)cntxt;
+    struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
     RXTID   *rxtid;
     RXTID_STATS *stats;
     u8 i;
-- 
1.7.4.15.g7811d

