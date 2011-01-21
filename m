Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUDBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:01:31 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1249489iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:01:31 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63197.462196.80033@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:30:45 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 11/33] ath9k_htc: Fix WMI and beacon header
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Match the beacon header with that of the firmware.
Also, the firmware reports the TSF for an SWBA, so
store it.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    2 +-
 drivers/net/wireless/ath/ath9k/wmi.c |    7 ++++++-
 drivers/net/wireless/ath/ath9k/wmi.h |    6 ++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 87e2d41..6a09ad4 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -95,8 +95,8 @@ struct tx_mgmt_hdr {
 } __packed;
 
 struct tx_beacon_header {
-	u8 len_changed;
 	u8 vif_index;
+	u8 len_changed;
 	u16 rev;
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index dc862f5..8ed6fe6 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -158,6 +158,7 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	struct wmi_cmd_hdr *hdr;
 	u16 cmd_id;
 	void *wmi_event;
+	struct wmi_event_swba *swba;
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	__be32 txrate;
 #endif
@@ -172,7 +173,11 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 		switch (cmd_id) {
 		case WMI_SWBA_EVENTID:
-			wmi->beacon_pending = *(u8 *)wmi_event;
+			swba = (struct wmi_event_swba *) wmi_event;
+
+			wmi->tsf = be64_to_cpu(swba->tsf);
+			wmi->beacon_pending = swba->beacon_pending;
+
 			tasklet_schedule(&wmi->drv_priv->swba_tasklet);
 			break;
 		case WMI_FATAL_EVENTID:
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 4208427..24f16fa 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -31,6 +31,11 @@ struct wmi_cmd_hdr {
 	__be16 seq_no;
 } __packed;
 
+struct wmi_event_swba {
+	__be64 tsf;
+	u8 beacon_pending;
+};
+
 enum wmi_cmd_id {
 	WMI_ECHO_CMDID = 0x0001,
 	WMI_ACCESS_MEMORY_CMDID,
@@ -100,6 +105,7 @@ struct wmi {
 	u32 cmd_rsp_len;
 	bool stopped;
 
+	u64 tsf;
 	u8 beacon_pending;
 	spinlock_t wmi_lock;
 
-- 
1.7.3.5

