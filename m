Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:43866 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaGSLbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:03 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so5675126wes.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/16] staging: vt6656: struct vnt_private rename byLocalID to local_id
Date: Sat, 19 Jul 2014 12:30:06 +0100
Message-Id: <1405769418-2815-4-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133108_355546_31AEF649)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/dpc.c      | 2 +-
 drivers/staging/vt6656/key.c      | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index b9f4841..c1d0551 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -300,7 +300,7 @@ struct vnt_private {
 
 	/* Version control */
 	u16 firmware_version;
-	u8 byLocalID;
+	u8 local_id;
 	u8 byRFType;
 	u8 byBBRxConf;
 
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index f3da0db..5d4c2c1 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -175,7 +175,7 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 	rx_status.rate_idx = rate_idx;
 
 	if (ieee80211_has_protected(fc)) {
-		if (priv->byLocalID > REV_ID_VT3253_A1) {
+		if (priv->local_id > REV_ID_VT3253_A1) {
 			rx_status.flag |= RX_FLAG_DECRYPTED;
 
 			/* Drop packet */
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index b76ee31..22f2961 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -158,7 +158,7 @@ int vnt_set_keys(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		if (priv->byLocalID <= MAC_REVISION_A1)
+		if (priv->local_id <= MAC_REVISION_A1)
 			return -EINVAL;
 
 		key_dec_mode = KEY_CTL_CCMP;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ba2467c..9974bab 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -189,7 +189,7 @@ static int device_init_registers(struct vnt_private *priv)
 	/* local ID for AES functions */
 	status = vnt_control_in(priv, MESSAGE_TYPE_READ,
 		MAC_REG_LOCALID, MESSAGE_REQUEST_MACREG, 1,
-			&priv->byLocalID);
+			&priv->local_id);
 	if (status != STATUS_SUCCESS)
 		return false;
 
-- 
2.0.1

