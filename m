Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35618 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab1CGCMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:12:47 -0500
Received: by yia27 with SMTP id 27so1454482yia.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:12:46 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16149.848229.154397@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:42:37 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 01/34] ath9k_htc: Fix WMI and beacon header
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
index 753a245..8a598c6 100644
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
index d3d2490..5c36c66 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -154,6 +154,7 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	struct wmi_cmd_hdr *hdr;
 	u16 cmd_id;
 	void *wmi_event;
+	struct wmi_event_swba *swba;
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	__be32 txrate;
 #endif
@@ -168,7 +169,11 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
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
1.7.4.1

