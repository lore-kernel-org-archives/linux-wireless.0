Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:58264 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaF1W4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:22 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so6605556wes.26
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6656: rxtx struct vnt_mic_hdr change tsc_47_16/tsc_15_0
Date: Sat, 28 Jun 2014 23:55:39 +0100
Message-Id: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005634_949039_7E2FDF1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with ccmp_pn with size of IEEE80211_CCMP_PN_LEN(6)

memcpy the struct ieee80211_key_seq -> ccmp.pn onto ccmp_pn
removing the need for endian conversion.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 8 +-------
 drivers/staging/vt6656/rxtx.h | 3 +--
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7c9f232..f4833ff 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -848,13 +848,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 
 		ieee80211_get_key_tx_seq(tx_key, &seq);
 
-		mic_hdr->tsc_47_16 = cpu_to_be32((u32)seq.ccmp.pn[3] |
-						((u32)seq.ccmp.pn[2] << 8) |
-						((u32)seq.ccmp.pn[1] << 16) |
-						((u32)seq.ccmp.pn[0] << 24));
-
-		mic_hdr->tsc_15_0 = cpu_to_be16((u16)seq.ccmp.pn[5] |
-						((u16)seq.ccmp.pn[4] << 8));
+		memcpy(mic_hdr->ccmp_pn, seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
 
 		if (ieee80211_has_a4(hdr->frame_control))
 			mic_hdr->hlen = cpu_to_be16(28);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 847c055..26dc21c 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -41,8 +41,7 @@ struct vnt_mic_hdr {
 	u8 id;
 	u8 tx_priority;
 	u8 mic_addr2[6];
-	__be32 tsc_47_16;
-	__be16 tsc_15_0;
+	u8 ccmp_pn[IEEE80211_CCMP_PN_LEN];
 	__be16 payload_len;
 	__be16 hlen;
 	__le16 frame_control;
-- 
1.9.1

