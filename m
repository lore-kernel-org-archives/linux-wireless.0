Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21583 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1CNSIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:08:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:07:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 32/38] ath6kl: remove-typedef RXTID
Date: Mon, 14 Mar 2011 10:59:06 -0700
Message-ID: <1300125552-24422-33-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s RXTID \
	"struct rxtid" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h |    6 ++--
 drivers/staging/ath6kl/reorder/rcv_aggr.c         |   22 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ath6kl/reorder/aggr_rx_internal.h b/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
index 082a8da..8b091df 100644
--- a/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
+++ b/drivers/staging/ath6kl/reorder/aggr_rx_internal.h
@@ -73,7 +73,7 @@ typedef struct {
 }WINDOW_SNAPSHOT;
 #endif
 
-typedef struct {
+struct rxtid {
     bool              aggr;       /* is it ON or OFF */
     bool              progress;   /* true when frames have arrived after a timer start */
     bool              timerMon;   /* true if the timer started for the sake of this TID */
@@ -86,7 +86,7 @@ typedef struct {
 #endif    
     A_NETBUF_QUEUE_T    q;          /* q head for enqueuing frames for dispatch */
     A_MUTEX_T           lock;
-}RXTID;
+};
 
 typedef struct {
     u32 num_into_aggr;      /* hitting at the input of this module */
@@ -106,7 +106,7 @@ struct aggr_info {
     A_TIMER             timer;              /* timer for returning held up pkts in re-order que */    
     void                *dev;               /* dev handle */
     RX_CALLBACK         rx_fn;              /* callback function to return frames; to upper layer */
-    RXTID               RxTid[NUM_OF_TIDS]; /* Per tid window */
+    struct rxtid               RxTid[NUM_OF_TIDS]; /* Per tid window */
     ALLOC_NETBUFS       netbuf_allocator;   /* OS netbuf alloc fn */
     A_NETBUF_QUEUE_T    freeQ;              /* pre-allocated buffers - for A_MSDU slicing */
     RXTID_STATS         stat[NUM_OF_TIDS];  /* Tid based statistics */
diff --git a/drivers/staging/ath6kl/reorder/rcv_aggr.c b/drivers/staging/ath6kl/reorder/rcv_aggr.c
index c54d492..8d13489 100644
--- a/drivers/staging/ath6kl/reorder/rcv_aggr.c
+++ b/drivers/staging/ath6kl/reorder/rcv_aggr.c
@@ -37,7 +37,7 @@ extern int
 wmi_dot3_2_dix(void *osbuf);
 
 static void
-aggr_slice_amsdu(struct aggr_info *p_aggr, RXTID *rxtid, void **osbuf);
+aggr_slice_amsdu(struct aggr_info *p_aggr, struct rxtid *rxtid, void **osbuf);
 
 static void
 aggr_timeout(A_ATH_TIMER arg);
@@ -55,7 +55,7 @@ void *
 aggr_init(ALLOC_NETBUFS netbuf_allocator)
 {
     struct aggr_info   *p_aggr = NULL;
-    RXTID *rxtid;
+    struct rxtid *rxtid;
     u8 i;
     int status = 0;
 
@@ -103,7 +103,7 @@ aggr_init(ALLOC_NETBUFS netbuf_allocator)
 static void
 aggr_delete_tid_state(struct aggr_info *p_aggr, u8 tid)
 {
-    RXTID *rxtid;
+    struct rxtid *rxtid;
     RXTID_STATS *stats;
 
     A_ASSERT(tid < NUM_OF_TIDS && p_aggr);
@@ -134,7 +134,7 @@ void
 aggr_module_destroy(void *cntxt)
 {
     struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
-    RXTID *rxtid;
+    struct rxtid *rxtid;
     u8 i, k;
     A_PRINTF("%s(): aggr = %p\n",_A_FUNCNAME_, p_aggr);
     A_ASSERT(p_aggr);
@@ -204,7 +204,7 @@ void
 aggr_recv_addba_req_evt(void *cntxt, u8 tid, u16 seq_no, u8 win_sz)
 {
     struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
-    RXTID *rxtid;
+    struct rxtid *rxtid;
     RXTID_STATS *stats;
 
     A_ASSERT(p_aggr);
@@ -256,7 +256,7 @@ void
 aggr_recv_delba_req_evt(void *cntxt, u8 tid)
 {
     struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
-    RXTID *rxtid;
+    struct rxtid *rxtid;
 
     A_ASSERT(p_aggr);
     A_PRINTF("%s(): tid %d\n", _A_FUNCNAME_, tid);
@@ -271,7 +271,7 @@ aggr_recv_delba_req_evt(void *cntxt, u8 tid)
 static void
 aggr_deque_frms(struct aggr_info *p_aggr, u8 tid, u16 seq_no, u8 order)
 {
-    RXTID *rxtid;
+    struct rxtid *rxtid;
     struct osbuf_hold_q *node;
     u16 idx, idx_end, seq_end;
     RXTID_STATS *stats;
@@ -356,7 +356,7 @@ aggr_get_osbuf(struct aggr_info *p_aggr)
 
 
 static void
-aggr_slice_amsdu(struct aggr_info *p_aggr, RXTID *rxtid, void **osbuf)
+aggr_slice_amsdu(struct aggr_info *p_aggr, struct rxtid *rxtid, void **osbuf)
 {
     void *new_buf;
     u16 frame_8023_len, payload_8023_len, mac_hdr_len, amsdu_len;
@@ -429,7 +429,7 @@ void
 aggr_process_recv_frm(void *cntxt, u8 tid, u16 seq_no, bool is_amsdu, void **osbuf)
 {
     struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
-    RXTID *rxtid;
+    struct rxtid *rxtid;
     RXTID_STATS *stats;
     u16 idx, st, cur, end;
     u16 *log_idx;
@@ -577,7 +577,7 @@ aggr_timeout(A_ATH_TIMER arg)
 {
     u8 i,j;
     struct aggr_info *p_aggr = (struct aggr_info *)arg;
-    RXTID   *rxtid;
+    struct rxtid   *rxtid;
     RXTID_STATS *stats;
     /*
      * If the q for which the timer was originally started has
@@ -643,7 +643,7 @@ void
 aggr_dump_stats(void *cntxt, PACKET_LOG **log_buf)
 {
     struct aggr_info *p_aggr = (struct aggr_info *)cntxt;
-    RXTID   *rxtid;
+    struct rxtid   *rxtid;
     RXTID_STATS *stats;
     u8 i;
 
-- 
1.7.4.15.g7811d

