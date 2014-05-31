Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43435 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbaEaKvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:42 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so3140979wes.12
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/14] staging: vt6656: rename MACvEnableBarkerPreambleMd to vnt_mac_enable_barker_preamble_mode
Date: Sat, 31 May 2014 11:50:47 +0100
Message-Id: <1401533449-2972-12-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125145_778655_126D7932)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 2 +-
 drivers/staging/vt6656/mac.c   | 2 +-
 drivers/staging/vt6656/mac.h   | 2 +-
 drivers/staging/vt6656/wmgr.c  | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 093b583..0a662e7 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -971,7 +971,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 
 		if (uLongPreambleSTACnt > 0) {
 			if (!pDevice->bBarkerPreambleMd) {
-				MACvEnableBarkerPreambleMd(pDevice);
+				vnt_mac_enable_barker_preamble_mode(pDevice);
 				pDevice->bBarkerPreambleMd = true;
 			}
 		} else if (pDevice->bBarkerPreambleMd) {
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 96fff70..94e9f95 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -208,7 +208,7 @@ void vnt_mac_disable_protect_mode(struct vnt_private *priv)
 		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvEnableBarkerPreambleMd(struct vnt_private *priv)
+void vnt_mac_enable_barker_preamble_mode(struct vnt_private *priv)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index effab75..9b0cac4 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -425,7 +425,7 @@ void vnt_mac_write_word(struct vnt_private *, u8, u16);
 void vnt_mac_set_bssid_addr(struct vnt_private *, u8 *);
 void vnt_mac_enable_protect_mode(struct vnt_private *);
 void vnt_mac_disable_protect_mode(struct vnt_private *);
-void MACvEnableBarkerPreambleMd(struct vnt_private *);
+void vnt_mac_enable_barker_preamble_mode(struct vnt_private *);
 void MACvDisableBarkerPreambleMd(struct vnt_private *);
 void MACvWriteBeaconInterval(struct vnt_private *, u16);
 void vnt_mac_set_led(struct vnt_private *priv, u8, u8);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index f35fdd8..7a5f699 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1668,7 +1668,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                         pDevice->bBarkerPreambleMd = (pBSSList->sERP.byERP & WLAN_EID_ERP_BARKER_MODE);
                         //BarkerPreambleMd has higher priority than shortPreamble bit in Cap
                         if (pDevice->bBarkerPreambleMd) {
-                            MACvEnableBarkerPreambleMd(pDevice);
+			    vnt_mac_enable_barker_preamble_mode(pDevice);
                         } else {
                             MACvDisableBarkerPreambleMd(pDevice);
                         }
@@ -2400,7 +2400,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                     pDevice->bBarkerPreambleMd = (pCurr->sERP.byERP & WLAN_EID_ERP_BARKER_MODE);
                     //BarkerPreambleMd has higher priority than shortPreamble bit in Cap
                     if (pDevice->bBarkerPreambleMd) {
-                        MACvEnableBarkerPreambleMd(pDevice);
+			vnt_mac_enable_barker_preamble_mode(pDevice);
                     } else {
                         MACvDisableBarkerPreambleMd(pDevice);
                     }
-- 
1.9.1

