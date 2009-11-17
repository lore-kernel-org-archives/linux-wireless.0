Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53020 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbZKQQuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:50:10 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 15/16] wl1251: remove depcreated qual usage
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:50:01 +0200
Message-ID: <20091117165000.2236.74825.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Fixes warnings:

drivers/net/wireless/wl12xx/wl1251_rx.c: In function 'wl1251_rx_status':
drivers/net/wireless/wl12xx/wl1251_rx.c:75:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)
drivers/net/wireless/wl12xx/wl1251_rx.c:77:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)
drivers/net/wireless/wl12xx/wl1251_rx.c:77:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)
drivers/net/wireless/wl12xx/wl1251_rx.c:77:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)
drivers/net/wireless/wl12xx/wl1251_rx.c:78:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)
drivers/net/wireless/wl12xx/wl1251_rx.c:78:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)
drivers/net/wireless/wl12xx/wl1251_rx.c:78:
  warning: 'qual' is deprecated (declared at include/net/mac80211.h:555)


Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_rx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 601fe0d..f84cc89 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -72,10 +72,6 @@ static void wl1251_rx_status(struct wl1251 *wl,
 	}
 
 	status->signal = desc->rssi;
-	status->qual = (desc->rssi - WL1251_RX_MIN_RSSI) * 100 /
-		(WL1251_RX_MAX_RSSI - WL1251_RX_MIN_RSSI);
-	status->qual = min(status->qual, 100);
-	status->qual = max(status->qual, 0);
 
 	/*
 	 * FIXME: guessing that snr needs to be divided by two, otherwise

