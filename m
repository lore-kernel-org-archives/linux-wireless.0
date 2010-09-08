Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:57499 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0IHUit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 16:38:49 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: avoid unneeded calibration error messages
Date: Wed, 8 Sep 2010 22:37:41 +0200
Cc: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
References: <201009070110.11495.rossi.f@inwind.it> <201009070948.29066.br1@einfach.org>
In-Reply-To: <201009070948.29066.br1@einfach.org>
MIME-Version: 1.0
Message-Id: <201009082237.41479.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't generate calibration errors messages when not needed.

Signed-off-by: Fabio Rossi <rossi.f@inwind.it>
---
diff --git a/drivers/net/wireless/ath/ath5k/phy.c 
b/drivers/net/wireless/ath/ath5k/phy.c                                             
index 984ba92..4932bf2 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1377,7 +1377,7 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 
        /* protect against divide by 0 and loss of sign bits */
        if (i_coffd == 0 || q_coffd < 2)
-               return -1;
+               return 0;
 
        i_coff = (-iq_corr) / i_coffd;
        i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */
