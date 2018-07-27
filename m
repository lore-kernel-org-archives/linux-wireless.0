Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40340 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731918AbeG0CCL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 22:02:11 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/3] ath10k:  Don't try un-supported idle_ps_config command.
Date: Thu, 26 Jul 2018 17:42:44 -0700
Message-Id: <1532652165-27272-2-git-send-email-greearb@candelatech.com> (sfid-20180727_024257_977896_BAEC0A11)
In-Reply-To: <1532652165-27272-1-git-send-email-greearb@candelatech.com>
References: <1532652165-27272-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The warning the the logs does not give user a clue as to what
command is failing, so it is worth it to check for un-supported
command before trying the call.

And add return-code to survey error message.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 541bc1c..345d333 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4690,10 +4690,13 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	}
 
 	param = ar->wmi.pdev_param->idle_ps_config;
-	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
-	if (ret && ret != -EOPNOTSUPP) {
-		ath10k_warn(ar, "failed to enable idle_ps_config: %d\n", ret);
-		goto err_core_stop;
+	if (param != WMI_PDEV_PARAM_UNSUPPORTED) {
+		ret = ath10k_wmi_pdev_set_param(ar, param, 1);
+		if (ret) {
+			ath10k_warn(ar, "failed to enable idle_ps_config: %d\n",
+				    ret);
+			goto err_core_stop;
+		}
 	}
 
 	__ath10k_set_antenna(ar, ar->cfg_tx_chainmask, ar->cfg_rx_chainmask);
@@ -6809,7 +6812,8 @@ ath10k_mac_update_bss_chan_survey(struct ath10k *ar,
 
 	ret = ath10k_wmi_pdev_bss_chan_info_request(ar, type);
 	if (ret) {
-		ath10k_warn(ar, "failed to send pdev bss chan info request\n");
+		ath10k_warn(ar, "failed to send pdev bss chan info request: %d\n",
+			    ret);
 		return;
 	}
 
-- 
2.4.11
