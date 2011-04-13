Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60411 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440Ab1DMT4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:56:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 4/5] ath5k: fix the EEPROM check for hw AES crypto support
Date: Wed, 13 Apr 2011 21:56:45 +0200
Message-Id: <1302724606-10190-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302724606-10190-3-git-send-email-nbd@openwrt.org>
References: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
 <1302724606-10190-2-git-send-email-nbd@openwrt.org>
 <1302724606-10190-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EEPROM version 5.0 adds a new field for disabling AES support, having
an older version means that AES is present. This patch fixes hw AES
crypto support on AR5312 boards, which have an older EEPROM version.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index bc82405..326d7c8 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -318,7 +318,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 			  AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211);
 
 	if (srev >= AR5K_SREV_AR5212_V4 &&
-	    (ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
+	    (ee->ee_version < AR5K_EEPROM_VERSION_5_0 ||
 	    !AR5K_EEPROM_AES_DIS(ee->ee_misc5)))
 		common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
 
-- 
1.7.3.2

