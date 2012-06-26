Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43033 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2FZUir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:38:47 -0400
Received: by wgbdr13 with SMTP id dr13so299451wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:38:46 -0700 (PDT)
From: Panayiotis Karabassis <panayk@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, shafi.wireless@gmail.com,
	fynivx@gmail.com, gilleshabran@gmail.com,
	Panayiotis Karabassis <panayk@gmail.com>
Subject: [PATCH v2] ath9k: enable serialize_regmode for non-PCIE AR9287
Date: Tue, 26 Jun 2012 23:37:17 +0300
Message-Id: <1340743037-16133-1-git-send-email-panayk@gmail.com> (sfid-20120626_223851_240023_3DC1BAB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42903

Based on the work of <fynivx@gmail.com>

Signed-off-by: Panayiotis Karabassis <panayk@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a42c26f..ebfb2a3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -614,7 +614,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
 		     !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;
-- 
1.7.10

