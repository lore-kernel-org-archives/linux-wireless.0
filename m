Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45311 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753758AbdDJPem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 11:34:42 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: Fix spectral scan for QCA99X0 family of chipsets
Date: Mon, 10 Apr 2017 21:08:17 +0530
Message-ID: <1491838697-25393-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170410_174741_102393_F1B0128D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

spectral_bin length (number of bins per fft sample) is usually
a value where (2^n = value), n is an integer.  All of the QCA99X0
family of chipsets seems to report a spectral_bin length of
2^n + 'm' bytes, where m = 4, 12 based on the chipset. This 'm'
bytes seems to carry some radar related info which is currently
discarded only for 'bin_len = 68' bytes. Extend this discarding of
irrelevant 'bin_len' for QCA9984, QCA9888, IPQ4019 as well by
introducing a hardware parameter 'spectral_bin_discard'. Also
for QCA988X based family of chipsets which doesn't seem to have this
issue and also for some of the hardware which I have not tested
like QCA6174/QCA9377 the existing behaviour is retained as it is.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[v2: fixed spelling mistake in commit log]

 drivers/net/wireless/ath/ath10k/core.c     |   12 ++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h       |    3 +++
 drivers/net/wireless/ath/ath10k/spectral.c |   25 +++++++++++++++++--------
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f450ebb..d023084 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -71,6 +71,7 @@
 		},
 		.hw_ops = &qca988x_ops,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -91,6 +92,7 @@
 		},
 		.hw_ops = &qca988x_ops,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -110,6 +112,7 @@
 		},
 		.hw_ops = &qca988x_ops,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -129,6 +132,7 @@
 		},
 		.hw_ops = &qca988x_ops,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -148,6 +152,7 @@
 		},
 		.hw_ops = &qca988x_ops,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -170,6 +175,7 @@
 		.hw_clk = qca6174_clk,
 		.target_cpu_freq = 176000000,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -195,6 +201,7 @@
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &qca99x0_ops,
 		.decap_align_bytes = 1,
+		.spectral_bin_discard = 4,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -221,6 +228,7 @@
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &qca99x0_ops,
 		.decap_align_bytes = 1,
+		.spectral_bin_discard = 12,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -246,6 +254,7 @@
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &qca99x0_ops,
 		.decap_align_bytes = 1,
+		.spectral_bin_discard = 12,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -265,6 +274,7 @@
 		},
 		.hw_ops = &qca988x_ops,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -286,6 +296,7 @@
 		.hw_clk = qca6174_clk,
 		.target_cpu_freq = 176000000,
 		.decap_align_bytes = 4,
+		.spectral_bin_discard = 0,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -312,6 +323,7 @@
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &qca99x0_ops,
 		.decap_align_bytes = 1,
+		.spectral_bin_discard = 4,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d370b57..6db2568 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -447,6 +447,9 @@ struct ath10k_hw_params {
 	/* hw specific clock control parameters */
 	const struct ath10k_hw_clk_params *hw_clk;
 	int target_cpu_freq;
+
+	/* Number of bytes to be discarded for each FFT sample */
+	int spectral_bin_discard;
 };
 
 struct htt_rx_desc;
diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index c061d69..3fd5d7d 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -56,6 +56,21 @@ static uint8_t get_max_exp(s8 max_index, u16 max_magnitude, size_t bin_len,
 	return max_exp;
 }
 
+static inline size_t ath10k_spectral_fix_bin_size(struct ath10k *ar,
+						  size_t bin_len)
+{
+	/* some chipsets reports bin size as 2^n bytes + 'm' bytes in
+	 * report mode 2. First 2^n bytes carries inband tones and last
+	 * 'm' bytes carries band edge detection data mainly used in
+	 * radar detection purpose. Strip last 'm' bytes to make bin size
+	 * as a valid one. 'm' can take possible values of 4, 12.
+	 */
+	if (!is_power_of_2(bin_len))
+		bin_len -= ar->hw_params.spectral_bin_discard;
+
+	return bin_len;
+}
+
 int ath10k_spectral_process_fft(struct ath10k *ar,
 				struct wmi_phyerr_ev_arg *phyerr,
 				const struct phyerr_fft_report *fftr,
@@ -70,17 +85,11 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 
 	fft_sample = (struct fft_sample_ath10k *)&buf;
 
+	bin_len = ath10k_spectral_fix_bin_size(ar, bin_len);
+
 	if (bin_len < 64 || bin_len > SPECTRAL_ATH10K_MAX_NUM_BINS)
 		return -EINVAL;
 
-	/* qca99x0 reports bin size as 68 bytes (64 bytes + 4 bytes) in
-	 * report mode 2. First 64 bytes carries inband tones (-32 to +31)
-	 * and last 4 byte carries band edge detection data (+32) mainly
-	 * used in radar detection purpose. Strip last 4 byte to make bin
-	 * size is valid one.
-	 */
-	if (bin_len == 68)
-		bin_len -= 4;
 
 	reg0 = __le32_to_cpu(fftr->reg0);
 	reg1 = __le32_to_cpu(fftr->reg1);
-- 
1.7.9.5
