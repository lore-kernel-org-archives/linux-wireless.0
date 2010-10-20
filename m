Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34648 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab0JTN7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 09:59:36 -0400
Message-ID: <4CBEF5C0.7070008@openwrt.org>
Date: Wed, 20 Oct 2010 15:59:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: fix crash in ath_update_survey_stats
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ah->curchan is uninitialized, the channel index is bogus, which leads
to invalid memory access when the cycle counters are updated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -183,6 +183,9 @@ static void ath_update_survey_stats(stru
 	struct ath_cycle_counters *cc = &common->cc_survey;
 	unsigned int div = common->clockrate * 1000;
 
+	if (!ah->curchan)
+		return;
+
 	if (ah->power_mode == ATH9K_PM_AWAKE)
 		ath_hw_cycle_counters_update(common);
 
