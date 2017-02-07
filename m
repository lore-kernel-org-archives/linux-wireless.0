Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34396 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752404AbdBGWa0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 17:30:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ath10k: select WANT_DEV_COREDUMP
Date: Tue,  7 Feb 2017 23:29:33 +0100
Message-Id: <20170207222933.12701-1-johannes@sipsolutions.net> (sfid-20170207_233234_963526_A0F33D2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is necessary so that - if ath10k is the only driver using
dev_coredump*() - the functionality is built into the kernel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index db1ca629cbd6..b4241cf9b7ed 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -3,6 +3,7 @@ config ATH10K
         depends on MAC80211 && HAS_DMA
 	select ATH_COMMON
 	select CRC32
+	select WANT_DEV_COREDUMP
         ---help---
           This module adds support for wireless adapters based on
           Atheros IEEE 802.11ac family of chipsets.
-- 
2.9.3
