Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29987 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab1CKC4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:46 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 18/20] ath6kl: remove-typedef BUFFER_PROC_LIST
Date: Thu, 10 Mar 2011 18:55:45 -0800
Message-ID: <1299812147-12069-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s BUFFER_PROC_LIST \
	"struct buffer_proc_list" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index bdaffd7..2797b55 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -1017,10 +1017,10 @@ static u32 g_BlockSizes[AR6K_MAILBOXES];
 
 #define BUFFER_PROC_LIST_DEPTH 4
 
-typedef struct _BUFFER_PROC_LIST{
+struct buffer_proc_list {
     u8 *pBuffer;
     u32 length;
-}BUFFER_PROC_LIST;
+};
 
 
 #define PUSH_BUFF_PROC_ENTRY(pList,len,pCurrpos) \
@@ -1032,7 +1032,7 @@ typedef struct _BUFFER_PROC_LIST{
 }
 
 /* a simple and crude way to send different "message" sizes */
-static void AssembleBufferList(BUFFER_PROC_LIST *pList)
+static void AssembleBufferList(struct buffer_proc_list *pList)
 {
     u8 *pBuffer = g_Buffer;
 
@@ -1095,7 +1095,7 @@ static bool CheckBuffers(void)
 {
     int      i;
     bool   success = true;
-    BUFFER_PROC_LIST checkList[BUFFER_PROC_LIST_DEPTH];
+    struct buffer_proc_list checkList[BUFFER_PROC_LIST_DEPTH];
 
         /* assemble the list */
     AssembleBufferList(checkList);
@@ -1117,7 +1117,7 @@ static bool CheckBuffers(void)
 static u16 GetEndMarker(void)
 {
     u8 *pBuffer;
-    BUFFER_PROC_LIST checkList[BUFFER_PROC_LIST_DEPTH];
+    struct buffer_proc_list checkList[BUFFER_PROC_LIST_DEPTH];
 
         /* fill up buffers with the normal counting pattern */
     InitBuffers(FILL_COUNTING);
@@ -1138,7 +1138,7 @@ static int SendBuffers(struct ar6k_device *pDev, int mbox)
 {
     int         status = 0;
     u32 request = HIF_WR_SYNC_BLOCK_INC;
-    BUFFER_PROC_LIST sendList[BUFFER_PROC_LIST_DEPTH];
+    struct buffer_proc_list sendList[BUFFER_PROC_LIST_DEPTH];
     int              i;
     int              totalBytes = 0;
     int              paddedLength;
@@ -1229,7 +1229,7 @@ static int RecvBuffers(struct ar6k_device *pDev, int mbox)
 {
     int         status = 0;
     u32 request = HIF_RD_SYNC_BLOCK_INC;
-    BUFFER_PROC_LIST recvList[BUFFER_PROC_LIST_DEPTH];
+    struct buffer_proc_list recvList[BUFFER_PROC_LIST_DEPTH];
     int              curBuffer;
     int              credits;
     int              i;
-- 
1.7.4.15.g7811d

