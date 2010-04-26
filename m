Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab0DZTEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 11/13] ath9k_hw: Fix endian bug in an AR9003 EEPROM field
Date: Mon, 26 Apr 2010 15:04:39 -0400
Message-Id: <1272308681-32396-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 25dd44d..8a79550 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -659,6 +659,9 @@ static void ar9300_swap_eeprom(struct ar9300_eeprom *eep)
 	word = swab16(eep->baseEepHeader.regDmn[1]);
 	eep->baseEepHeader.regDmn[1] = word;
 
+	dword = swab32(eep->baseEepHeader.swreg);
+	eep->baseEepHeader.swreg = dword;
+
 	dword = swab32(eep->modalHeader2G.antCtrlCommon);
 	eep->modalHeader2G.antCtrlCommon = dword;
 
-- 
1.6.3.3

