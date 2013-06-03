Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60725 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3FCVxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:53:48 -0400
Received: by mail-wg0-f43.google.com with SMTP id x12so3714003wgg.10
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:53:47 -0700 (PDT)
Message-ID: <1370296422.9091.34.camel@canaries64> (sfid-20130603_235351_432612_3EBB9BFF)
Subject: [PATCH 6/8] staging: vt6656: rf.c/h rename RFbRFTableDownload
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:53:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rename RFbRFTableDownload to vnt_rf_table_download.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 5 +++--
 drivers/staging/vt6656/rf.c       | 2 +-
 drivers/staging/vt6656/rf.h       | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 33fa767..c0f8b77 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1105,8 +1105,9 @@ else {
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x04,0x7F);
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
 
-    RFbRFTableDownload(pDevice);
-    return true;//ntStatus;
+	vnt_rf_table_download(pDevice);
+
+	return true;
 }
 
 /*
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index bcc9632..051e790 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -966,7 +966,7 @@ void vnt_rf_rssi_to_dbm(struct vnt_private *priv, u8 rssi, long *dbm)
 	*dbm = -1 * (a + b * 2);
 }
 
-void RFbRFTableDownload(struct vnt_private *priv)
+void vnt_rf_table_download(struct vnt_private *priv)
 {
 	u16 length1 = 0, length2 = 0, length3 = 0;
 	u8 *addr1 = NULL, *addr2 = NULL, *addr3 = NULL;
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 73abc5a..5d83017 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -59,6 +59,6 @@ int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
 void vnt_rf_rssi_to_dbm(struct vnt_private *, u8, long *);
-void RFbRFTableDownload(struct vnt_private *pDevice);
+void vnt_rf_table_download(struct vnt_private *);
 
 #endif /* __RF_H__ */
-- 
1.8.1.2

