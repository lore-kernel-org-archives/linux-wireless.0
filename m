Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51995 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1KRKFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 05:05:45 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath6kl: Find ar->max_norm_iface in firmware IE parsing
Date: Fri, 18 Nov 2011 10:05:27 +0530
Message-ID: <1321590928-11646-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111118_110550_179036_92D5E11C)
In-Reply-To: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the max number of vifs which can be used for non-p2p
mode is determined in ath6kl_core_alloc(). But the maximum
supported vifs are parsed from firmware IE in ath6kl_fetch_fw_api2()
which would happen after ath6kl_core_alloc().

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ------
 drivers/net/wireless/ath/ath6kl/init.c     |    3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index afa7279..1fb45cc 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2458,12 +2458,6 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 
 	ar->vif_max = 1;
 
-	if (!ar->p2p)
-		ar->max_norm_iface = 2;
-	else
-		ar->max_norm_iface = 1;
-
-	/* FIXME: Remove this once the multivif support is enabled */
 	ar->max_norm_iface = 1;
 
 	spin_lock_init(&ar->lock);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6c4f6a9..48544ed 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -971,6 +971,9 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			ar->vif_max = min_t(unsigned int, le32_to_cpup(val),
 					    ATH6KL_VIF_MAX);
 
+			if (ar->vif_max > 1 && !ar->p2p)
+				ar->max_norm_iface = 2;
+
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
 				   "found vif max ie %d\n", ar->vif_max);
 			break;
-- 
1.7.0.4

