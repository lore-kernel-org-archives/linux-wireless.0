Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49988 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbcEIXL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:27 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 11/21] ath10k: add fw-powerup-fail to ethtool stats.
Date: Mon,  9 May 2016 16:11:05 -0700
Message-Id: <1462835475-11079-12-git-send-email-greearb@candelatech.com> (sfid-20160510_011144_367602_503750E1)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This gives user-space a normal-ish way to detect that
firmware has failed to start and that a reboot is
probably required.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 1 +
 drivers/net/wireless/ath/ath10k/debug.c | 2 ++
 drivers/net/wireless/ath/ath10k/pci.c   | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6aa7a14..e7c228a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -698,6 +698,7 @@ struct ath10k {
 
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
+	bool fw_powerup_failed; /* If true, might take reboot to recover. */
 	u32 chip_id;
 	u32 target_version;
 	u8 fw_version_major;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 7d9ad99..54a2194 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1487,6 +1487,7 @@ static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"d_fw_crash_count",
 	"d_fw_warm_reset_count",
 	"d_fw_cold_reset_count",
+	"d_fw_powerup_failed", /* boolean */
 };
 
 #define ATH10K_SSTATS_LEN ARRAY_SIZE(ath10k_gstrings_stats)
@@ -1586,6 +1587,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 	data[i++] = ar->stats.fw_crash_counter;
 	data[i++] = ar->stats.fw_warm_reset_counter;
 	data[i++] = ar->stats.fw_cold_reset_counter;
+	data[i++] = ar->fw_powerup_failed;
 
 	spin_unlock_bh(&ar->data_lock);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index dbf0db8..2adc459 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2709,10 +2709,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		goto err_ce;
 	}
 
+	ar->fw_powerup_failed = false;
 	return 0;
 
 err_ce:
 	ath10k_pci_ce_deinit(ar);
+	ar->fw_powerup_failed = true;
 
 err_sleep:
 	return ret;
-- 
2.4.3

