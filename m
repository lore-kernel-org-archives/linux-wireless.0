Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64577 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbZIAMYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:24:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 05:24:55 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/2] ath9k: Call spin_lock_bh() on btcoex_lock
Date: Tue, 1 Sep 2009 17:46:33 +0530
Message-ID: <1251807393-8262-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251807393-8262-1-git-send-email-vasanth@atheros.com>
References: <1251807393-8262-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As generic hw timer interrupt handler is moved to tasklet,
we no more need to call spin_lock_irqsave().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 8fb3567..e8bfb01 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -84,15 +84,14 @@ static void ath_btcoex_period_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
-	unsigned long flags;
 
 	ath_detect_bt_priority(sc);
 
-	spin_lock_irqsave(&btinfo->btcoex_lock, flags);
+	spin_lock_bh(&btinfo->btcoex_lock);
 
 	ath_btcoex_bt_stomp(sc, btinfo, btinfo->bt_stomp_type);
 
-	spin_unlock_irqrestore(&btinfo->btcoex_lock, flags);
+	spin_unlock_bh(&btinfo->btcoex_lock);
 
 	if (btinfo->btcoex_period != btinfo->btcoex_no_stomp) {
 		if (btinfo->hw_timer_enabled)
@@ -119,18 +118,17 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 {
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_btcoex_info *btinfo = &sc->btcoex_info;
-	unsigned long flags;
 
 	DPRINTF(sc, ATH_DBG_BTCOEX, "no stomp timer running \n");
 
-	spin_lock_irqsave(&btinfo->btcoex_lock, flags);
+	spin_lock_bh(&btinfo->btcoex_lock);
 
 	if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
 		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
 	 else if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
 
-	spin_unlock_irqrestore(&btinfo->btcoex_lock, flags);
+	spin_unlock_bh(&btinfo->btcoex_lock);
 }
 
 static int ath_init_btcoex_info(struct ath_hw *hw,
-- 
1.5.5.1

