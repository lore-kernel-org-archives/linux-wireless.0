Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36608 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbcESPPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 11:15:40 -0400
Received: by mail-wm0-f48.google.com with SMTP id n129so235591667wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 08:15:39 -0700 (PDT)
From: Eduardo Abinader <eabinader@ocedo.com>
To: linux-wireless@vger.kernel.org
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>,
	ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Proper TX99 interrupt ref count
Date: Thu, 19 May 2016 17:15:29 +0200
Message-Id: <1463670929-12639-1-git-send-email-eduardo.abinader@riverbed.com> (sfid-20160519_171545_031732_2E9804D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On TX99 mode, instead of assuming interrupt mask non ATH9K_INT_GLOBAL,
let ath9k_hw_disable_interrupts proper set interrupt ref count.
This prevents some PCI PERR occurring specialy when setting 11b and n rates.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index ac4781f..7f3643e 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -132,7 +132,6 @@ static int ath9k_tx99_init(struct ath_softc *sc)
 	ath9k_ps_wakeup(sc);
 
 	ath9k_hw_disable_interrupts(ah);
-	atomic_set(&ah->intr_ref_cnt, -1);
 	ath_drain_all_txq(sc);
 	ath_stoprecv(sc);
 
-- 
2.5.0

