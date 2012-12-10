Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63048 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2LJV40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:56:26 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1849215eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 13:56:25 -0800 (PST)
Message-ID: <1355176559.4680.15.camel@canaries64> (sfid-20121210_225640_372704_E7B2FD86)
Subject: [PATCH 01/11] staging: vt6656: create new structure names to remove
 typedefs.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 21:55:59 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch and the next 8 patches remove the old structure names and
replace;


struct vnt_private for DEVICE_INFO and PSDevice
struct vnt_manager for SMgmtObject
struct vnt_rx_mgmt for SRxMgmtPacket and PSRxMgmtPacket
struct vnt_tx_mgmt for STxMgmtPacket and PSTxMgmtPacket

and

struct vnt_manager vnt_mgmt
to replace
SMgmtObject sMgmtObj;

Applied after patch staging: vt6656: dpc.c :RXbBulkInProcessData clean up RSC

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  3 ++-
 drivers/staging/vt6656/wmgr.h   | 10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 047f550..37ec234 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -392,7 +392,7 @@ typedef struct __device_opt {
 } OPTIONS, *POPTIONS;
 

-typedef struct __device_info {
+typedef struct vnt_private {
 
 // netdev
 	struct usb_device*          usb;
@@ -525,6 +525,7 @@ typedef struct __device_info {
 

     // 802.11 management
+	struct vnt_manager vnt_mgmt;
     SMgmtObject                 sMgmtObj;
 
 	u64 qwCurrTSF;
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 876c352..f98309b 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -218,8 +218,8 @@ typedef enum tagWMAC_POWER_MODE {
 


-// Tx Management Packet descriptor
-typedef struct tagSTxMgmtPacket {
+/* Tx Management Packet descriptor */
+typedef struct vnt_tx_mgmt {
 
     PUWLAN_80211HDR     p80211Header;
     unsigned int                cbMPDULen;
@@ -228,8 +228,8 @@ typedef struct tagSTxMgmtPacket {
 } STxMgmtPacket, *PSTxMgmtPacket;
 

-// Rx Management Packet descriptor
-typedef struct tagSRxMgmtPacket {
+/* Rx Management Packet descriptor */
+typedef struct vnt_rx_mgmt {
 
     PUWLAN_80211HDR     p80211Header;
 	u64 qwLocalTSF;
@@ -244,7 +244,7 @@ typedef struct tagSRxMgmtPacket {
 


-typedef struct tagSMgmtObject
+typedef struct vnt_manager
 {
 	void *pAdapter;
     // MAC address
-- 
1.8.0





