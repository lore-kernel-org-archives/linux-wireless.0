Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6755 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab2BKPCM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 10:02:12 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ath9k: stop on rates with idx -1 in ath9k rate control's
 .tx_status
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	John W Linville <linville@tuxdriver.com>
Date: Sat, 11 Feb 2012 10:01:53 -0500
Message-ID: <20120211150152.4823.8570.stgit@ae> (sfid-20120211_160217_105712_42A27EBA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate control algorithms are supposed to stop processing when they
encounter a rate with the index -1.  Checking for rate->count not being
zero is not enough.

Allowing a rate with negative index leads to memory corruption in
ath_debug_stat_rc().

One consequence of the bug is discussed at
https://bugzilla.redhat.com/show_bug.cgi?id=768639

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: stable@vger.kernel.org
---

 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 635b592..a427a16 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1346,7 +1346,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	fc = hdr->frame_control;
 	for (i = 0; i < sc->hw->max_rates; i++) {
 		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
-		if (!rate->count)
+		if (rate->idx < 0 || !rate->count)
 			break;
 
 		final_ts_idx = i;
