Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2335 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZBUTor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 14:44:47 -0500
Date: Sat, 21 Feb 2009 14:44:18 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: fix 802.11g conformance test limit typo
Message-ID: <20090221194418.GA31157@hash.localnet> (sfid-20090221_204451_866445_ADF8E504)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


802.11g is in 2 ghz band, not 5 ghz.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/regd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index eb0d1b7..a510917 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -478,7 +478,7 @@ u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (IS_CHAN_B(chan))
 		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11B;
 	else if (IS_CHAN_G(chan))
-		ctl = ah->regulatory.regpair->reg_5ghz_ctl | CTL_11G;
+		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11G;
 	else
 		ctl = ah->regulatory.regpair->reg_5ghz_ctl | CTL_11A;
 
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

