Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab1KRIXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 72/77] iwlegacy: 4965-rs: remove null check on sta in il4965_rs_tx_status
Date: Fri, 18 Nov 2011 09:22:34 +0100
Message-Id: <1321604559-10707-72-git-send-email-sgruszka@redhat.com> (sfid-20111118_092340_208528_F31FCE2B)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

the null check on sta in il4965_rs_tx_status is not necessary

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 93c3a4d..b0946a1 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -991,7 +991,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	lq_sta->last_rate_n_flags = tx_rate;
 done:
 	/* See if there's a better rate or modulation mode to try. */
-	if (sta && sta->supp_rates[sband->band])
+	if (sta->supp_rates[sband->band])
 		il4965_rs_rate_scale_perform(il, skb, sta, lq_sta);
 }
 
-- 
1.7.1

