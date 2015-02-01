Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:36233 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbbBAMAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 07:00:15 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so34366461wes.7
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 04:00:14 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: vnt_rx_data add track rsr and new_rsr errors
Date: Sun,  1 Feb 2015 11:59:41 +0000
Message-Id: <1422791983-3408-4-git-send-email-tvboxspy@gmail.com> (sfid-20150201_130026_280853_14A34240)
In-Reply-To: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
References: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If not rsr & RSR_CRCOK report RX_FLAG_FAILED_FCS_CRC

If not rsr & (RSR_IVLDTYP | RSR_IVLDLEN) drop packet

If not NEWRSR_DECRYPTOK on new_rsr drop packet.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/dpc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 11cc090..3c5b87f 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -91,6 +91,8 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 	new_rsr = skb_data + bytes_received - 3;
 	rssi = skb_data + bytes_received - 2;
 	rsr = skb_data + bytes_received - 1;
+	if (*rsr & (RSR_IVLDTYP | RSR_IVLDLEN))
+		return false;
 
 	RFvRSSITodBm(priv, *rssi, &rx_dbm);
 
@@ -106,6 +108,9 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 	rx_status.flag = 0;
 	rx_status.freq = hw->conf.chandef.chan->center_freq;
 
+	if (!(*rsr & RSR_CRCOK))
+		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	hdr = (struct ieee80211_hdr *)(skb->data);
 	fc = hdr->frame_control;
 
@@ -113,7 +118,11 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 
 	if (ieee80211_has_protected(fc)) {
 		if (priv->byLocalID > REV_ID_VT3253_A1)
-			rx_status.flag = RX_FLAG_DECRYPTED;
+			rx_status.flag |= RX_FLAG_DECRYPTED;
+
+		/* Drop packet */
+		if (!(*new_rsr & NEWRSR_DECRYPTOK))
+			return false;
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-- 
2.1.0

