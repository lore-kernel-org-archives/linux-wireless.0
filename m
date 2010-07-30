Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42329 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab0G3TCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 15:02:23 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/4] ath9k: fix a crash in the PA predistortion apply function
Date: Fri, 30 Jul 2010 21:02:11 +0200
Message-Id: <1280516532-42721-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280516532-42721-2-git-send-email-nbd@openwrt.org>
References: <1280516532-42721-1-git-send-email-nbd@openwrt.org>
 <1280516532-42721-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When updating the PAPRD table in hardware, PAPRD itself needs to be
disabled first, otherwise the hardware can throw a data bus error,
which upsets at least some platforms.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0429dda..6c1d9ef 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -239,6 +239,7 @@ static void ath_paprd_activate(struct ath_softc *sc)
 		return;
 
 	ath9k_ps_wakeup(sc);
+	ar9003_paprd_enable(ah, false);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
 		if (!(ah->caps.tx_chainmask & BIT(chain)))
 			continue;
-- 
1.6.4.2

