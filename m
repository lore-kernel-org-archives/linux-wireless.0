Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58008 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaF1W4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:24 -0400
Received: by mail-wg0-f41.google.com with SMTP id a1so6395800wgh.0
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging: vt6656: rxtx replace wFragCtl with frag_ctl.
Date: Sat, 28 Jun 2014 23:55:40 +0100
Message-Id: <1403996146-4082-2-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005636_626674_6D21ABD4)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use base type to __le16 and do endian correction.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 ++++++------
 drivers/staging/vt6656/rxtx.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f4833ff..5513121 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -978,21 +978,21 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
 		is_pspoll = true;
 
-	tx_buffer_head->wFragCtl =
-			cpu_to_le16(ieee80211_get_hdrlen_from_skb(skb)) << 10;
+	tx_buffer_head->frag_ctl =
+			cpu_to_le16(ieee80211_get_hdrlen_from_skb(skb) << 10);
 
 	if (info->control.hw_key) {
 		tx_key = info->control.hw_key;
 		switch (info->control.hw_key->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
-			tx_buffer_head->wFragCtl |= FRAGCTL_LEGACY;
+			tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_LEGACY);
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
-			tx_buffer_head->wFragCtl |= FRAGCTL_TKIP;
+			tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_TKIP);
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
-			tx_buffer_head->wFragCtl |= FRAGCTL_AES;
+			tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_AES);
 			need_mic = true;
 		default:
 			break;
@@ -1033,7 +1033,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 		return -ENOMEM;
 	}
 
-	tx_buffer_head->wFragCtl |= (u16)FRAGCTL_NONFRAG;
+	tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_NONFRAG);
 
 	tx_bytes = tx_header_size + tx_body_size;
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 26dc21c..1cfa5ae 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -224,7 +224,7 @@ struct vnt_tx_fifo_head {
 	u8 tx_key[WLAN_KEY_LEN_CCMP];
 	u16 wFIFOCtl;
 	__le16 time_stamp;
-	u16 wFragCtl;
+	__le16 frag_ctl;
 	__le16 current_rate;
 } __packed;
 
-- 
1.9.1

