Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:37046 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3AJKpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 05:45:50 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, adrian@freebsd.org,
	linville@tuxdriver.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] ath9k: fix spectral scan endless mode on AR9002
Date: Thu, 10 Jan 2013 11:45:14 +0100
Message-Id: <1357814714-29426-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130110_114555_223141_A549BB56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a copy+paste error in ar9002 for the endless spectral mode,
fix that.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 51b7c81..2cb665e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -581,7 +581,7 @@ void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	 */
 	count = param->count;
 	if (param->endless)
-		count = 0;
+		count = 0x80;
 	else if (count & 0x80)
 		count = 0x7f;
 
-- 
1.7.10.4

