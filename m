Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23623 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760646AbZKZPJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:43 -0500
Subject: [PATCH 11/12] wl1251: update tx_hdr when aliging skb in tx
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:09:38 +0200
Message-ID: <20091126150938.917.43592.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Before transmission when aligning the buffer to 4-byte bounday, tx_hdr
needs to be updated. Otherwise debug logs print false data.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index faa23ef..c822318 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -219,6 +219,7 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 			/* align the buffer on a 4-byte boundary */
 			skb_reserve(skb, offset);
 			memmove(skb->data, src, skb->len);
+			tx_hdr = (struct tx_double_buffer_desc *) skb->data;
 		} else {
 			wl1251_info("No handler, fixme!");
 			return -EINVAL;

