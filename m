Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27322 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZG2Jm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 05:42:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 02:42:57 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/3] ath9k: Maintain monotonicity of PER while going across different phy
Date: Wed, 29 Jul 2009 15:05:22 +0530
Message-ID: <1248860123-12079-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1248860123-12079-1-git-send-email-vasanth@atheros.com>
References: <1248860123-12079-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monotonicity of packet error rate should be kept when moving
from one phy to another (legacy to ht, ht single stream to dual,
etc). Current code skips updating per for other phys.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 59ad47c..16a2717 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1041,9 +1041,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	/* Monotonicity is kept only for rates below the current rate. */
 	if (ath_rc_priv->per[tx_rate] < last_per) {
 		for (rate = tx_rate - 1; rate >= 0; rate--) {
-			if (rate_table->info[rate].phy !=
-			    rate_table->info[tx_rate].phy)
-				break;
 
 			if (ath_rc_priv->per[rate] >
 			    ath_rc_priv->per[rate+1]) {
-- 
1.5.5.1

