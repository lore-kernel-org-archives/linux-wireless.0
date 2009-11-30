Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51831 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZK3ISE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 03:18:04 -0500
Subject: [PATCH v2 02/11] wl1251: print a debug message when tx_queue is full
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Nov 2009 10:17:45 +0200
Message-ID: <20091130081745.17360.93259.stgit@tikku>
In-Reply-To: <20091130081706.17360.48084.stgit@tikku>
References: <20091130081706.17360.48084.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

This debug message was missing and caused incomplete log messages.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index ff4be7b..0417745 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -395,6 +395,7 @@ static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * the queue here, otherwise the queue will get too long.
 	 */
 	if (skb_queue_len(&wl->tx_queue) >= WL1251_TX_QUEUE_MAX_LENGTH) {
+		wl1251_debug(DEBUG_TX, "op_tx: tx_queue full, stop queues");
 		ieee80211_stop_queues(wl->hw);
 
 		/*

