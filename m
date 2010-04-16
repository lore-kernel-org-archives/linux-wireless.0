Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22974 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab0DPGYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:24:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 23:24:41 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19400.641.785333.69038@gargle.gargle.HOWL>
Date: Fri, 16 Apr 2010 11:54:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/10] ath9k_htc: Handle WMI timeouts properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a WMI command has timed out for some reason,
a late WMI response would end up updating the
response region of a new WMI request that has been
issued in the meantime.

Fix this race condition by dropping a WMI response
if a new WMI command has been issued.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/wmi.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 355e0db..afbf63d 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -204,6 +204,14 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 		return;
 	}
 
+	/* Check if there has been a timeout. */
+	spin_lock(&wmi->wmi_lock);
+	if (cmd_id != wmi->last_cmd_id) {
+		spin_unlock(&wmi->wmi_lock);
+		goto free_skb;
+	}
+	spin_unlock(&wmi->wmi_lock);
+
 	/* WMI command response */
 	ath9k_wmi_rsp_callback(wmi, skb);
 
@@ -266,6 +274,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	struct sk_buff *skb;
 	u8 *data;
 	int time_left, ret = 0;
+	unsigned long flags;
 
 	if (!wmi)
 		return -EINVAL;
@@ -297,6 +306,10 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (ret)
 		goto out;
 
+	spin_lock_irqsave(&wmi->wmi_lock, flags);
+	wmi->last_cmd_id = cmd_id;
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
+
 	time_left = wait_for_completion_timeout(&wmi->cmd_wait, timeout);
 	if (!time_left) {
 		ath_print(common, ATH_DBG_WMI,
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index fd8c9c5..6113571 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -97,6 +97,7 @@ struct wmi {
 	enum htc_endpoint_id ctrl_epid;
 	struct mutex op_mutex;
 	struct completion cmd_wait;
+	enum wmi_cmd_id last_cmd_id;
 	u16 tx_seq_id;
 	u8 *cmd_rsp_buf;
 	u32 cmd_rsp_len;
-- 
1.7.0.5

