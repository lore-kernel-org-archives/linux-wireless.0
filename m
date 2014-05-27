Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41157 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaE0UGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:19 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so9848839wgg.18
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/10] staging: vt6656: rf.c rename RFbRFTableDownload to vnt_rf_table_download.
Date: Tue, 27 May 2014 21:05:24 +0100
Message-Id: <1401221126-4219-8-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220646_276948_9424EC30)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 3 +--
 drivers/staging/vt6656/rf.c       | 2 +-
 drivers/staging/vt6656/rf.h       | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index d96308f..694e34a 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1040,8 +1040,7 @@ int BBbVT3184Init(struct vnt_private *priv)
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x04, 0x7f);
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);
 
-	RFbRFTableDownload(priv);
-
+	vnt_rf_table_download(priv);
 
 	/* Fix for TX USB resets from vendors driver */
 	vnt_control_in(priv, MESSAGE_TYPE_READ, USB_REG4,
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 4e1a28d..4420114 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -992,7 +992,7 @@ void vnt_rf_rssi_to_dbm(struct vnt_private *priv, u8 rssi, long *dbm)
 	*dbm = -1 * (a + b * 2);
 }
 
-void RFbRFTableDownload(struct vnt_private *priv)
+void vnt_rf_table_download(struct vnt_private *priv)
 {
 	u16 length1 = 0, length2 = 0, length3 = 0;
 	u8 *addr1 = NULL, *addr2 = NULL, *addr3 = NULL;
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index bc0e923..cb33151 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -61,6 +61,6 @@ int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
 void vnt_rf_rssi_to_dbm(struct vnt_private *, u8, long *);
-void RFbRFTableDownload(struct vnt_private *pDevice);
+void vnt_rf_table_download(struct vnt_private *);
 
 #endif /* __RF_H__ */
-- 
1.9.1

