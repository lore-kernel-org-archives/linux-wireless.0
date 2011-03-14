Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20507 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1CNR7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 21/38] ath6kl: remove-typedef HTC_FRAME_HDR
Date: Mon, 14 Mar 2011 10:58:55 -0700
Message-ID: <1300125552-24422-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HTC_FRAME_HDR \
	"struct htc_frame_hdr" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/htc_internal.h         |   12 ++++----
 drivers/staging/ath6kl/htc2/htc_recv.c             |   30 ++++++++++----------
 .../staging/ath6kl/include/common/epping_test.h    |    2 +-
 drivers/staging/ath6kl/include/common/htc.h        |    8 ++--
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/htc_internal.h b/drivers/staging/ath6kl/htc2/htc_internal.h
index d574015..deff62a 100644
--- a/drivers/staging/ath6kl/htc2/htc_internal.h
+++ b/drivers/staging/ath6kl/htc2/htc_internal.h
@@ -128,7 +128,7 @@ typedef struct _HTC_TARGET {
     HTC_ENDPOINT_ID             EpWaitingForBuffers;
     bool                      TargetFailure;
 #ifdef HTC_CAPTURE_LAST_FRAME
-    HTC_FRAME_HDR               LastFrameHdr;  /* useful for debugging */
+    struct htc_frame_hdr               LastFrameHdr;  /* useful for debugging */
     u8 LastTrailer[256];
     u8 LastTrailerLength;
 #endif
@@ -203,11 +203,11 @@ static INLINE HTC_PACKET *HTC_ALLOC_CONTROL_TX(HTC_TARGET *target) {
     u8 *pHdrBuf;                               \
     (pP)->pBuffer -= HTC_HDR_LENGTH;                \
     pHdrBuf = (pP)->pBuffer;                        \
-    A_SET_UINT16_FIELD(pHdrBuf,HTC_FRAME_HDR,PayloadLen,(u16)(pP)->ActualLength);  \
-    A_SET_UINT8_FIELD(pHdrBuf,HTC_FRAME_HDR,Flags,(sendflags));                         \
-    A_SET_UINT8_FIELD(pHdrBuf,HTC_FRAME_HDR,EndpointID, (u8)(pP)->Endpoint); \
-    A_SET_UINT8_FIELD(pHdrBuf,HTC_FRAME_HDR,ControlBytes[0], (u8)(ctrl0));   \
-    A_SET_UINT8_FIELD(pHdrBuf,HTC_FRAME_HDR,ControlBytes[1], (u8)(ctrl1));   \
+    A_SET_UINT16_FIELD(pHdrBuf,struct htc_frame_hdr,PayloadLen,(u16)(pP)->ActualLength);  \
+    A_SET_UINT8_FIELD(pHdrBuf,struct htc_frame_hdr,Flags,(sendflags));                         \
+    A_SET_UINT8_FIELD(pHdrBuf,struct htc_frame_hdr,EndpointID, (u8)(pP)->Endpoint); \
+    A_SET_UINT8_FIELD(pHdrBuf,struct htc_frame_hdr,ControlBytes[0], (u8)(ctrl0));   \
+    A_SET_UINT8_FIELD(pHdrBuf,struct htc_frame_hdr,ControlBytes[1], (u8)(ctrl1));   \
 }
 
 #define HTC_UNPREPARE_SEND_PKT(pP)     \
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index 4095f8e..771dc5e 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -252,7 +252,7 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
     do {
         /* note, we cannot assume the alignment of pBuffer, so we use the safe macros to
          * retrieve 16 bit fields */
-        payloadLen = A_GET_UINT16_FIELD(pBuf, HTC_FRAME_HDR, PayloadLen);
+        payloadLen = A_GET_UINT16_FIELD(pBuf, struct htc_frame_hdr, PayloadLen);
         
         ((u8 *)&lookAhead)[0] = pBuf[0];
         ((u8 *)&lookAhead)[1] = pBuf[1];
@@ -277,10 +277,10 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
                 break;    
             }
             
-            if (pPacket->Endpoint != A_GET_UINT8_FIELD(pBuf, HTC_FRAME_HDR, EndpointID)) {
+            if (pPacket->Endpoint != A_GET_UINT8_FIELD(pBuf, struct htc_frame_hdr, EndpointID)) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                     ("Refreshed HDR endpoint (%d) does not match expected endpoint (%d) \n", 
-                    A_GET_UINT8_FIELD(pBuf, HTC_FRAME_HDR, EndpointID), pPacket->Endpoint));
+                    A_GET_UINT8_FIELD(pBuf, struct htc_frame_hdr, EndpointID), pPacket->Endpoint));
                 status = A_EPROTO;
                 break;      
             }   
@@ -294,9 +294,9 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
                         (unsigned long)pPacket, pPacket->PktInfo.AsRx.HTCRxFlags));
 #ifdef ATH_DEBUG_MODULE
              DebugDumpBytes((u8 *)&pPacket->PktInfo.AsRx.ExpectedHdr,4,"Expected Message LookAhead");
-             DebugDumpBytes(pBuf,sizeof(HTC_FRAME_HDR),"Current Frame Header");
+             DebugDumpBytes(pBuf,sizeof(struct htc_frame_hdr),"Current Frame Header");
 #ifdef HTC_CAPTURE_LAST_FRAME
-            DebugDumpBytes((u8 *)&target->LastFrameHdr,sizeof(HTC_FRAME_HDR),"Last Frame Header");
+            DebugDumpBytes((u8 *)&target->LastFrameHdr,sizeof(struct htc_frame_hdr),"Last Frame Header");
             if (target->LastTrailerLength != 0) {
                 DebugDumpBytes(target->LastTrailer,
                                target->LastTrailerLength,
@@ -309,13 +309,13 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
         }
 
             /* get flags */
-        temp = A_GET_UINT8_FIELD(pBuf, HTC_FRAME_HDR, Flags);
+        temp = A_GET_UINT8_FIELD(pBuf, struct htc_frame_hdr, Flags);
 
         if (temp & HTC_FLAGS_RECV_TRAILER) {
             /* this packet has a trailer */
 
                 /* extract the trailer length in control byte 0 */
-            temp = A_GET_UINT8_FIELD(pBuf, HTC_FRAME_HDR, ControlBytes[0]);
+            temp = A_GET_UINT8_FIELD(pBuf, struct htc_frame_hdr, ControlBytes[0]);
 
             if ((temp < sizeof(HTC_RECORD_HDR)) || (temp > payloadLen)) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
@@ -372,7 +372,7 @@ static int HTCProcessRecvHeader(HTC_TARGET *target,
 #endif
     } else {
 #ifdef HTC_CAPTURE_LAST_FRAME
-        memcpy(&target->LastFrameHdr,pBuf,sizeof(HTC_FRAME_HDR));
+        memcpy(&target->LastFrameHdr,pBuf,sizeof(struct htc_frame_hdr));
 #endif
         if (AR_DEBUG_LVL_CHECK(ATH_DEBUG_RECV)) {
             if (pPacket->ActualLength > 0) {
@@ -500,7 +500,7 @@ static INLINE void SetRxPacketIndicationFlags(u32 LookAhead,
                                               struct htc_endpoint  *pEndpoint, 
                                               HTC_PACKET    *pPacket)
 {
-    HTC_FRAME_HDR *pHdr = (HTC_FRAME_HDR *)&LookAhead;
+    struct htc_frame_hdr *pHdr = (struct htc_frame_hdr *)&LookAhead;
         /* check to see if the "next" packet is from the same endpoint of the
            completing packet */
     if (pHdr->EndpointID == pPacket->Endpoint) {
@@ -592,7 +592,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
     int        status;
     u32 lookAhead;
     HTC_PACKET      *pPacket = NULL;
-    HTC_FRAME_HDR   *pHdr;
+    struct htc_frame_hdr   *pHdr;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("+HTCWaitforControlMessage \n"));
 
@@ -613,7 +613,7 @@ int HTCWaitforControlMessage(HTC_TARGET *target, HTC_PACKET **ppControlPacket)
                 ("HTCWaitforControlMessage : lookAhead : 0x%X \n", lookAhead));
 
             /* check the lookahead */
-        pHdr = (HTC_FRAME_HDR *)&lookAhead;
+        pHdr = (struct htc_frame_hdr *)&lookAhead;
 
         if (pHdr->EndpointID != ENDPOINT_0) {
                 /* unexpected endpoint number, should be zero */
@@ -694,7 +694,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
 {
     int         status = 0;
     HTC_PACKET      *pPacket;
-    HTC_FRAME_HDR   *pHdr;
+    struct htc_frame_hdr   *pHdr;
     int              i,j;
     int              numMessages;
     int              fullLength;
@@ -705,7 +705,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
                         
     for (i = 0; i < Messages; i++) {   
          
-        pHdr = (HTC_FRAME_HDR *)&LookAheads[i];
+        pHdr = (struct htc_frame_hdr *)&LookAheads[i];
 
         if (pHdr->EndpointID >= ENDPOINT_MAX) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Invalid Endpoint in look-ahead: %d \n",pHdr->EndpointID));
@@ -751,7 +751,7 @@ static int AllocAndPrepareRxPackets(HTC_TARGET       *target,
                 ("HTC header indicates :%d messages can be fetched as a bundle \n",numMessages));           
         }
      
-        fullLength = DEV_CALC_RECV_PADDED_LEN(&target->Device,pHdr->PayloadLen + sizeof(HTC_FRAME_HDR));
+        fullLength = DEV_CALC_RECV_PADDED_LEN(&target->Device,pHdr->PayloadLen + sizeof(struct htc_frame_hdr));
             
             /* get packet buffers for each message, if there was a bundle detected in the header,
              * use pHdr as a template to fetch all packets in the bundle */        
@@ -1170,7 +1170,7 @@ int HTCRecvMessagePendingHandler(void *Context, u32 MsgLookAheads[], int NumLook
         }
    
             /* first lookahead sets the expected endpoint IDs for all packets in a bundle */
-        id = ((HTC_FRAME_HDR *)&lookAheads[0])->EndpointID;
+        id = ((struct htc_frame_hdr *)&lookAheads[0])->EndpointID;
         pEndpoint = &target->EndPoint[id];
         
         if (id >= ENDPOINT_MAX) {
diff --git a/drivers/staging/ath6kl/include/common/epping_test.h b/drivers/staging/ath6kl/include/common/epping_test.h
index 2cd43c4..5c40d8a 100644
--- a/drivers/staging/ath6kl/include/common/epping_test.h
+++ b/drivers/staging/ath6kl/include/common/epping_test.h
@@ -30,7 +30,7 @@
 #endif
 
     /* alignment to 4-bytes */
-#define EPPING_ALIGNMENT_PAD  (((sizeof(HTC_FRAME_HDR) + 3) & (~0x3)) - sizeof(HTC_FRAME_HDR))
+#define EPPING_ALIGNMENT_PAD  (((sizeof(struct htc_frame_hdr) + 3) & (~0x3)) - sizeof(struct htc_frame_hdr))
 
 #ifndef A_OFFSETOF
 #define A_OFFSETOF(type,field) (int)(&(((type *)NULL)->field))
diff --git a/drivers/staging/ath6kl/include/common/htc.h b/drivers/staging/ath6kl/include/common/htc.h
index bed8e26..b9d4495 100644
--- a/drivers/staging/ath6kl/include/common/htc.h
+++ b/drivers/staging/ath6kl/include/common/htc.h
@@ -66,7 +66,7 @@
  */
 
 /* HTC frame header */
-typedef PREPACK struct _HTC_FRAME_HDR{
+PREPACK struct htc_frame_hdr {
         /* do not remove or re-arrange these fields, these are minimally required
          * to take advantage of 4-byte lookaheads in some hardware implementations */
     u8 EndpointID;
@@ -79,7 +79,7 @@ typedef PREPACK struct _HTC_FRAME_HDR{
     
     /* message payload starts after the header */
     
-} POSTPACK HTC_FRAME_HDR;
+} POSTPACK;
 
 /* frame header flags */
 
@@ -94,9 +94,9 @@ typedef PREPACK struct _HTC_FRAME_HDR{
 #define HTC_FLAGS_RECV_BUNDLE_CNT_MASK (0xF0)  /* bits 7..4  */
 #define HTC_FLAGS_RECV_BUNDLE_CNT_SHIFT 4
 
-#define HTC_HDR_LENGTH  (sizeof(HTC_FRAME_HDR))
+#define HTC_HDR_LENGTH  (sizeof(struct htc_frame_hdr))
 #define HTC_MAX_TRAILER_LENGTH   255
-#define HTC_MAX_PAYLOAD_LENGTH   (4096 - sizeof(HTC_FRAME_HDR))
+#define HTC_MAX_PAYLOAD_LENGTH   (4096 - sizeof(struct htc_frame_hdr))
 
 /* HTC control message IDs */
 
-- 
1.7.4.15.g7811d

