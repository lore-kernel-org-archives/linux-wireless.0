Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32774 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYJNEIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 00:08:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 21:08:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>,
	<mickflemm@gmail.com>, <jirislaby@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: correct signal quality report
Date: Mon, 13 Oct 2008 14:08:09 -0700
Message-ID: <1223932090-9274-3-git-send-email-lrodriguez@atheros.com> (sfid-20081014_060825_690346_754F5542)
In-Reply-To: <1223932090-9274-2-git-send-email-lrodriguez@atheros.com>
References: <1223932090-9274-1-git-send-email-lrodriguez@atheros.com>
 <1223932090-9274-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adjusts ath9k's signal quality reporting taking into
consideration received beacons at an RSSI of 45 should indicate
you can use of MCS 15 rate (144 Mbps) reliably on dual stream card.
Keep in mind mac80211 does not yet have aggregation fixed but this
should still provide more accurate results.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 16c90c1..6bcee4a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -279,8 +279,15 @@ static void ath9k_rx_prepare(struct ath_softc *sc,
 	rx_status->rate_idx = ath_rate2idx(sc, (status->rateKbps / 100));
 	rx_status->antenna = status->antenna;
 
-	/* XXX Fix me, 64 cannot be the max rssi value, rigure it out */
-	rx_status->qual = status->rssi * 100 / 64;
+	/* at 45 you will be able to use MCS 15 reliably. A more elaborate
+	 * scheme can be used here but it requires tables of SNR/throughput for
+	 * each possible mode used. */
+	rx_status->qual = status->rssi * 100 / 45;
+
+	/* rssi can be more than 45 though, anything above that
+	 * should be considered at 100% */
+	if (rx_status->qual > 100)
+		rx_status->qual = 100;
 
 	if (status->flags & ATH_RX_MIC_ERROR)
 		rx_status->flag |= RX_FLAG_MMIC_ERROR;
-- 
1.5.6.rc2.15.g457bb.dirty

