Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbeDQMHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 08:07:37 -0400
From: pillair@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 4/4] ath10k: Enable sta idle power save
Date: Tue, 17 Apr 2018 17:37:01 +0530
Message-Id: <1523966821-21903-5-git-send-email-pillair@codeaurora.org> (sfid-20180417_140742_170932_152C8BEB)
In-Reply-To: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Govind Singh <govinds@codeaurora.org>

Enable sta power save in fw for the targets that
supports idle power save. The idle ps enable command
will be ignored by the firmware which does not support
this feature.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7e02ca02b28e..1d9222af1bb2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4679,6 +4679,13 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		}
 	}
 
+	param = ar->wmi.pdev_param->idle_ps_config;
+	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
+	if (ret && ret != -EOPNOTSUPP) {
+		ath10k_warn(ar, "failed to enable idle_ps_config: %d\n", ret);
+		goto err_core_stop;
+	}
+
 	__ath10k_set_antenna(ar, ar->cfg_tx_chainmask, ar->cfg_rx_chainmask);
 
 	/*
-- 
2.14.1
