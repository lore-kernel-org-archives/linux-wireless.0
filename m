Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaIJNft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:49 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 20/22] wil6210: rename [en|dis]able irq to [un]mask
Date: Wed, 10 Sep 2014 16:34:49 +0300
Message-ID: <1410356091-19219-21-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153553_708408_597E8E27)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To better reflect real action performed, rename:
s/wil6210_disable_irq/wil_mask_irq/
s/wil6210_enable_irq/wil_unmask_irq/

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 6 +++---
 drivers/net/wireless/ath/wil6210/main.c      | 4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h   | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 7d319d9..d265e7c 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -135,7 +135,7 @@ static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
 		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
 }
 
-void wil6210_disable_irq(struct wil6210_priv *wil)
+void wil_mask_irq(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
 
@@ -145,7 +145,7 @@ void wil6210_disable_irq(struct wil6210_priv *wil)
 	wil6210_mask_irq_pseudo(wil);
 }
 
-void wil6210_enable_irq(struct wil6210_priv *wil)
+void wil_unmask_irq(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
 
@@ -546,7 +546,7 @@ void wil6210_fini_irq(struct wil6210_priv *wil, int irq)
 {
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	wil6210_disable_irq(wil);
+	wil_mask_irq(wil);
 	free_irq(irq, wil);
 	if (wil->n_msi == 3) {
 		free_irq(irq + 1, wil);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0857853..8443d82 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -496,7 +496,7 @@ int wil_reset(struct wil6210_priv *wil)
 		wil->scan_request = NULL;
 	}
 
-	wil6210_disable_irq(wil);
+	wil_mask_irq(wil);
 
 	wmi_event_flush(wil);
 
@@ -539,7 +539,7 @@ int wil_reset(struct wil6210_priv *wil)
 	reinit_completion(&wil->wmi_ready);
 	reinit_completion(&wil->wmi_call);
 
-	wil6210_enable_irq(wil);
+	wil_unmask_irq(wil);
 
 	/* we just started MAC, wait for FW ready */
 	rc = wil_wait_for_fw_ready(wil);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f8f9988..a540781 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -532,8 +532,8 @@ int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason);
 void wil6210_clear_irq(struct wil6210_priv *wil);
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
-void wil6210_disable_irq(struct wil6210_priv *wil);
-void wil6210_enable_irq(struct wil6210_priv *wil);
+void wil_mask_irq(struct wil6210_priv *wil);
+void wil_unmask_irq(struct wil6210_priv *wil);
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
-- 
1.9.1

