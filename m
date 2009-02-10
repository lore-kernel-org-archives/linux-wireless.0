Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40109 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZBJXgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 18:36:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 15:36:11 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: add udelay() for AR5416 on ath9k_hw_configpcipowersave()
Date: Tue, 10 Feb 2009 15:35:27 -0800
Message-ID: <1234308927-18405-1-git-send-email-lrodriguez@atheros.com> (sfid-20090211_003618_778960_C0AC32EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need the udelay() for all families, including AR5416.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index cfcaaf8..cad8e39 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2666,7 +2666,6 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
 				  INI_RA(&ah->iniPcieSerdes, i, 1));
 		}
-		udelay(1000);
 	} else if (AR_SREV_9280(ah) &&
 		   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
@@ -2690,7 +2689,6 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		/* Load the new settings */
 		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 
-		udelay(1000);
 	} else {
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
@@ -2714,6 +2712,8 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 	}
 
+	udelay(1000);
+
 	/* set bit 19 to allow forcing of pcie core into L1 state */
 	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
-- 
1.5.6.3

