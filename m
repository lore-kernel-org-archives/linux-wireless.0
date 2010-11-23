Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41631 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0KWTpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:45:36 -0500
Received: by ewy5 with SMTP id 5so2682097ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:45:35 -0800 (PST)
Date: Tue, 23 Nov 2010 21:45:21 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 26/30] ath5k: Skip tx power setting on AR5210 for now
Message-ID: <20101123194521.GZ4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Don't return -EINVAL when trying to set tx power
 on RF5110 because AR5210 reset will fail. We need to
 add support for RF5110 and AR5210 eeprom in the future
 but for now just skip it.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8790f0a..31239ab 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3109,6 +3109,9 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 
 	/* Initialize TX power table */
 	switch (ah->ah_radio) {
+	case AR5K_RF5110:
+		/* TODO */
+		return 0;
 	case AR5K_RF5111:
 		type = AR5K_PWRTABLE_PWR_TO_PCDAC;
 		break;
