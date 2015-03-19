Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16398 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbbCSLIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 07:08:24 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH v2 1/2] ath10k: enable Adaptive Noise Immunity (ANI) by default
Date: Thu, 19 Mar 2015 16:37:59 +0530
Message-ID: <1426763280-11284-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150319_120828_468621_FFCB8173)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI helps to improve connectvity and performance in a noisy environment.
Enabling this feature would help the user experience a better and stable
wireless connection in a noisy environmnet. This feature is currently not
enabled for ath10k. Enable this feature by default.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
v2:
Update commit log (Kalle Valo)

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

