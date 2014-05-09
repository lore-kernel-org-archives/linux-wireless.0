Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59156 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEIMbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:31:40 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2630732eei.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:31:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: clean up start() callback
Date: Fri,  9 May 2014 14:15:45 +0200
Message-Id: <1399637749-13489-2-git-send-email-michal.kazior@tieto.com> (sfid-20140509_143143_008698_15AEF71A)
In-Reply-To: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes failpath when override AC pdev param
setup fails and makes other pdev params setting
fail as well.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e2c01dc..eef9104 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2339,22 +2339,19 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	if (ar->state != ATH10K_STATE_OFF &&
 	    ar->state != ATH10K_STATE_RESTARTING) {
 		ret = -EINVAL;
-		goto exit;
+		goto out;
 	}
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
 		ath10k_err("Could not init hif: %d\n", ret);
-		ar->state = ATH10K_STATE_OFF;
-		goto exit;
+		goto err_off;
 	}
 
 	ret = ath10k_core_start(ar);
 	if (ret) {
 		ath10k_err("Could not init core: %d\n", ret);
-		ath10k_hif_power_down(ar);
-		ar->state = ATH10K_STATE_OFF;
-		goto exit;
+		goto err_power_down;
 	}
 
 	if (ar->state == ATH10K_STATE_OFF)
@@ -2363,12 +2360,16 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		ar->state = ATH10K_STATE_RESTARTED;
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
-	if (ret)
+	if (ret) {
 		ath10k_warn("failed to enable PMF QOS: %d\n", ret);
+		goto err_core_stop;
+	}
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 1);
-	if (ret)
+	if (ret) {
 		ath10k_warn("failed to enable dynamic BW: %d\n", ret);
+		goto err_core_stop;
+	}
 
 	/*
 	 * By default FW set ARP frames ac to voice (6). In that case ARP
@@ -2384,14 +2385,21 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	if (ret) {
 		ath10k_warn("failed to set arp ac override parameter: %d\n",
 			    ret);
-		goto exit;
+		goto err_core_stop;
 	}
 
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 	ret = 0;
+	goto out;
 
-exit:
+err_core_stop:
+	ath10k_core_stop(ar);
+err_power_down:
+	ath10k_hif_power_down(ar);
+err_off:
+	ar->state = ATH10K_STATE_OFF;
+out:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
 }
-- 
1.8.5.3

