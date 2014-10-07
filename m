Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40683 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaJGK1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 06:27:36 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so8788151wgg.18
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 03:27:34 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: fix WMI scan command length
Date: Tue,  7 Oct 2014 12:26:43 +0200
Message-Id: <1412677603-11748-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141007_122748_307312_2AC2BAFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix WMI scan command length we setup when scan request.

This fix issue with 636 firmware when scan always failed
with message:

ath10k_pci 0000:02:00.0: wmi start scan
ath10k_pci 0000:02:00.0: wmi stop scan reqid 1 req_type 0 vdev/scan_id 0
ath10k_pci 0000:02:00.0: failed to stop wmi scan: -11
ath10k_pci 0000:02:00.0: failed to stop scan: -11
ath10k_pci 0000:02:00.0: failed to start hw scan: -110

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f65032f..d878fbe 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3506,10 +3506,10 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 		return ret;
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		len = sizeof(struct wmi_start_scan_cmd) +
+		len = sizeof(struct wmi_10x_start_scan_cmd) +
 		      ath10k_wmi_start_scan_tlvs_len(arg);
 	else
-		len = sizeof(struct wmi_10x_start_scan_cmd) +
+		len = sizeof(struct wmi_start_scan_cmd) +
 		      ath10k_wmi_start_scan_tlvs_len(arg);
 
 	skb = ath10k_wmi_alloc_skb(ar, len);
-- 
1.9.1

