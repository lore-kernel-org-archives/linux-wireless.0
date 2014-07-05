Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58949 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbaGESY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:24:57 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so14069664wiv.14
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6656: vnt_rx_data add track rsr and new_rsr errors
Date: Sat,  5 Jul 2014 19:24:24 +0100
Message-Id: <1404584667-3582-5-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202501_474714_A454633B)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rsr and new_rsr error packet error drop.

if NEWRSR_DECRYPTOK fails drop packet altogether.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index ca55554..f3da0db 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -143,7 +143,10 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 
 	new_rsr = skb_data + 8 + pay_load_with_padding + 9;
 	rssi = skb_data + 8 + pay_load_with_padding + 10;
+
 	rsr = skb_data + 8 + pay_load_with_padding + 11;
+	if (*rsr & (RSR_IVLDTYP | RSR_IVLDLEN))
+		return false;
 
 	frame_size = *pay_load_len;
 
@@ -163,14 +166,24 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 	rx_status.flag = 0;
 	rx_status.freq = hw->conf.chandef.chan->center_freq;
 
+	if (!(*rsr & RSR_CRCOK))
+		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	hdr = (struct ieee80211_hdr *)(skb->data);
 	fc = hdr->frame_control;
 
 	rx_status.rate_idx = rate_idx;
 
 	if (ieee80211_has_protected(fc)) {
-		if (priv->byLocalID > REV_ID_VT3253_A1)
-			rx_status.flag = RX_FLAG_DECRYPTED;
+		if (priv->byLocalID > REV_ID_VT3253_A1) {
+			rx_status.flag |= RX_FLAG_DECRYPTED;
+
+			/* Drop packet */
+			if (!(*new_rsr & NEWRSR_DECRYPTOK)) {
+				dev_kfree_skb(skb);
+				return true;
+			}
+		}
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-- 
1.9.1

