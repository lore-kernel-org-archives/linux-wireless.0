Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55390 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0BNXfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:35:14 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: dsd@gentoo.org, kune@deine-taler.de
Cc: linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 2/2] zd1211rw: Set hardware BSSID and set hardware IBSS mode
Date: Mon, 15 Feb 2010 00:34:59 +0100
Message-Id: <1266190499-2387-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr>
References: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both changes allow for proper TSF synchronisation in STA and IBSS mode.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   21 ++++++++++++++++++++-
 drivers/net/wireless/zd1211rw/zd_chip.h |    1 +
 drivers/net/wireless/zd1211rw/zd_mac.c  |    4 +++-
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 7ca95c4..f525459 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -397,6 +397,25 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 	return r;
 }
 
+int zd_write_bssid(struct zd_chip *chip, const u8 *bssid)
+{
+	struct zd_ioreq32 ioreqs[] = {
+		{ CR_BSSID_P1, 0 },
+		{ CR_BSSID_P2, 0 }
+	};
+
+	if (bssid) {
+		ioreqs[0].value = (bssid[3] << 24)
+				| (bssid[2] << 16)
+				| (bssid[1] <<  8)
+				|  bssid[0];
+		ioreqs[1].value = (bssid[5] <<  8)
+				|  bssid[4];
+	}
+
+	return zd_iowrite32a(chip, ioreqs, ARRAY_SIZE(ioreqs));
+}
+
 int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain)
 {
 	int r;
@@ -806,7 +825,7 @@ static int hw_init_hmac(struct zd_chip *chip)
 		{ CR_AFTER_PNP,			0x1 },
 		{ CR_WEP_PROTECT,		0x114 },
 		{ CR_IFS_VALUE,			IFS_VALUE_DEFAULT },
-		{ CR_CAM_MODE,			MODE_AP_WDS},
+		{ CR_CAM_MODE,			MODE_IBSS},
 	};
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index f8bbf7d..7b0c58c 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -881,6 +881,7 @@ static inline u8 _zd_chip_get_channel(struct zd_chip *chip)
 u8  zd_chip_get_channel(struct zd_chip *chip);
 int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain);
 int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr);
+int zd_write_bssid(struct zd_chip *chip, const u8 *bssid);
 int zd_chip_switch_radio_on(struct zd_chip *chip);
 int zd_chip_switch_radio_off(struct zd_chip *chip);
 int zd_chip_enable_int(struct zd_chip *chip);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 9cb6cbc..2559da5 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1096,7 +1096,9 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	mac->associated = associated;
 	spin_unlock_irq(&mac->lock);
 
-	/* TODO: do hardware bssid filtering */
+	if (changes & BSS_CHANGED_BSSID) {
+		zd_write_bssid(&mac->chip, bss_conf->bssid);
+	}
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		spin_lock_irqsave(&mac->lock, flags);
-- 
1.5.6.5

