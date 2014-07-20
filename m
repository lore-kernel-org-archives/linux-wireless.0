Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:41647 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaGTOek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:40 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so6520140wes.29
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/25] staging: vt6656: struct vnt_private replace wSeqCounter with seq_counter
Date: Sun, 20 Jul 2014 15:33:23 +0100
Message-Id: <1405866815-2687-13-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_717737_F7F0DDCD)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  2 +-
 drivers/staging/vt6656/rxtx.c   | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 905e90b..6647b2b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -364,7 +364,7 @@ struct vnt_private {
 	u16 current_aid;
 
 	/* Beacon releated */
-	u16 wSeqCounter;
+	u16 seq_counter;
 
 	enum vnt_cmd_state command_state;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0e4b773..8d745af 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -914,7 +914,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 				tx_key, skb, tx_body_size, mic_hdr);
 	}
 
-	priv->wSeqCounter = (le16_to_cpu(hdr->seq_ctrl) &
+	priv->seq_counter = (le16_to_cpu(hdr->seq_ctrl) &
 						IEEE80211_SCTL_SEQ) >> 4;
 
 	tx_buffer->tx_byte_count = cpu_to_le16(tx_bytes);
@@ -1004,12 +1004,12 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)mgmt_hdr;
 		hdr->duration_id = 0;
-		hdr->seq_ctrl = cpu_to_le16(priv->wSeqCounter << 4);
+		hdr->seq_ctrl = cpu_to_le16(priv->seq_counter << 4);
 	}
 
-	priv->wSeqCounter++;
-	if (priv->wSeqCounter > 0x0fff)
-		priv->wSeqCounter = 0;
+	priv->seq_counter++;
+	if (priv->seq_counter > 0x0fff)
+		priv->seq_counter = 0;
 
 	count = sizeof(struct vnt_tx_short_buf_head) + skb->len;
 
-- 
2.0.1

