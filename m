Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45013 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab0G1PaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 11:30:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: enable serialize_regmode for non-PCIE AR9160
Date: Wed, 28 Jul 2010 11:15:27 -0400
Message-Id: <1280330127-5123-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16476

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Is there a better (i.e. either more precise or more inclusive) test
to be using here?

 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c33f17d..1041965 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -537,7 +537,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
+		     !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {
-- 
1.7.1.1

