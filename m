Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0CMFq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:46:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 05/12] ath9k_hw: fix TX descriptor setup for AR9271
Date: Sat, 13 Mar 2010 00:46:49 -0500
Message-Id: <1268459216-22372-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

The TX descriptors setup for AR971 requires the same
setup as AR9285, so use that.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 589490b..7af823a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -351,7 +351,7 @@ void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	ads->ds_ctl6 = SM(keyType, AR_EncrType);
 
-	if (AR_SREV_9285(ah)) {
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
 		ads->ds_ctl8 = 0;
 		ads->ds_ctl9 = 0;
 		ads->ds_ctl10 = 0;
-- 
1.6.3.3

