Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43537 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZJMRe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 13:34:56 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/2] wl1251: use ieee80211_rx_ni()
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Tue, 13 Oct 2009 20:33:21 +0300
Message-ID: <20091013173321.13021.71988.stgit@tikku>
In-Reply-To: <20091013173313.13021.80289.stgit@tikku>
References: <20091013173313.13021.80289.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Because of SPI and SDIO wl1251 does everything in a workqueue, including
calling ieee80211_rx() which should be called with bottom halves disabled.
An error message is emitted because of this:

NOHZ: local_softirq_pending 08

Fix this by using ieee80211_rx_ni().

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 17c54b5..601fe0d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -153,7 +153,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
 		     beacon ? "beacon" : "");
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
-	ieee80211_rx(wl->hw, skb);
+	ieee80211_rx_ni(wl->hw, skb);
 }
 
 static void wl1251_rx_ack(struct wl1251 *wl)

