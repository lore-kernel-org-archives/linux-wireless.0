Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60495 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab0KWBXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 20:23:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 17:22:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/3] ath9k: avoid aggregation for VO traffic
Date: Mon, 22 Nov 2010 17:23:02 -0800
Message-ID: <1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should help with latency issues which can happen when
using aggregation.

Cc: Matt Smith <matt.smith@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 33bb33b..f1c1a93 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1363,7 +1363,8 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	/* Check if aggregation has to be enabled for this tid */
 	if (conf_is_ht(&sc->hw->conf) &&
 	    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
-		if (ieee80211_is_data_qos(fc)) {
+		if (ieee80211_is_data_qos(fc) &&
+		    (ieee802_1d_to_ac[skb->priority] != IEEE80211_AC_VO)) {
 			u8 *qc, tid;
 			struct ath_node *an;
 
-- 
1.7.3.2.90.gd4c43

