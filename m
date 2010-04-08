Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4860 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0DHEAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 00:00:18 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	br1@einfach.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/4] ath5k: add bounds check to pdadc table
Date: Wed,  7 Apr 2010 23:55:59 -0400
Message-Id: <1270698959-7844-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1270698959-7844-1-git-send-email-me@bobcopeland.com>
References: <1270698959-7844-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We check the bounds on pdadc once when correcting for
negative curves but not when we later copy values from
from the pdadc_tmp array, leading to a potential overrun.

Although we shouldn't hit this case in practice, let's
be consistent.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 81bdebd..65ac50b 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2560,7 +2560,7 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw *ah,
 		max_idx = (pdadc_n < table_size) ? pdadc_n : table_size;
 
 		/* Fill pdadc_out table */
-		while (pdadc_0 < max_idx)
+		while (pdadc_0 < max_idx && pdadc_i < 128)
 			pdadc_out[pdadc_i++] = pdadc_tmp[pdadc_0++];
 
 		/* Need to extrapolate above this pdgain? */
-- 
1.6.3.3


