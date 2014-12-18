Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58264 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaLRXSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 18:18:18 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so227264wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 15:18:16 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 1/3] ath9k: enable TPC by default
Date: Fri, 19 Dec 2014 00:18:12 +0100
Message-Id: <1418944694-10614-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141219_001822_649363_53360950)
In-Reply-To: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable hw TPC by default on AR9003 based chips

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6d4b273..258c4d2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -422,6 +422,9 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 	ah->htc_reset_init = true;
 
+	/* ar9002 does not support TPC for the moment */
+	ah->tpc_enabled = !!AR_SREV_9300_20_OR_LATER(ah);
+
 	ah->ani_function = ATH9K_ANI_ALL;
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
-- 
2.1.0

