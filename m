Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40525 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327Ab2GCROw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:52 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 12/20] ath9k: fix antenna control configuration for AR9550
Date: Tue,  3 Jul 2012 19:13:26 +0200
Message-Id: <1341335614-15419-13-git-send-email-juhosg@openwrt.org> (sfid-20120703_192130_717582_D0FF168E)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    3 +++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 52e6955..57002d1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3591,6 +3591,9 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	if (AR_SREV_9462(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 				AR_SWITCH_TABLE_COM_AR9462_ALL, value);
+	} else if (AR_SREV_9550(ah)) {
+		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
+				AR_SWITCH_TABLE_COM_AR9550_ALL, value);
 	} else
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
 			      AR_SWITCH_TABLE_COM_ALL, value);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 89907c8..751c83b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -650,6 +650,8 @@
 #define AR_SWITCH_TABLE_COM_ALL_S (0)
 #define AR_SWITCH_TABLE_COM_AR9462_ALL (0xffffff)
 #define AR_SWITCH_TABLE_COM_AR9462_ALL_S (0)
+#define AR_SWITCH_TABLE_COM_AR9550_ALL (0xffffff)
+#define AR_SWITCH_TABLE_COM_AR9550_ALL_S (0)
 #define AR_SWITCH_TABLE_COM_SPDT (0x00f00000)
 #define AR_SWITCH_TABLE_COM_SPDT_ALL (0x0000fff0)
 #define AR_SWITCH_TABLE_COM_SPDT_ALL_S (4)
-- 
1.7.2.1

