Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 07/20] ath9k_hw: consolidate the pci express checks on __ath9k_hw_init()
Date: Wed, 17 Mar 2010 18:28:00 -0400
Message-Id: <1268864893-11428-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8d376ce..9093235 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -535,10 +535,7 @@ int __ath9k_hw_init(struct ath_hw *ah)
 		return -EOPNOTSUPP;
 	}
 
-	if (AR_SREV_9100(ah))
-		ah->is_pciexpress = false;
-
-	if (AR_SREV_9271(ah))
+	if (AR_SREV_9100(ah) || AR_SREV_9271(ah))
 		ah->is_pciexpress = false;
 
 	/* XXX: move this to its own hw op */
-- 
1.6.3.3

