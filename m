Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43083 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3ATUzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 15:55:32 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	stable@vger.kernel.org
Subject: [PATCH 3.8 3/3] ath9k: allow setting arbitrary antenna masks on AR9003+
Date: Sun, 20 Jan 2013 21:55:22 +0100
Message-Id: <1358715322-46447-3-git-send-email-nbd@openwrt.org> (sfid-20130120_215538_541551_20CB3BC3)
In-Reply-To: <1358715322-46447-2-git-send-email-nbd@openwrt.org>
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org>
 <1358715322-46447-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3796e65..dd91f8f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1826,6 +1826,9 @@ static u32 fill_chainmask(u32 cap, u32 new)
 
 static bool validate_antenna_mask(struct ath_hw *ah, u32 val)
 {
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		return true;
+
 	switch (val & 0x7) {
 	case 0x1:
 	case 0x3:
-- 
1.8.0.2

