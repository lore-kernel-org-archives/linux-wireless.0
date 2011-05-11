Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57218 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1EKV5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 17:57:30 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 14:57:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Fiona Cain <Fiona.Cain@atheros.com>,
	Ray Li <ray.li@greenwavereality.com>,
	Kathy Giori <kathy.giori@atheros.com>,
	Aeolus Yang <aeolus.yang@atheros.com>,
	Dan Friedman <dan.friedman@atheros.com>
Subject: [PATCH] ath9k_hw: fix dual band assumption for XB113
Date: Wed, 11 May 2011 14:57:26 -0700
Message-ID: <1305151046-13627-1-git-send-email-lrodriguez@atheros.com> (sfid-20110511_235733_619699_DB3B397A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The XB113 cards are single band, 5 GHz-only, but the
default settings were configured to assume it was dual
band. Users of these cards then would see 2.4 GHz channels
but you would never get any scan results from these channels
given that the radio is not present.

Cc: stable@kernel.org
Cc: Fiona Cain <Fiona.Cain@atheros.com>
Cc: Ray Li <ray.li@greenwavereality.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Dan Friedman <dan.friedman@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 3b13c1b..c35a68d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -652,7 +652,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,
-- 
1.7.4.15.g7811d

