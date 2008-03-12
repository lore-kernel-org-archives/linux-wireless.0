Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64725 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYCLUNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 16:13:34 -0400
Subject: [PATCH] ath5k: disable irq handling in ath5k_hw_detach()
From: Pavel Roskin <proski@gnu.org>
To: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 16:13:31 -0400
Message-Id: <1205352811.5557.2.camel@dv> (sfid-20080312_201339_338336_4DDB9726)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once ah has been freed, it may not be accessed.  Set ATH_STAT_INVALID
bit to make the interrupt handler return IRQ_NONE without accessing ah.

This fixes oops on unload with CONFIG_DEBUG_SHIRQ enabled.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/ath5k/hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 677600b..ff579a2 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -458,6 +458,8 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 
+	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
+
 	if (ah->ah_rf_banks != NULL)
 		kfree(ah->ah_rf_banks);
 

-- 
Regards,
Pavel Roskin
