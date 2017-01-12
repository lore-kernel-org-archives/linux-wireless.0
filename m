Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57758 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdALNP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:27 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 11/13] wil6210: option to override A-BFT length in start AP/PCP
Date: Thu, 12 Jan 2017 15:06:03 +0200
Message-Id: <1484226365-10433-12-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141534_364502_D9F5FDFC)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add an option to specify and override the A-BFT length when
starting an AP/PCP. See IEEE P802.11-2016, 10.38.5.
The abft_len must be set before starting AP/PCP. It is only
needed for diagnostics and certification.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 +
 drivers/net/wireless/ath/wil6210/wmi.c     | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index bb8a59a..97e9088 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1702,6 +1702,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	WIL_FIELD(ap_isolate,	S_IRUGO,		doff_u32),
 	WIL_FIELD(discovery_mode, S_IRUGO | S_IWUSR,	doff_u8),
 	WIL_FIELD(chip_revision, S_IRUGO,		doff_u8),
+	WIL_FIELD(abft_len, S_IRUGO | S_IWUSR,		doff_u8),
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b3c7583..a73864f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -667,6 +667,7 @@ struct wil6210_priv {
 	struct dentry *debug;
 	struct wil_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
 	u8 discovery_mode;
+	u8 abft_len;
 
 	void *platform_handle;
 	struct wil_platform_ops platform_ops;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 598096f..27d21a3 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1079,6 +1079,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
 		.hidden_ssid = hidden_ssid,
 		.is_go = is_go,
 		.disable_ap_sme = disable_ap_sme,
+		.abft_len = wil->abft_len,
 	};
 	struct {
 		struct wmi_cmd_hdr wmi;
-- 
1.9.1
