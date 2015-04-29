Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34272 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbD2XwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:18 -0400
Received: by iedfl3 with SMTP id fl3so62076629ied.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:18 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 9/11] ath9k: No need for that extra memset
Date: Wed, 29 Apr 2015 23:51:20 +0000
Message-Id: <1430351482-59418-10-git-send-email-mickflemm@gmail.com> (sfid-20150430_015222_424129_0A25B184)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Temp buffer is only used for fixing malformed frames, there is no
need to memset it every time.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 4ab08ed..5840b37 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -645,6 +645,8 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 
 				fft_handler(rs, spec_priv, sample_buf,
 					    tsf, freq, chan_type);
+
+				memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
 			}
 
 			/* Process a normal frame */
@@ -658,7 +660,6 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 			if (len <= fft_len + 2)
 				break;
 
-			memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
 			sample_start = &vdata[i + 1];
 
 			/* -1 to grab sample_len -1, -2 since
-- 
2.3.5

