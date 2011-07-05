Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35808 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1GEW1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:27:13 -0400
Date: Wed, 6 Jul 2011 00:27:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ipw2100: Fix command list for debugging
Message-ID: <20110706002706.51bfc492@endymion.delvare> (sfid-20110706_002716_110289_AA6BE77B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a stray "undefined" string in the array, get rid of it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
Changes since v1:
* Only drop the extra string, as advised by John Linville.

 drivers/net/wireless/ipw2x00/ipw2100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.0-rc6.orig/drivers/net/wireless/ipw2x00/ipw2100.c	2011-07-05 10:07:59.000000000 +0200
+++ linux-3.0-rc6/drivers/net/wireless/ipw2x00/ipw2100.c	2011-07-06 00:22:14.000000000 +0200
@@ -287,7 +287,7 @@ static const char *command_types[] = {
 	"unused",		/* HOST_INTERRUPT_COALESCING */
 	"undefined",
 	"CARD_DISABLE_PHY_OFF",
-	"MSDU_TX_RATES" "undefined",
+	"MSDU_TX_RATES",
 	"undefined",
 	"SET_STATION_STAT_BITS",
 	"CLEAR_STATIONS_STAT_BITS",


-- 
Jean Delvare
