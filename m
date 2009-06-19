Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29821 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZFSS6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 14:58:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 11:58:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<Janath.Peiris@atheros.com>, <Matt.Smith@atheros.com>
Subject: [PATCH] ath9k: differentiate quality reporting between legacy and HT configurations
Date: Fri, 19 Jun 2009 11:57:59 -0700
Message-ID: <1245437879-3947-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not differentiating quality between legacy and HT
configurations. We change this to consider the differences.

New theory for reporting quality:

At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
At a hardware RSSI of 35 you should be able use 54 Mbps reliably.

MCS 7  is the highets MCS index usable by a 1-stream device.
MCS 15 is the highest MCS index usable by a 2-stream device.

All ath9k devices are either 1-stream or 2-stream.

How many bars you see is derived from the qual reporting.

A more elaborate scheme can be used here but it requires tables
of SNR/throughput for each possible mode used. For the MCS table
you can refer to the wireless wiki:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n

This should fix this bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=13537

Cc: Janath.Peiris@atheros.com
Cc: Matt.Smith@atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f20e843..e10a528 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -236,10 +236,31 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
 	rx_status->antenna = ds->ds_rxstat.rs_antenna;
 
-	/* at 45 you will be able to use MCS 15 reliably. A more elaborate
-	 * scheme can be used here but it requires tables of SNR/throughput for
-	 * each possible mode used. */
-	rx_status->qual =  ds->ds_rxstat.rs_rssi * 100 / 45;
+	/*
+	 * Theory for reporting quality:
+	 *
+	 * At a hardware RSSI of 45 you will be able to use MCS 7  reliably.
+	 * At a hardware RSSI of 45 you will be able to use MCS 15 reliably.
+	 * At a hardware RSSI of 35 you should be able use 54 Mbps reliably.
+	 *
+	 * MCS 7  is the highets MCS index usable by a 1-stream device.
+	 * MCS 15 is the highest MCS index usable by a 2-stream device.
+	 *
+	 * All ath9k devices are either 1-stream or 2-stream.
+	 *
+	 * How many bars you see is derived from the qual reporting.
+	 *
+	 * A more elaborate scheme can be used here but it requires tables
+	 * of SNR/throughput for each possible mode used. For the MCS table
+	 * you can refer to the wireless wiki:
+	 *
+	 * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
+	 *
+	 */
+	if (conf_is_ht(&hw->conf))
+		rx_status->qual =  ds->ds_rxstat.rs_rssi * 100 / 45;
+	else
+		rx_status->qual =  ds->ds_rxstat.rs_rssi * 100 / 35;
 
 	/* rssi can be more than 45 though, anything above that
 	 * should be considered at 100% */
-- 
1.6.2.2.446.gfbdc0

