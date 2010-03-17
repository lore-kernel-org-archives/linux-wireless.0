Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26854 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab0CQV1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:23 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/12] ath9k_hw: add HTC init hardware call for special resets for AR9271
Date: Wed, 17 Mar 2010 14:25:23 +0530
Message-ID: <1268816125-16173-11-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-10-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-8-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-9-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-10-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

AR9271 needs a full reset only upon the first reset, add
a call for the driver to enable these special resets. We
can optimize this out later without an export.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5bc5f5f..05aeb51 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1951,6 +1951,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_mark_phy_inactive(ah);
 
+	/* Only required on the first reset */
 	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
 		REG_WRITE(ah,
 			  AR9271_RESET_POWER_DOWN_CONTROL,
@@ -1963,6 +1964,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		return -EINVAL;
 	}
 
+	/* Only required on the first reset */
 	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
 		ah->htc_reset_init = false;
 		REG_WRITE(ah,
@@ -3857,6 +3859,16 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath_gen_timer_isr);
 
+/********/
+/* HTC  */
+/********/
+
+void ath9k_hw_htc_resetinit(struct ath_hw *ah)
+{
+	ah->htc_reset_init = true;
+}
+EXPORT_SYMBOL(ath9k_hw_htc_resetinit);
+
 static struct {
 	u32 version;
 	const char * name;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e63edfb..6b03e16 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -707,6 +707,9 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
 void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
 
+/* HTC */
+void ath9k_hw_htc_resetinit(struct ath_hw *ah);
+
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
-- 
1.6.4.2

