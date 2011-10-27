Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:48955 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1J0PsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:48:11 -0400
Subject: [PATCH 02/10] ath6kl: rename ath6kl_wmi_qos_state_init() to
	_wmi_reset()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:48:00 +0300
Message-ID: <20111027154800.23519.20467.stgit@localhost6.localdomain6> (sfid-20111027_174813_361285_1C001466)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to make it more clear that this function is supposed to
reset wmi related variables.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    7 ++-----
 drivers/net/wireless/ath/ath6kl/wmi.h |    1 +
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index e6b0960..3921c2c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3201,11 +3201,8 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	return ret;
 }
 
-static void ath6kl_wmi_qos_state_init(struct wmi *wmi)
+void ath6kl_wmi_reset(struct wmi *wmi)
 {
-	if (!wmi)
-		return;
-
 	spin_lock_bh(&wmi->lock);
 
 	wmi->fat_pipe_exist = 0;
@@ -3228,7 +3225,7 @@ void *ath6kl_wmi_init(struct ath6kl *dev)
 
 	wmi->pwr_mode = REC_POWER;
 
-	ath6kl_wmi_qos_state_init(wmi);
+	ath6kl_wmi_reset(wmi);
 
 	return wmi;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9055c75..ae514cb 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2316,5 +2316,6 @@ int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
 void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
+void ath6kl_wmi_reset(struct wmi *wmi);
 
 #endif /* WMI_H */

