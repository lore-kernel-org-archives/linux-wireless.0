Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbbCRSCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 14:02:23 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: enable ANI by default
Date: Wed, 18 Mar 2015 23:31:39 +0530
Message-ID: <1426701700-21974-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150318_190242_317457_56B220E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI is currently not enabled by default. Enable this feature by default.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..380d4b1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2896,6 +2896,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	ret = ath10k_wmi_pdev_set_param(ar,
+					ar->wmi.pdev_param->ani_enable, 1);
+	if (ret) {
+		ath10k_warn(ar, "failed to enable ani by default: %d\n",
+			    ret);
+		goto err_core_stop;
+	}
+
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 
-- 
1.9.1

