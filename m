Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3726 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbYJZPZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 11:25:23 -0400
Date: Sun, 26 Oct 2008 11:24:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: lrodriguez@atheros.com, jmalinen@atheros.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: remove useless conditional
Message-ID: <20081026152448.GA15496@hash.localnet> (sfid-20081026_162527_986339_E7AF0EF5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I saw this while reading through the ath9k code.  Not sure if it was
just dead code or if it should be returning false.

From: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath9k: remove useless conditional

ath9k_hw_keyreset returns true in either branch.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/hw.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 98bc25c..c920822 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -7194,9 +7194,6 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry)
 
 	}
 
-	if (ah->ah_curchan == NULL)
-		return true;
-
 	return true;
 }
 
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com

