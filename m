Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17820 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1LTSqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:46:34 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 6/6] ath9k_hw: fix sparse complaint on ar9003_switch_com_spdt_get()
Date: Tue, 20 Dec 2011 10:46:11 -0800
Message-ID: <1324406771-7100-7-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194637_771058_2ECDC9F9)
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This fixes this sparse complaint:

make C=2 CF="-D__CHECK_ENDIAN__" M=drivers/net/wireless/ath/

  CHECK   drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3544:21: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3544:21:    expected restricted __le32 [usertype] val
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3544:21:    got restricted __le16 [usertype] switchcomspdt
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3546:21: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3546:21:    expected restricted __le32 [usertype] val
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3546:21:    got restricted __le16 [usertype] switchcomspdt

The eep->modalHeader5G.switchcomspdt is a le16 and we return u16,
so just return le16_to_cpu().

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 391def9..9fbcbdd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3538,13 +3538,13 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 static u16 ar9003_switch_com_spdt_get(struct ath_hw *ah, bool is_2ghz)
 {
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	__le32 val;
+	__le16 val;
 
 	if (is_2ghz)
 		val = eep->modalHeader2G.switchcomspdt;
 	else
 		val = eep->modalHeader5G.switchcomspdt;
-	return le32_to_cpu(val);
+	return le16_to_cpu(val);
 }
 
 
-- 
1.7.4.15.g7811d

