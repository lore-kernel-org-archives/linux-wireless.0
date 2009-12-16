Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229AbZLPQvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 11:51:50 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: greg@kroah.com, stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/5] ath9k: Fix TX hang poll routine
Date: Wed, 16 Dec 2009 11:51:41 -0500
Message-Id: <1260982305-32244-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
References: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

When TX is hung, the chip is reset. Ensure that
the chip is awake by using the PS wrappers.

This is a backport of upstream commit:

332c556633b8c5fb4e890b1783122f2315526590

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 42551a4..972e775 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2065,7 +2065,9 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 
 	if (needreset) {
 		DPRINTF(sc, ATH_DBG_RESET, "tx hung, resetting the chip\n");
+		ath9k_ps_wakeup(sc);
 		ath_reset(sc, false);
+		ath9k_ps_restore(sc);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
-- 
1.6.3.3

