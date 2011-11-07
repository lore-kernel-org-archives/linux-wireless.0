Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10363 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:27:23 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 05/11] ath6kl: Add new state for WOW mode
Date: Mon, 7 Nov 2011 10:55:41 +0530
Message-ID: <1320643547-3578-6-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062727_182190_F2364AAA)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to existing deep sleep and cut pwr mode, new state
is added in ath6kl_cfg_suspend_mode as well as in ath6kl_state for WOW.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index b4781e5..59fa9d8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -20,6 +20,7 @@
 enum ath6kl_cfg_suspend_mode {
 	ATH6KL_CFG_SUSPEND_DEEPSLEEP,
 	ATH6KL_CFG_SUSPEND_CUTPOWER,
+	ATH6KL_CFG_SUSPEND_WOW
 };
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b6442c1..9e8b8e3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -459,6 +459,7 @@ enum ath6kl_state {
 	ATH6KL_STATE_ON,
 	ATH6KL_STATE_DEEPSLEEP,
 	ATH6KL_STATE_CUTPOWER,
+	ATH6KL_STATE_WOW,
 };
 
 struct ath6kl {
-- 
1.7.1

