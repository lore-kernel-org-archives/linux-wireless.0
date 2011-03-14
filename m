Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24749 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1CNS0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:26:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:25:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/38] ath6kl: remove-typedef HCI_TRANSPORT_PROPERTIES
Date: Mon, 14 Mar 2011 11:04:11 -0700
Message-ID: <1300125851-24614-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HCI_TRANSPORT_PROPERTIES \
	"struct hci_transport_properties" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    2 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |    2 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |    6 +++---
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index c7e8f71..8e5abe8 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -910,7 +910,7 @@ void GMboxProtocolUninstall(struct ar6k_device *pDev)
 
 static int NotifyTransportReady(struct gmbox_proto_hci_uart  *pProt)
 {
-    HCI_TRANSPORT_PROPERTIES props;
+    struct hci_transport_properties props;
     int                 status = 0;
     
     do {
diff --git a/drivers/staging/ath6kl/include/ar3kconfig.h b/drivers/staging/ath6kl/include/ar3kconfig.h
index 20d295b..80f948e 100644
--- a/drivers/staging/ath6kl/include/ar3kconfig.h
+++ b/drivers/staging/ath6kl/include/ar3kconfig.h
@@ -41,7 +41,7 @@ extern "C" {
 struct ar3k_config_info {
     u32 Flags;           /* config flags */
     void                     *pHCIDev;        /* HCI bridge device     */
-    HCI_TRANSPORT_PROPERTIES *pHCIProps;      /* HCI bridge props      */
+    struct hci_transport_properties *pHCIProps;      /* HCI bridge props      */
     HIF_DEVICE               *pHIFDevice;     /* HIF layer device      */
     
     u32 AR3KBaudRate;    /* AR3K operational baud rate */
diff --git a/drivers/staging/ath6kl/include/hci_transport_api.h b/drivers/staging/ath6kl/include/hci_transport_api.h
index 7fa44f0..ee25c6b 100644
--- a/drivers/staging/ath6kl/include/hci_transport_api.h
+++ b/drivers/staging/ath6kl/include/hci_transport_api.h
@@ -79,11 +79,11 @@ typedef enum _HCI_SEND_FULL_ACTION {
  * the callback must return the send full action to take (either DROP or KEEP) */
 typedef HCI_SEND_FULL_ACTION  (*HCI_TRANSPORT_SEND_FULL)(void *, HTC_PACKET *);
 
-typedef struct {
+struct hci_transport_properties {
     int    HeadRoom;      /* number of bytes in front of HCI packet for header space */
     int    TailRoom;      /* number of bytes at the end of the HCI packet for tail space */
     int    IOBlockPad;    /* I/O block padding required (always a power of 2) */
-} HCI_TRANSPORT_PROPERTIES;
+};
 
 struct hci_transport_config_info {
     int      ACLRecvBufferWaterMark;     /* low watermark to trigger recv refill */
@@ -91,7 +91,7 @@ struct hci_transport_config_info {
     int      MaxSendQueueDepth;          /* max number of packets in the single send queue */
     void     *pContext;                  /* context for all callbacks */
     void     (*TransportFailure)(void *pContext, int Status); /* transport failure callback */
-    int (*TransportReady)(HCI_TRANSPORT_HANDLE, HCI_TRANSPORT_PROPERTIES *,void *pContext); /* transport is ready */
+    int (*TransportReady)(HCI_TRANSPORT_HANDLE, struct hci_transport_properties *,void *pContext); /* transport is ready */
     void     (*TransportRemoved)(void *pContext);                  /* transport was removed */
         /* packet processing callbacks */
     HCI_TRANSPORT_SEND_PKT_COMPLETE    pHCISendComplete;
diff --git a/drivers/staging/ath6kl/os/linux/hci_bridge.c b/drivers/staging/ath6kl/os/linux/hci_bridge.c
index 433c69e..4500f84 100644
--- a/drivers/staging/ath6kl/os/linux/hci_bridge.c
+++ b/drivers/staging/ath6kl/os/linux/hci_bridge.c
@@ -75,7 +75,7 @@ extern unsigned int hciuartstep;
 
 struct ar6k_hci_bridge_info {
     void                    *pHCIDev;          /* HCI bridge device */
-    HCI_TRANSPORT_PROPERTIES HCIProps;         /* HCI bridge props */
+    struct hci_transport_properties HCIProps;         /* HCI bridge props */
     struct hci_dev          *pBtStackHCIDev;   /* BT Stack HCI dev */
     bool                  HciNormalMode;     /* Actual HCI mode enabled (non-TEST)*/
     bool                  HciRegistered;     /* HCI device registered with stack */
@@ -216,7 +216,7 @@ static void RefillRecvBuffers(struct ar6k_hci_bridge_info      *pHcidevInfo,
         (((ar)->arTargetType == TARGET_TYPE_AR6002) ? AR6002_HOST_INTEREST_ITEM_ADDRESS(item) : \
         (((ar)->arTargetType == TARGET_TYPE_AR6003) ? AR6003_HOST_INTEREST_ITEM_ADDRESS(item) : 0))
 static int ar6000_hci_transport_ready(HCI_TRANSPORT_HANDLE     HCIHandle,
-                                           HCI_TRANSPORT_PROPERTIES *pProps, 
+                                           struct hci_transport_properties *pProps, 
                                            void                     *pContext)
 {
     struct ar6k_hci_bridge_info *pHcidevInfo = (struct ar6k_hci_bridge_info *)pContext;
-- 
1.7.4.15.g7811d

