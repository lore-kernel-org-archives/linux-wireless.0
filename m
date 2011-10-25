Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53320 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1JYKiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:38:12 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 3/7] ath6kl: Introduce new variable to track wow state machine
Date: Tue, 25 Oct 2011 16:07:23 +0530
Message-ID: <1319539047-8756-4-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123814_953157_6D9959F4)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

 Add new variable wow_state to maintain the current WOW state machine.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    8 ++++++++
 drivers/net/wireless/ath/ath6kl/init.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 31e5c7e..706443c 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,6 +380,12 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
+enum ath6kl_wow_state {
+	ATH6KL_WOW_STATE_NONE,
+	ATH6KL_WOW_STATE_SUSPENDING,
+	ATH6KL_WOW_STATE_SUSPENDED
+};
+
 /* Flag info */
 #define WMI_ENABLED	0
 #define WMI_READY	1
@@ -517,6 +523,8 @@ struct ath6kl {
 	u16 assoc_bss_beacon_int;
 	u8 assoc_bss_dtim_period;
 
+	enum ath6kl_wow_state wow_state;
+
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
 		struct circ_buf fwlog_buf;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 1700423..6781531 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -594,7 +594,7 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev)
 	set_bit(WLAN_ENABLED, &ar->flag);
 
 	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
-
+	ar->wow_state = ATH6KL_WOW_STATE_NONE;
 	spin_lock_init(&ar->lock);
 
 	ath6kl_init_control_info(ar);
-- 
1.7.0.4

