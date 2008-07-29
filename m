Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17149 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbYG2Frr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:47 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:47 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, Sujith <Sujith.Manoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 14/16] ath9k: Remove AH_DEBUG_COUNTRY
Date: Mon, 28 Jul 2008 22:47:23 -0700
Message-ID: <6715bf581146b1b2610ce6bbada3c7147485eec9.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081546_733887_1F9724BB)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index a3dee36..8a99365 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -102,10 +102,9 @@ static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 
 	if (cc == CTRY_DEFAULT)
 		return true;
-#ifdef AH_DEBUG_COUNTRY
 	if (cc == CTRY_DEBUG)
 		return true;
-#endif
+
 	rd = ath9k_regd_get_eepromRD(ah);
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: EEPROM regdomain 0x%x\n",
 		 __func__, rd);
-- 
1.5.4.3

