Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab1DUUau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 16:30:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 13:30:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>, <kvalo@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/5] ath6kl: add the device ID on the data command packet
Date: Thu, 21 Apr 2011 13:30:38 -0700
Message-ID: <1303417840-19605-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
References: <1303417840-19605-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

The firmware expects the device ID to be added on the
data and command packets sent to firmware for AR6003 v2.1.1.

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/common/wmi.h |   23 ++++++++++++++++++++++-
 drivers/staging/ath6kl/wmi/wmi.c            |    4 +++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index 46c6410..24636e6 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -155,6 +155,16 @@ typedef enum {
 #define WMI_DATA_HDR_GET_META(h)        (((h)->info2 >> WMI_DATA_HDR_META_SHIFT) & WMI_DATA_HDR_META_MASK)
 #define WMI_DATA_HDR_SET_META(h, _v)    ((h)->info2 = ((h)->info2 & ~(WMI_DATA_HDR_META_MASK << WMI_DATA_HDR_META_SHIFT)) | ((_v) << WMI_DATA_HDR_META_SHIFT))
 
+/* Macros for operating on WMI_DATA_HDR (info3) field */
+#define WMI_DATA_HDR_DEVID_MASK      0xF
+#define WMI_DATA_HDR_DEVID_SHIFT     0
+#define GET_DEVID(_v)                ((_v) & WMI_DATA_HDR_DEVID_MASK)
+
+#define WMI_DATA_HDR_GET_DEVID(h) \
+	(((h)->info3 >> WMI_DATA_HDR_DEVID_SHIFT) & WMI_DATA_HDR_DEVID_MASK)
+#define WMI_DATA_HDR_SET_DEVID(h, _v) \
+	((h)->info3 = ((h)->info3 & ~(WMI_DATA_HDR_DEVID_MASK << WMI_DATA_HDR_DEVID_SHIFT)) | (GET_DEVID(_v) << WMI_DATA_HDR_DEVID_SHIFT))
+
 typedef PREPACK struct {
     s8 rssi;
     u8 info;               /* usage of 'info' field(8-bit):
@@ -171,7 +181,7 @@ typedef PREPACK struct {
                                      * b12          - A-MSDU?
                                      * b15:b13      - META_DATA_VERSION 0 - 7
                                      */
-    u16 reserved;
+    u16 info3;
 } POSTPACK WMI_DATA_HDR;
 
 /*
@@ -255,6 +265,17 @@ typedef PREPACK struct {
 
 
 #define WMI_GET_DEVICE_ID(info1) ((info1) & 0xF)
+/* Macros for operating on WMI_CMD_HDR (info1) field */
+#define WMI_CMD_HDR_DEVID_MASK      0xF
+#define WMI_CMD_HDR_DEVID_SHIFT     0
+#define GET_CMD_DEVID(_v)           ((_v) & WMI_CMD_HDR_DEVID_MASK)
+
+#define WMI_CMD_HDR_GET_DEVID(h) \
+	(((h)->info1 >> WMI_CMD_HDR_DEVID_SHIFT) & WMI_CMD_HDR_DEVID_MASK)
+#define WMI_CMD_HDR_SET_DEVID(h, _v) \
+	((h)->info1 = ((h)->info1 & \
+		~(WMI_CMD_HDR_DEVID_MASK << WMI_CMD_HDR_DEVID_SHIFT)) | \
+		 (GET_CMD_DEVID(_v) << WMI_CMD_HDR_DEVID_SHIFT))
 
 /*
  * Control Path
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 7033fc1..c3a1cc5 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -509,7 +509,8 @@ wmi_data_hdr_add(struct wmi_t *wmip, void *osbuf, u8 msgType, bool bMoreData,
     }
 
     WMI_DATA_HDR_SET_META(dtHdr, metaVersion);
-    //dtHdr->rssi = 0;
+
+    dtHdr->info3 = 0;
 
     return (0);
 }
@@ -2986,6 +2987,7 @@ wmi_dataSync_send(struct wmi_t *wmip, void *osbuf, HTC_ENDPOINT_ID eid)
     dtHdr->info =
       (SYNC_MSGTYPE & WMI_DATA_HDR_MSG_TYPE_MASK) << WMI_DATA_HDR_MSG_TYPE_SHIFT;
 
+    dtHdr->info3 = 0;
     A_DPRINTF(DBG_WMI, (DBGFMT "Enter - eid %d\n", DBGARG, eid));
 
     return (A_WMI_CONTROL_TX(wmip->wmi_devt, osbuf, eid));
-- 
1.7.4.15.g7811d

