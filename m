Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f199.google.com ([209.85.223.199]:36343 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0DSPpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 11:45:05 -0400
Received: by iwn37 with SMTP id 37so546319iwn.15
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 08:45:04 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ath9k-htc: speedup disconnect handling
Date: Mon, 19 Apr 2010 23:44:43 +0800
Message-Id: <1271691883-13133-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

This patch detects the disconnect in wmi register write path,
then speedup the disconnect handling.
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 ++
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/wmi.c |    8 ++++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9aa40df..bcc48ff 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -111,6 +111,8 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 	BUG_ON(timeout < AH_TIME_QUANTUM);
 
 	for (i = 0; i < (timeout / AH_TIME_QUANTUM); i++) {
+		if (AR_SREV_9271(ah) && ah->htc_disconnected)
+			break;
 		if ((REG_READ(ah, reg) & mask) == val)
 			return true;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8158e8e..6b22158 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -635,6 +635,7 @@ struct ath_hw {
 	u32 ah_flags;
 
 	bool htc_reset_init;
+	bool htc_disconnected;
 
 	enum nl80211_iftype opmode;
 	enum ath9k_power_mode power_mode;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index dc6c6fc..fbd44c7 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -279,6 +279,9 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!wmi)
 		return -EINVAL;
 
+	if (ah->htc_disconnected)
+		return -ENODEV;
+
 	skb = alloc_skb(headroom + cmd_len, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
@@ -324,6 +327,11 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	return 0;
 
 out:
+	if (ret == -ENODEV) {
+		ah->htc_disconnected = 1;
+		ath_print(common, ATH_DBG_WMI,"HTC disconnected!\n");
+	}
+
 	ath_print(common, ATH_DBG_WMI,
 		  "WMI failure for: %s\n", wmi_cmd_to_name(cmd_id));
 	mutex_unlock(&wmi->op_mutex);
-- 
1.6.2.5

