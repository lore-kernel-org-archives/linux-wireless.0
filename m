Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58200 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZFATl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:41:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RESEND][PATCH 1/4] ar9170: fix beacon plcp settings
Date: Mon, 1 Jun 2009 21:41:31 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
References: <200905120108.16068.chunkeey@web.de>
In-Reply-To: <200905120108.16068.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906012141.31368.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a simple copy & paste error that affected beacon
transmission in 802.11a mode.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
meh, no complains.
---
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 43aeb69..72c7b5d 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -398,10 +398,10 @@ int ar9170_update_beacon(struct ar9170 *ar)
 	/* XXX: use skb->cb info */
 	if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ)
 		ar9170_regwrite(AR9170_MAC_REG_BCN_PLCP,
-				((skb->len + 4) << (3+16)) + 0x0400);
+				((skb->len + 4) << (3 + 16)) + 0x0400);
 	else
 		ar9170_regwrite(AR9170_MAC_REG_BCN_PLCP,
-				((skb->len + 4) << (3+16)) + 0x0400);
+				((skb->len + 4) << 16) + 0x001b);
 
 	ar9170_regwrite(AR9170_MAC_REG_BCN_LENGTH, skb->len + 4);
 	ar9170_regwrite(AR9170_MAC_REG_BCN_ADDR, AR9170_BEACON_BUFFER_ADDRESS);
