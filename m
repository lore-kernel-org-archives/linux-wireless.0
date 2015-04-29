Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38599 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbD2XwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:11 -0400
Received: by igbhj9 with SMTP id hj9so63879971igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:10 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 07/11] ath9k: No need for that extra memcpy
Date: Wed, 29 Apr 2015 23:51:18 +0000
Message-Id: <1430351482-59418-8-git-send-email-mickflemm@gmail.com> (sfid-20150430_015217_081668_0AF366CA)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to copy the frame to the temporary buffer when its length
is ok.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 0c9bc9e..b8682bc 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -620,11 +620,9 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 			}
 
 			/* Process a normal frame */
-			if (sample_bytes == sample_len) {
-				memcpy(sample_buf, sample_start, sample_len);
-				ret = fft_handler(rs, spec_priv, sample_buf,
+			if (sample_bytes == sample_len)
+				ret = fft_handler(rs, spec_priv, sample_start,
 						  tsf, freq, chan_type);
-			}
 
 			/* Short report processed, break out of the
 			 * loop.
-- 
2.3.5

