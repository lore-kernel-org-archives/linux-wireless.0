Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33315 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbD2XwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:20 -0400
Received: by iecrt8 with SMTP id rt8so55310091iec.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:20 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 10/11] ath9k: Mix the received FFT bins to the random pool
Date: Wed, 29 Apr 2015 23:51:21 +0000
Message-Id: <1430351482-59418-11-git-send-email-mickflemm@gmail.com> (sfid-20150430_015226_347313_B044C2A0)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

E/M noise is a pretty good source of entropy so we mix the FFT
measurements of the E/M spectrum to /dev/random pool. Note that
this doesn't increase the pool's entropy count but it still helps
on improving the output of /dev/(u)random.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 5840b37..a876271 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/relay.h>
+#include <linux/random.h>
 #include "ath9k.h"
 
 static s8 fix_rssi_inv_only(u8 rssi_val)
@@ -647,13 +648,24 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 					    tsf, freq, chan_type);
 
 				memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
+
+				/* Mix the received bins to the /dev/random
+				 * pool
+				 */
+				add_device_randomness(sample_buf, num_bins);
 			}
 
 			/* Process a normal frame */
-			if (sample_bytes == sample_len)
+			if (sample_bytes == sample_len) {
 				ret = fft_handler(rs, spec_priv, sample_start,
 						  tsf, freq, chan_type);
 
+				/* Mix the received bins to the /dev/random
+				 * pool
+				 */
+				add_device_randomness(sample_start, num_bins);
+			}
+
 			/* Short report processed, break out of the
 			 * loop.
 			 */
-- 
2.3.5

