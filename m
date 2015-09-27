Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35561 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbbI0IS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 04:18:29 -0400
Received: by wicge5 with SMTP id ge5so67942029wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 01:18:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6656: don't stop TX queue unless buffer full.
Date: Sun, 27 Sep 2015 09:17:43 +0100
Message-Id: <1443341864-2756-5-git-send-email-tvboxspy@gmail.com> (sfid-20150927_101854_787529_D0162AEE)
In-Reply-To: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
References: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Presently the TX buffer stops while filling the buffer and urb.

However, this does not make use of the available buffer
space, it also lags the speed of the TX troughtput.

Only stop the queue when the buffer becomes full. The
URB complete will start the queue again when a
buffer and URB is available.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 7 +------
 drivers/staging/vt6656/rxtx.c     | 5 ++++-
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3fc6862..01e642d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -507,13 +507,8 @@ static void vnt_tx_80211(struct ieee80211_hw *hw,
 {
 	struct vnt_private *priv = hw->priv;
 
-	ieee80211_stop_queues(hw);
-
-	if (vnt_tx_packet(priv, skb)) {
+	if (vnt_tx_packet(priv, skb))
 		ieee80211_free_txskb(hw, skb);
-
-		ieee80211_wake_queues(hw);
-	}
 }
 
 static int vnt_start(struct ieee80211_hw *hw)
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index da075f4..efb54f5 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -101,9 +101,12 @@ static struct vnt_usb_send_context
 		}
 	}
 
-	if (ii == priv->num_tx_context)
+	if (ii == priv->num_tx_context) {
 		dev_dbg(&priv->usb->dev, "%s No Free Tx Context\n", __func__);
 
+		ieee80211_stop_queues(priv->hw);
+	}
+
 	return NULL;
 }
 
-- 
2.5.0

