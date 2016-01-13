Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26900 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcAMPsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:48:31 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 6/7] ath10k: Enable periodic peer stats update
Date: Wed, 13 Jan 2016 21:16:33 +0530
Message-ID: <1452699994-5078-7-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164835_961644_CBC0C13D)
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Register for 500ms as periodic peer stats update period,
and parameters like rx_duration that needs to be tracked
in host can be achieved by this provision, also periodic
stats update is the future of fw_stats and shall be extended
for pdev / vdev stats irrespecitive PEER_STATS service is enabled
or not

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2dba57c..fd4b4df 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4103,6 +4103,18 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	ar->ani_enabled = true;
 
+	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
+		param = ar->wmi.pdev_param->peer_stats_update_period;
+		ret = ath10k_wmi_pdev_set_param(ar, param,
+					PEER_DEFAULT_STATS_UPDATE_PERIOD);
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to set peer stats period : %d\n",
+				    ret);
+			goto err_core_stop;
+		}
+	}
+
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 
-- 
1.7.9.5

