Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49972 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbeISQOh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:14:37 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 2/5] ath9k: return when short FFT frame was handled
Date: Wed, 19 Sep 2018 12:37:08 +0200
Message-Id: <20180919103711.19304-3-sw@simonwunderlich.de> (sfid-20180919_123722_412125_E01E2F42)
In-Reply-To: <20180919103711.19304-1-sw@simonwunderlich.de>
References: <20180919103711.19304-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the loop break like this, there are false "FFT report truncated"
messages because the iterator is not advanced as the check expects.

Instead, just return, for a single frame there is nothing left to be
done anyways.

Cc: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 0c5559009a28..f6dd0ecfbbf3 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -686,7 +686,7 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 			 * loop.
 			 */
 			if (len <= fft_len + 2)
-				break;
+				return 1;
 
 			sample_start = &vdata[i + 1];
 
-- 
2.11.0
