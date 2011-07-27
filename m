Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1G0MNx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:13:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT v2 03/12] ath9k: merge common ->config_pci_powersave() checks
Date: Wed, 27 Jul 2011 14:14:50 +0200
Message-Id: <1311768899-4559-4-git-send-email-sgruszka@redhat.com> (sfid-20110727_141404_526793_6C63D592)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move common checks into wrapper function. Since ASPM can be only enabled
on PCIe devices ->is_pciexpress check is unneeded.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    3 ---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    3 ---
 drivers/net/wireless/ath/ath9k/hw-ops.h    |    3 +++
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 70a18d1..b54ab78 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -308,9 +308,6 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 	u8 i;
 	u32 val;
 
-	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
-		return;
-
 	/* Nothing to do on restore for 11N */
 	if (!power_off /* !restore */) {
 		if (AR_SREV_9280_20_OR_LATER(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index e3d58bd..9cf5d13 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -518,9 +518,6 @@ static void ar9003_hw_init_mode_gain_regs(struct ath_hw *ah)
 static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 					 bool power_off)
 {
-	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
-		return;
-
 	/* Nothing to do on restore for 11N */
 	if (!power_off /* !restore */) {
 		/* set bit 19 to allow forcing of pcie core into L1 state */
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 8c12385..dd9003e 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -24,6 +24,9 @@
 static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
 					       bool power_off)
 {
+	if (ah->aspm_enabled != true)
+		return;
+
 	ath9k_hw_ops(ah)->config_pci_powersave(ah, power_off);
 }
 
-- 
1.7.1

