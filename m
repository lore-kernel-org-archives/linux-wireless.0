Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64778 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbZK1X4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 18:56:02 -0500
Received: by fxm5 with SMTP id 5so2617724fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 15:56:07 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ar9170: fix AC_VIDEO txop parameter
Date: Sun, 29 Nov 2009 01:01:14 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911290101.14825.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a rather embarrassing typo.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
low priority

Thanks to the simplistic firmwares the typo was never 
more than a _just_ a typo...
---
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index ddc8c09..857e861 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -117,7 +117,7 @@ int ar9170_set_qos(struct ar9170 *ar)
 	ar9170_regwrite(AR9170_MAC_REG_AC1_AC0_TXOP,
 			ar->edcf[0].txop | ar->edcf[1].txop << 16);
 	ar9170_regwrite(AR9170_MAC_REG_AC3_AC2_TXOP,
-			ar->edcf[1].txop | ar->edcf[3].txop << 16);
+			ar->edcf[2].txop | ar->edcf[3].txop << 16);
 
 	ar9170_regwrite_finish();
 
