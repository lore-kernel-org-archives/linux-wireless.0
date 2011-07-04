Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:43494 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab1GDMyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 08:54:00 -0400
Date: Mon, 4 Jul 2011 14:53:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ipw2100: Fix command list for debugging
Message-ID: <20110704145346.384a462a@endymion.delvare> (sfid-20110704_145404_274012_DE992E19)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A missing comma in the array causes an off-by-one for later commands.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
Note: I don't have the documentation and I don't have the hardware, so
an expert should double-check this one.

 drivers/net/wireless/ipw2x00/ipw2100.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-3.0-rc5.orig/drivers/net/wireless/ipw2x00/ipw2100.c	2011-05-20 10:42:41.000000000 +0200
+++ linux-3.0-rc5/drivers/net/wireless/ipw2x00/ipw2100.c	2011-07-04 14:44:22.000000000 +0200
@@ -287,7 +287,8 @@ static const char *command_types[] = {
 	"unused",		/* HOST_INTERRUPT_COALESCING */
 	"undefined",
 	"CARD_DISABLE_PHY_OFF",
-	"MSDU_TX_RATES" "undefined",
+	"MSDU_TX_RATES",
+	"undefined",
 	"undefined",
 	"SET_STATION_STAT_BITS",
 	"CLEAR_STATIONS_STAT_BITS",


-- 
Jean Delvare
