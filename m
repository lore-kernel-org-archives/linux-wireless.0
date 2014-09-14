Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:64977 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaINTcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 15:32:07 -0400
Received: by mail-la0-f49.google.com with SMTP id pv20so3501294lab.22
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 12:32:05 -0700 (PDT)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [RFC 16/18] ath5k: correct conditional compilation
Date: Sun, 14 Sep 2014 23:33:31 +0400
Message-Id: <1410723213-22440-17-git-send-email-ryazanov.s.a@gmail.com> (sfid-20140914_213217_653560_A2855783)
In-Reply-To: <1410723213-22440-1-git-send-email-ryazanov.s.a@gmail.com>
References: <1410723213-22440-1-git-send-email-ryazanov.s.a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code parts should depend on a config symbol defined in the driver
instead of arch specific one.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
---
 drivers/net/wireless/ath/ath5k/ath5k.h | 2 +-
 drivers/net/wireless/ath/ath5k/base.c  | 4 ++--
 drivers/net/wireless/ath/ath5k/led.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 85316bb..1ed7a88 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1647,7 +1647,7 @@ static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
 	return &(ath5k_hw_common(ah)->regulatory);
 }
 
-#ifdef CONFIG_ATHEROS_AR231X
+#ifdef CONFIG_ATH5K_AHB
 #define AR5K_AR2315_PCI_BASE	((void __iomem *)0xb0100000)
 
 static inline void __iomem *ath5k_ahb_reg(struct ath5k_hw *ah, u16 reg)
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8ad2550..dd42487 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -99,7 +99,7 @@ static int ath5k_reset(struct ath5k_hw *ah, struct ieee80211_channel *chan,
 
 /* Known SREVs */
 static const struct ath5k_srev_name srev_names[] = {
-#ifdef CONFIG_ATHEROS_AR231X
+#ifdef CONFIG_ATH5K_AHB
 	{ "5312",	AR5K_VERSION_MAC,	AR5K_SREV_AR5312_R2 },
 	{ "5312",	AR5K_VERSION_MAC,	AR5K_SREV_AR5312_R7 },
 	{ "2313",	AR5K_VERSION_MAC,	AR5K_SREV_AR2313_R8 },
@@ -142,7 +142,7 @@ static const struct ath5k_srev_name srev_names[] = {
 	{ "5413",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5413 },
 	{ "5424",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5424 },
 	{ "5133",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5133 },
-#ifdef CONFIG_ATHEROS_AR231X
+#ifdef CONFIG_ATH5K_AHB
 	{ "2316",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2316 },
 	{ "2317",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2317 },
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 48a6a69b..c730677 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -162,7 +162,7 @@ int ath5k_init_leds(struct ath5k_hw *ah)
 {
 	int ret = 0;
 	struct ieee80211_hw *hw = ah->hw;
-#ifndef CONFIG_ATHEROS_AR231X
+#ifndef CONFIG_ATH5K_AHB
 	struct pci_dev *pdev = ah->pdev;
 #endif
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
@@ -171,7 +171,7 @@ int ath5k_init_leds(struct ath5k_hw *ah)
 	if (!ah->pdev)
 		return 0;
 
-#ifdef CONFIG_ATHEROS_AR231X
+#ifdef CONFIG_ATH5K_AHB
 	match = NULL;
 #else
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
-- 
1.8.1.5

