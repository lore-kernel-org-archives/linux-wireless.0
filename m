Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51143 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaIWVSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:18:10 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 07/10] ath10k: add fw-powerup-fail to ethtool stats.
Date: Tue, 23 Sep 2014 14:17:22 -0700
Message-Id: <1411507045-18973-7-git-send-email-greearb@candelatech.com> (sfid-20140923_231821_130778_ED4E2BC2)
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This gives user-space a normal-ish way to detect that
firmware has failed to start and that a reboot is
probably required.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  New patch for this series, goes well with the other
   ethtool patch.

 drivers/net/wireless/ath/ath10k/core.h  |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c |  2 ++
 drivers/net/wireless/ath/ath10k/pci.c   | 12 +++++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7b220b1..601d573 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -399,7 +399,7 @@ struct ath10k {
 	struct ieee80211_hw *hw;
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
-
+	bool fw_powerup_failed; /* If true, might take reboot to recover. */
 	u32 chip_id;
 	u32 target_version;
 	u8 fw_version_major;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index af1ca3e..77b60f4 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1091,6 +1091,7 @@ static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"d_fw_crash_count",
 	"d_fw_warm_reset_count",
 	"d_fw_cold_reset_count",
+	"d_fw_powerup_failed", /* boolean */
 };
 #define ATH10K_SSTATS_LEN ARRAY_SIZE(ath10k_gstrings_stats)
 
@@ -1175,6 +1176,7 @@ void ath10k_get_et_stats(struct ieee80211_hw *hw,
 	data[i++] = ar->fw_crash_counter;
 	data[i++] = ar->fw_warm_reset_counter;
 	data[i++] = ar->fw_cold_reset_counter;
+	data[i++] = ar->fw_powerup_failed;
 
 	spin_unlock_bh(&ar->data_lock);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 38f7386..ebe2ee1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1851,7 +1851,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 			    ret);
 
 		if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY)
-			return ret;
+			goto out;
 
 		ath10k_warn(ar, "trying cold reset\n");
 
@@ -1859,11 +1859,17 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		if (ret) {
 			ath10k_err(ar, "failed to power up target using cold reset too (%d)\n",
 				   ret);
-			return ret;
+			goto out;
 		}
 	}
 
-	return 0;
+out:
+	/* If we have failed to power-up, it may take a reboot to
+	 * get the NIC back online.
+	 * Set flag accordinly so that user-space can know.
+	 */
+	ar->fw_powerup_failed = !!ret;
+	return ret;
 }
 
 static void ath10k_pci_hif_power_down(struct ath10k *ar)
-- 
1.7.11.7

