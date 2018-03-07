Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbeCGNMV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 08:12:21 -0500
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH] ath10k: Advertize beacon_int_min_gcd
Date: Wed,  7 Mar 2018 18:42:36 +0530
Message-Id: <1520428356-2762-1-git-send-email-akolli@codeaurora.org> (sfid-20180307_141224_833492_F494E4C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes regression caused by 0c317a02ca98
("cfg80211: support virtual interfaces with different beacon intervals"),
with this change cfg80211 expects the driver to advertize
'beacon_int_min_gcd' to support different beacon intervals in multivap
scenario. This support is added for, QCA988X/QCA99X0/QCA9984/QCA4019.

Verifed AP + mesh bring up on QCA9984 with beacon interval 100msec and
1000msec respectively.
Frimware: firmware-5.bin_10.4-3.5.3-00053

Fixes: 0c317a02ca98 ("cfg80211: support virtual interfaces with different beacon intervals")
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebb3f1b046f3..9486ef7cc06b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -7874,6 +7875,7 @@ void ath10k_mac_destroy(struct ath10k *ar)
 		.max_interfaces = 8,
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
+		.beacon_int_min_gcd = 1,
 #ifdef CONFIG_ATH10K_DFS_CERTIFIED
 		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20) |
@@ -7997,6 +7999,7 @@ void ath10k_mac_destroy(struct ath10k *ar)
 		.max_interfaces = 16,
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
+		.beacon_int_min_gcd = 1,
 #ifdef CONFIG_ATH10K_DFS_CERTIFIED
 		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20) |
-- 
1.7.9.5
