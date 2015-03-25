Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34622 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbCYIRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 04:17:30 -0400
Received: by lagg8 with SMTP id g8so13509903lag.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2015 01:17:29 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: disable burst mode
Date: Wed, 25 Mar 2015 09:14:51 +0100
Message-Id: <1427271291-31683-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150325_091738_052457_595C8CBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmwares that indicate BURST_SERVICE as enabled
could overwrite some wmm parameters (eg. txop).
This could lead IOT and balancing issues.
Hence disable this by default.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 75dcd3a..b0d550b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3079,6 +3079,7 @@ static int ath10k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 static int ath10k_start(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
+	u32 burst_enable;
 	int ret = 0;
 
 	/*
@@ -3133,6 +3134,15 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	if (test_bit(WMI_SERVICE_BURST, ar->wmi.svc_map)) {
+		burst_enable = ar->wmi.pdev_param->burst_enable;
+		ret = ath10k_wmi_pdev_set_param(ar, burst_enable, 0);
+		if (ret) {
+			ath10k_warn(ar, "failed to disable burst: %d\n", ret);
+			goto err_core_stop;
+		}
+	}
+
 	if (ar->cfg_tx_chainmask)
 		__ath10k_set_antenna(ar, ar->cfg_tx_chainmask,
 				     ar->cfg_rx_chainmask);
-- 
1.9.1

