Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbcDJLZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 07:25:37 -0400
From: Colin King <colin.king@canonical.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: remove duplicate assignment of variable ah
Date: Sun, 10 Apr 2016 12:25:31 +0100
Message-Id: <1460287531-17385-1-git-send-email-colin.king@canonical.com> (sfid-20160410_132624_200469_62F7AE7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

ah is written twice with the same value, remove one of the
redundant assignments to ah.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 77ace8d..fb702c4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -477,7 +477,7 @@ static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
 static int ath9k_eeprom_request(struct ath_softc *sc, const char *name)
 {
 	struct ath9k_eeprom_ctx ec;
-	struct ath_hw *ah = ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah;
 	int err;
 
 	/* try to load the EEPROM content asynchronously */
-- 
2.7.4

