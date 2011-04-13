Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48067 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1DMFuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:50:35 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so274186iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:50:35 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14907.856518.900271@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:22:59 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 04/40] ath9k_htc: Fix WMI and beacon header
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
index 9544cd7..cf7909e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -96,8 +96,8 @@ struct tx_mgmt_hdr {
 } __packed;
 
 struct tx_beacon_header {
-	u8 len_changed;
 	u8 vif_index;
+	u8 len_changed;
 	u16 rev;
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 267a98f..96171a2 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -156,6 +156,7 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	struct wmi_cmd_hdr *hdr;
 	u16 cmd_id;
 	void *wmi_event;
+	struct wmi_event_swba *swba;
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	__be32 txrate;
 #endif
@@ -170,7 +171,11 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
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
index 6a36572..2fa91a9 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -36,6 +36,11 @@ struct wmi_fw_version {
 	__be16 minor;
 
 } __packed;
+
+struct wmi_event_swba {
+	__be64 tsf;
+	u8 beacon_pending;
+};
 enum wmi_cmd_id {
 	WMI_ECHO_CMDID = 0x0001,
 	WMI_ACCESS_MEMORY_CMDID,
@@ -106,6 +111,7 @@ struct wmi {
 	u32 cmd_rsp_len;
 	bool stopped;
 
+	u64 tsf;
 	u8 beacon_pending;
 	spinlock_t wmi_lock;
 
-- 
1.7.4.4

