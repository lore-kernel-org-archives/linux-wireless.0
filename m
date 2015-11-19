Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35430 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331AbbKSPE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 10:04:58 -0500
Received: by qgec40 with SMTP id c40so52462707qge.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2015 07:04:57 -0800 (PST)
Received: from hash ([2001:470:1d:6db:230:48ff:fe9d:9c89])
        by smtp.gmail.com with ESMTPSA id c185sm2435123qka.44.2015.11.19.07.04.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2015 07:04:56 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix RTS/CTS by using proper rate flags
Date: Thu, 19 Nov 2015 10:04:48 -0500
Message-Id: <1447945488-13665-1-git-send-email-me@bobcopeland.com> (sfid-20151119_160502_408076_D7975AAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rates in the tx control rateset do not have the protection
flags applied, so RTS/CTS would never get enabled if requested.

Fix by using the rate flags in the rates returned by
ieee80211_get_tx_rates().

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 342563a..3d946d8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -767,7 +767,7 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
 
-	rc_flags = info->control.rates[0].flags;
+	rc_flags = bf->rates[0].flags;
 
 	hw_rate = ath5k_get_rate_hw_value(ah->hw, info, bf, 0);
 
-- 
2.1.4

