Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63064 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab1DJTJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 15:09:58 -0400
Message-ID: <4DA20083.8050208@gmail.com>
Date: Sun, 10 Apr 2011 21:09:55 +0200
From: roel <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: index out of bounds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check whether index is within bounds before testing the element

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4c0d36a..1809409 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1092,8 +1092,7 @@ static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 	if (!(rate->flags & IEEE80211_TX_RC_MCS))
 		return rate->idx;
 
-	while (rate->idx > mcs_rix_off[i] &&
-	       i < ARRAY_SIZE(mcs_rix_off)) {
+	while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
 		rix++; i++;
 	}
 
