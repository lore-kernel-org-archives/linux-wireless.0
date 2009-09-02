Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f188.google.com ([209.85.211.188]:48648 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZIBKUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 06:20:43 -0400
Received: by ywh26 with SMTP id 26so1083565ywh.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 03:20:44 -0700 (PDT)
Date: Wed, 2 Sep 2009 15:50:55 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Reconfigure beacon timers after the scan is
	completed.
Message-ID: <20090902102055.GA3075@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index efee193..c2efdf2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2773,6 +2773,7 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	sc->sc_flags &= ~SC_OP_SCANNING;
 	sc->sc_flags |= SC_OP_FULL_RESET;
 	spin_unlock_bh(&sc->ani_lock);
+	ath_beacon_config(sc, NULL);
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.6.0.1

