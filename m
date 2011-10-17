Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:63605 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1JQH3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 03:29:00 -0400
Date: Mon, 17 Oct 2011 10:28:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath9k_hw: min_t() casts u32 to int
Message-ID: <20111017072823.GA7812@elgon.mountain> (sfid-20111017_092912_036366_8062AFED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code here treats very large values of "limit" as less than
MAX_POWER_RATE because of the cast to int.  We should do the compare
as u32 instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e0c8549..f9abbb7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2526,7 +2526,7 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
 	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
 
-	reg->power_limit = min_t(int, limit, MAX_RATE_POWER);
+	reg->power_limit = min_t(u32, limit, MAX_RATE_POWER);
 	if (test)
 		channel->max_power = MAX_RATE_POWER / 2;
 
