Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37735 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3JWLFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 07:05:25 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so336416eak.18
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 04:05:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: respect power_level values
Date: Wed, 23 Oct 2013 04:02:15 -0700
Message-Id: <1382526135-3215-4-git-send-email-michal.kazior@tieto.com> (sfid-20131023_130530_549577_2DD09D3A)
In-Reply-To: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
References: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows txpower limits other than regulatory
to be applied (e.g. user txpower limit provided
via iw/nl80211).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1d91201..643518d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2013,6 +2013,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath10k *ar = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 	int ret = 0;
+	u32 param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2024,6 +2025,25 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_unlock_bh(&ar->data_lock);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac config power %d\n",
+			   hw->conf.power_level);
+
+		param = ar->wmi.pdev_param->txpower_limit2g;
+		ret = ath10k_wmi_pdev_set_param(ar, param,
+						hw->conf.power_level * 2);
+		if (ret)
+			ath10k_warn("mac failed to set 2g txpower %d (%d)\n",
+				    hw->conf.power_level, ret);
+
+		param = ar->wmi.pdev_param->txpower_limit5g;
+		ret = ath10k_wmi_pdev_set_param(ar, param,
+						hw->conf.power_level * 2);
+		if (ret)
+			ath10k_warn("mac failed to set 5g txpower %d (%d)\n",
+				    hw->conf.power_level, ret);
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_PS)
 		ath10k_config_ps(ar);
 
-- 
1.8.4.rc3

