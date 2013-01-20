Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39936 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3ATRwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:09 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/8] ath9k_hw: make the initval parameter to ath9k_hw_write_array const
Date: Sun, 20 Jan 2013 18:51:55 +0100
Message-Id: <1358704319-81749-4-git-send-email-nbd@openwrt.org> (sfid-20130120_185215_707453_4E870F62)
In-Reply-To: <1358704319-81749-3-git-send-email-nbd@openwrt.org>
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
 <1358704319-81749-2-git-send-email-nbd@openwrt.org>
 <1358704319-81749-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 +-
 drivers/net/wireless/ath/ath9k/hw.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a7448d1..0d84c1c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -203,7 +203,7 @@ void ath9k_hw_synth_delay(struct ath_hw *ah, struct ath9k_channel *chan,
 	udelay(hw_delay + BASE_ACTIVATE_DELAY);
 }
 
-void ath9k_hw_write_array(struct ath_hw *ah, struct ar5416IniArray *array,
+void ath9k_hw_write_array(struct ath_hw *ah, const struct ar5416IniArray *array,
 			  int column, unsigned int *writecnt)
 {
 	int r;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 04a3f3a..5c89aed 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1010,7 +1010,7 @@ void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
 void ath9k_hw_synth_delay(struct ath_hw *ah, struct ath9k_channel *chan,
 			  int hw_delay);
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
-void ath9k_hw_write_array(struct ath_hw *ah, struct ar5416IniArray *array,
+void ath9k_hw_write_array(struct ath_hw *ah, const struct ar5416IniArray *array,
 			  int column, unsigned int *writecnt);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
 u16 ath9k_hw_computetxtime(struct ath_hw *ah,
-- 
1.8.0.2

