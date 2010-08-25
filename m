Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2700 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab0HYBhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 21:37:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix off-by-one in pilot magnitude mask
Date: Tue, 24 Aug 2010 21:37:14 -0400
Message-Id: <1282700234-4079-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the symbol offset is 46, it will be counted in both
the third and fourth bytes of the mask, and in this
case the shift will be negative which can pollute
high order bits in the mask.  This may negatively impact
OFDM symbol detection.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Seems this patch from a while ago got lost, can go for 2.6.36 or .37
as you please.

 drivers/net/wireless/ath/ath5k/phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8c27a36..984ba92 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1582,7 +1582,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 			else if (curr_sym_off >= 31 && curr_sym_off <= 46)
 				mag_mask[2] |=
 					plt_mag_map << (curr_sym_off - 31) * 2;
-			else if (curr_sym_off >= 46 && curr_sym_off <= 53)
+			else if (curr_sym_off >= 47 && curr_sym_off <= 53)
 				mag_mask[3] |=
 					plt_mag_map << (curr_sym_off - 47) * 2;
 
-- 
1.7.1.1


