Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbZJ2ATC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 20:19:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] ath9k: fix misplaced semicolon on rate control
Date: Wed, 28 Oct 2009 20:19:06 -0400
Message-Id: <1256775546-30774-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch e43419f9:

	ath9k: downgrade assert in rc.c for invalid rate

downgraded an ASSERT to a WARN_ON() but also misplaced a
semicolon at the end of the second check. What this did
was force the rate control code to always return the rate
even if we should have warned about it. Since this should
not have happened anymore anyway this fix isn't critical
as the proper rate would have been returned anyway.

Cc: stable@kernel.org
Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 0639364..bb72b46 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -679,7 +679,7 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 		return rate;
 
 	if (rate_table->info[rate].valid_single_stream &&
-	    !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG));
+	    !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
 		return rate;
 
 	/* This should not happen */
-- 
1.6.0.4

