Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33729 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbD2XwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:16 -0400
Received: by igbpi8 with SMTP id pi8so983519igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:16 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 8/11] ath9k: Skip FFT reports if we are out of output buffers
Date: Wed, 29 Apr 2015 23:51:19 +0000
Message-Id: <1430351482-59418-9-git-send-email-mickflemm@gmail.com> (sfid-20150430_015221_221094_1C6D4FD7)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no reason to keep processing FFT reports if there is no
space left on the relayfs buffers for the results. This saves
lots of CPU cycles, especially on normal (non-short) reports.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index b8682bc..4ab08ed 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -473,6 +473,24 @@ ath_cmn_copy_fft_frame(u8 *in, u8 *out, int sample_len, int sample_bytes)
 	}
 }
 
+static int
+ath_cmn_is_fft_buf_full(struct ath_spec_scan_priv *spec_priv)
+{
+	int i = 0;
+	int ret = 0;
+	struct rchan *rc = spec_priv->rfs_chan_spec_scan;
+
+	for_each_online_cpu(i)
+		ret += relay_buf_full(rc->buf[i]);
+
+	i = num_online_cpus();
+
+	if (ret == i)
+		return 1;
+	else
+		return 0;
+}
+
 /* returns 1 if this was a spectral frame, even if not handled. */
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf)
@@ -509,6 +527,16 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
 		return 0;
 
+	/* Output buffers are full, no need to process anything
+	 * since there is no space to put the result anyway
+	 */
+	ret = ath_cmn_is_fft_buf_full(spec_priv);
+	if (ret == 1) {
+		ath_dbg(common, SPECTRAL_SCAN, "FFT report ignored, no space "
+						"left on output buffers\n");
+		return 1;
+	}
+
 	chan_type = cfg80211_get_chandef_type(&common->hw->conf.chandef);
 	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
 	    (chan_type == NL80211_CHAN_HT40PLUS)) {
-- 
2.3.5

