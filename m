Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35510 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KKP7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:59:18 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2076085eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:59:16 -0800 (PST)
Message-ID: <1352649551.6460.26.camel@canaries32-MCP7A> (sfid-20121111_165921_530463_7C2BBFE3)
Subject: [PATCH 13/14] staging: vt6656: 64 bit fixes correct sizes of
 NDIS_802_11_ASSOCIATION_INFORMATION
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:59:11 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wmgr.h | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 13dfb3b..52b1b56 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -89,44 +89,44 @@ typedef void (*TimerFunction)(unsigned long);
 
 //+++ NDIS related
 
-typedef unsigned char NDIS_802_11_MAC_ADDRESS[ETH_ALEN];
+typedef u8 NDIS_802_11_MAC_ADDRESS[ETH_ALEN];
 typedef struct _NDIS_802_11_AI_REQFI
 {
-    unsigned short Capabilities;
-    unsigned short ListenInterval;
+	u16 Capabilities;
+	u16 ListenInterval;
     NDIS_802_11_MAC_ADDRESS  CurrentAPAddress;
 } NDIS_802_11_AI_REQFI, *PNDIS_802_11_AI_REQFI;
 
 typedef struct _NDIS_802_11_AI_RESFI
 {
-    unsigned short Capabilities;
-    unsigned short StatusCode;
-    unsigned short AssociationId;
+	u16 Capabilities;
+	u16 StatusCode;
+	u16 AssociationId;
 } NDIS_802_11_AI_RESFI, *PNDIS_802_11_AI_RESFI;
 
 typedef struct _NDIS_802_11_ASSOCIATION_INFORMATION
 {
-    unsigned long                   Length;
-    unsigned short                  AvailableRequestFixedIEs;
-    NDIS_802_11_AI_REQFI    RequestFixedIEs;
-    unsigned long                   RequestIELength;
-    unsigned long                   OffsetRequestIEs;
-    unsigned short                  AvailableResponseFixedIEs;
-    NDIS_802_11_AI_RESFI    ResponseFixedIEs;
-    unsigned long                   ResponseIELength;
-    unsigned long                   OffsetResponseIEs;
+	u32 Length;
+	u16 AvailableRequestFixedIEs;
+	NDIS_802_11_AI_REQFI RequestFixedIEs;
+	u32 RequestIELength;
+	u32 OffsetRequestIEs;
+	u16 AvailableResponseFixedIEs;
+	NDIS_802_11_AI_RESFI ResponseFixedIEs;
+	u32 ResponseIELength;
+	u32 OffsetResponseIEs;
 } NDIS_802_11_ASSOCIATION_INFORMATION, *PNDIS_802_11_ASSOCIATION_INFORMATION;
 


 typedef struct tagSAssocInfo {
-    NDIS_802_11_ASSOCIATION_INFORMATION     AssocInfo;
-    BYTE                                    abyIEs[WLAN_BEACON_FR_MAXLEN+WLAN_BEACON_FR_MAXLEN];
-    // store ReqIEs set by OID_802_11_ASSOCIATION_INFORMATION
-    unsigned long                                   RequestIELength;
-    BYTE                                    abyReqIEs[WLAN_BEACON_FR_MAXLEN];
+	NDIS_802_11_ASSOCIATION_INFORMATION AssocInfo;
+	u8 abyIEs[WLAN_BEACON_FR_MAXLEN+WLAN_BEACON_FR_MAXLEN];
+	/* store ReqIEs set by OID_802_11_ASSOCIATION_INFORMATION */
+	u32 RequestIELength;
+	u8 abyReqIEs[WLAN_BEACON_FR_MAXLEN];
 } SAssocInfo, *PSAssocInfo;
-//---
+
 


-- 
1.8.0



