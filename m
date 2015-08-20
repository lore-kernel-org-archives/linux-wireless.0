Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27331 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbHTE7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 00:59:31 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add spectral scan support for 10.4 fw
Date: Thu, 20 Aug 2015 10:29:05 +0530
Message-ID: <1440046745-428-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150820_065934_864921_7F49FF27)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable/configure spectral scan parameters in 10.4 firmware, existing
wmi spectral related functions can be reused. Link those functions in
10.4 wmi ops table.

In addition, adjust bin size (only when size is 68 bytes) before reporting
bin samples to user space. The background for this adjustment is that
qca99x0 reports bin size as 68 bytes (64 bytes + 4 bytes) in report
mode 2. First 64 bytes carries in-band tones (-32 to +31) and last 4 byte
carries band edge detection data (+32) mainly used in radar detection
purpose. Additional last 4 bytes are stripped to make bin size valid one.

This bin size adjustment will happen only for qca99x0, all other chipsets
will report proper bin sizes (64/128) without extra 4 bytes being added
at the end. The changes are validated in qca99x0 using 10.4 firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/spectral.c | 9 +++++++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index e4219b1..4671cfb 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -73,6 +73,15 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 	if (bin_len < 64 || bin_len > SPECTRAL_ATH10K_MAX_NUM_BINS)
 		return -EINVAL;
 
+	/* qca99x0 reports bin size as 68 bytes (64 bytes + 4 bytes) in
+	 * report mode 2. First 64 bytes carries inband tones (-32 to +31)
+	 * and last 4 byte carries band edge detection data (+32) mainly
+	 * used in radar detection purpose. Strip last 4 byte to make bin
+	 * size is valid one.
+	 */
+	if (bin_len == 68)
+		bin_len -= 4;
+
 	reg0 = __le32_to_cpu(fftr->reg0);
 	reg1 = __le32_to_cpu(fftr->reg1);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 42c0aba..5d19c87 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6581,6 +6581,8 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
 	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
 	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
+	.gen_vdev_spectral_conf = ath10k_wmi_op_gen_vdev_spectral_conf,
+	.gen_vdev_spectral_enable = ath10k_wmi_op_gen_vdev_spectral_enable,
 	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
 	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
 	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
-- 
1.8.1.2

