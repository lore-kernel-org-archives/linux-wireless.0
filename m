Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0ICK27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 06:28:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Sep 2010 03:28:54 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_hw: Restore ANI registers to default during partial reset for AR9271
Date: Fri, 3 Sep 2010 16:00:00 +0530
Message-ID: <1283509800-5372-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AR9271 chips, if partial reset is done while scanning, the cycpwrThr1
will be set to maximum. This causes the degrade in DL throughput.
So restore the ANI registers to default during the partial reset.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   50 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |    2 +
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 303c63d..94392da 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -580,3 +580,53 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 	else
 		ath9k_hw_attach_ani_ops_old(ah);
 }
+
+void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	u32 modesIndex;
+	int i;
+
+	switch (chan->chanmode) {
+	case CHANNEL_A:
+	case CHANNEL_A_HT20:
+		modesIndex = 1;
+		break;
+	case CHANNEL_A_HT40PLUS:
+	case CHANNEL_A_HT40MINUS:
+		modesIndex = 2;
+		break;
+	case CHANNEL_G:
+	case CHANNEL_G_HT20:
+	case CHANNEL_B:
+		modesIndex = 4;
+		break;
+	case CHANNEL_G_HT40PLUS:
+	case CHANNEL_G_HT40MINUS:
+		modesIndex = 3;
+		break;
+
+	default:
+		return;
+	}
+
+	ENABLE_REGWRITE_BUFFER(ah);
+
+	for (i = 0; i < ah->iniModes_9271_ANI_reg.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniModes_9271_ANI_reg, i, 0);
+		u32 val = INI_RA(&ah->iniModes_9271_ANI_reg, i, modesIndex);
+		u32 val_orig;
+
+		if (reg == AR_PHY_CCK_DETECT) {
+			val_orig = REG_READ(ah, reg);
+			val &= AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK;
+			val_orig &= ~AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK;
+
+			REG_WRITE(ah, reg, val|val_orig);
+		} else
+			REG_WRITE(ah, reg, val);
+	}
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
+}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3384ca1..4d77b25 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1263,6 +1263,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah, true);
+			if (AR_SREV_9271(ah))
+				ar9002_hw_load_ani_reg(ah, chan);
 			return 0;
 		}
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1601dd4..780a70c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -985,6 +985,7 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah);
 void ar9002_hw_attach_ops(struct ath_hw *ah);
 void ar9003_hw_attach_ops(struct ath_hw *ah);
 
+void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
 /*
  * ANI work can be shared between all families but a next
  * generation implementation of ANI will be used only for AR9003 only
-- 
1.7.2.2

