Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36625 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbD2XwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:09 -0400
Received: by iebrs15 with SMTP id rs15so55326771ieb.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:08 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 06/11] ath9k: Skip malformed frames on normal FFT report
Date: Wed, 29 Apr 2015 23:51:17 +0000
Message-Id: <1430351482-59418-7-git-send-email-mickflemm@gmail.com> (sfid-20150430_015213_484749_730178FE)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we have lots of frames on a normal FFT report don't bother
processing the malformed ones. Only try to fix malformed frames
in case of a short FFT report (only a single frame on the report).

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 94 ++++++++++++++++--------
 1 file changed, 62 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 51ab396..0c9bc9e 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -437,6 +437,42 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 	return 0;
 }
 
+static inline void
+ath_cmn_copy_fft_frame(u8 *in, u8 *out, int sample_len, int sample_bytes)
+{
+	switch (sample_bytes - sample_len) {
+	case -1:
+		/* First byte missing */
+		memcpy(&out[1], in,
+		       sample_len - 1);
+		break;
+	case 0:
+		/* Length correct, nothing to do. */
+		memcpy(out, in, sample_len);
+		break;
+	case 1:
+		/* MAC added 2 extra bytes AND first byte
+		 * is missing.
+		 */
+		memcpy(&out[1], in, 30);
+		out[31] = in[31];
+		memcpy(&out[32], &in[33],
+		       sample_len - 32);
+		break;
+	case 2:
+		/* MAC added 2 extra bytes at bin 30 and 32,
+		 * remove them.
+		 */
+		memcpy(out, in, 30);
+		out[30] = in[31];
+		memcpy(&out[31], &in[33],
+		       sample_len - 31);
+		break;
+	default:
+		break;
+	}
+}
+
 /* returns 1 if this was a spectral frame, even if not handled. */
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf)
@@ -570,46 +606,40 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 		if (got_slen) {
 			ath_dbg(common, SPECTRAL_SCAN, "FFT frame len: %i\n",
 				sample_bytes);
-			switch (sample_bytes - sample_len) {
-			case -1:
-				/* First byte missing */
-				memcpy(&sample_buf[1], sample_start,
-				       sample_len - 1);
-				break;
-			case 0:
-				/* Length correct, nothing to do. */
+
+			/* Only try to fix a frame if it's the only one
+			 * on the report, else just skip it.
+			 */
+			if (sample_bytes != sample_len && len <= fft_len + 2) {
+				ath_cmn_copy_fft_frame(sample_start,
+						       sample_buf, sample_len,
+						       sample_bytes);
+
+				fft_handler(rs, spec_priv, sample_buf,
+					    tsf, freq, chan_type);
+			}
+
+			/* Process a normal frame */
+			if (sample_bytes == sample_len) {
 				memcpy(sample_buf, sample_start, sample_len);
-				break;
-			case 1:
-				/* MAC added 2 extra bytes AND first byte
-				 * is missing.
-				 */
-				memcpy(&sample_buf[1], sample_start, 30);
-				sample_buf[31] = sample_start[31];
-				memcpy(&sample_buf[32], &sample_start[33],
-				       sample_len - 32);
-				break;
-			case 2:
-				/* MAC added 2 extra bytes at bin 30 and 32,
-				 * remove them.
-				 */
-				memcpy(sample_buf, sample_start, 30);
-				sample_buf[30] = sample_start[31];
-				memcpy(&sample_buf[31], &sample_start[33],
-				       sample_len - 31);
-				break;
-			default:
-				break;
+				ret = fft_handler(rs, spec_priv, sample_buf,
+						  tsf, freq, chan_type);
 			}
 
-			ret = fft_handler(rs, spec_priv, sample_buf, tsf,
-							freq, chan_type);
+			/* Short report processed, break out of the
+			 * loop.
+			 */
+			if (len <= fft_len + 2)
+				break;
+
 			memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
 			sample_start = &vdata[i + 1];
+
 			/* -1 to grab sample_len -1, -2 since
 			 * they 'll get increased by one. In case
 			 * of failure try to recover by going byte
-			 * by byte instead. */
+			 * by byte instead.
+			 */
 			if (ret == 0) {
 				i += num_bins - 2;
 				sample_bytes = num_bins - 2;
-- 
2.3.5

