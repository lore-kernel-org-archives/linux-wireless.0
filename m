Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24195 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab1CNSWe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:22:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:22:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 31/38] ath6kl: remove-typedef PSCmdPacket
Date: Mon, 14 Mar 2011 10:59:05 -0700
Message-ID: <1300125552-24422-32-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s PSCmdPacket \
	"struct ps_cmd_packet" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |    4 ++--
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   12 ++++++------
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
index 3436cbd..8393efe 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
@@ -41,7 +41,7 @@
  */
 typedef struct {
 
-    PSCmdPacket *HciCmdList;
+    struct ps_cmd_packet *HciCmdList;
     u32 num_packets;
     struct ar3k_config_info *dev;
 }HciCommandListParam;
@@ -133,7 +133,7 @@ int PSSendOps(void *arg)
 {
     int i;
     int status = 0;
-    PSCmdPacket *HciCmdList; /* List storing the commands */
+    struct ps_cmd_packet *HciCmdList; /* List storing the commands */
     const struct firmware* firmware;
     u32 numCmds;
     u8 *event;
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
index 300c501..b334a3d 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
@@ -130,7 +130,7 @@ tRamPatch   RamPatch[MAX_NUM_PATCH_ENTRY];
 int AthParseFilesUnified(u8 *srcbuffer,u32 srclen, int FileFormat);
 char AthReadChar(u8 *buffer, u32 len,u32 *pos);
 char *AthGetLine(char *buffer, int maxlen, u8 *srcbuffer,u32 len,u32 *pos);
-static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,PSCmdPacket *PSPatchPacket,u32 *index);
+static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,struct ps_cmd_packet *PSPatchPacket,u32 *index);
 
 /* Function to reads the next character from the input buffer */
 char AthReadChar(u8 *buffer, u32 len,u32 *pos)
@@ -764,7 +764,7 @@ static void LoadHeader(u8 *HCI_PS_Command,u8 opcode,int length,int index){
 
 /////////////////////////
 //
-int AthCreateCommandList(PSCmdPacket **HciPacketList, u32 *numPackets)
+int AthCreateCommandList(struct ps_cmd_packet **HciPacketList, u32 *numPackets)
 {
 
     u8 count;
@@ -785,8 +785,8 @@ int AthCreateCommandList(PSCmdPacket **HciPacketList, u32 *numPackets)
         if(Patch_Count > 0) {
             NumcmdEntry++; /* Patch Enable Command */
         }
-           AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Num Cmd Entries %d Size  %d  \r\n",NumcmdEntry,(u32)sizeof(PSCmdPacket) * NumcmdEntry));
-        (*HciPacketList) = A_MALLOC(sizeof(PSCmdPacket) * NumcmdEntry);
+           AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Num Cmd Entries %d Size  %d  \r\n",NumcmdEntry,(u32)sizeof(struct ps_cmd_packet) * NumcmdEntry));
+        (*HciPacketList) = A_MALLOC(sizeof(struct ps_cmd_packet) * NumcmdEntry);
     if(NULL == *HciPacketList) {
                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("memory allocation failed  \r\n"));
         }
@@ -833,7 +833,7 @@ int AthCreateCommandList(PSCmdPacket **HciPacketList, u32 *numPackets)
 ////////////////////////
 
 /////////////
-static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,PSCmdPacket *PSPatchPacket,u32 *index)
+static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,struct ps_cmd_packet *PSPatchPacket,u32 *index)
 {
     u8 *HCI_PS_Command;
     u32 Length;
@@ -955,7 +955,7 @@ static int AthPSCreateHCICommand(u8 Opcode, u32 Param1,PSCmdPacket *PSPatchPacke
     }
     return 0;
 }
-int AthFreeCommandList(PSCmdPacket **HciPacketList, u32 numPackets)
+int AthFreeCommandList(struct ps_cmd_packet **HciPacketList, u32 numPackets)
 {
     int i;
     if(*HciPacketList == NULL) {
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
index 62e298d..9378efc 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
@@ -89,11 +89,11 @@
 
 
 
-typedef struct PSCmdPacket
+struct ps_cmd_packet
 {
     u8 *Hcipacket;
     int packetLen;
-} PSCmdPacket;
+};
 
 /* Parses a Patch information buffer and store it in global structure */
 int AthDoParsePatch(u8 *, u32 );
@@ -112,8 +112,8 @@ int AthDoParsePS(u8 *, u32 );
  *  PS Tag Command(s)
  *
  */  
-int AthCreateCommandList(PSCmdPacket **, u32 *);
+int AthCreateCommandList(struct ps_cmd_packet **, u32 *);
 
 /* Cleanup the dynamically allicated HCI command list */
-int AthFreeCommandList(PSCmdPacket **HciPacketList, u32 numPackets);
+int AthFreeCommandList(struct ps_cmd_packet **HciPacketList, u32 numPackets);
 #endif /* __AR3KPSPARSER_H */
-- 
1.7.4.15.g7811d

