Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56771 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaE1HvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 03:51:17 -0400
Subject: [PATCH] ath10k: remove unused len variables from wmi process rx
 functions
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 May 2014 10:41:10 +0300
Message-ID: <20140528074110.8437.58039.stgit@potku.adurom.net> (sfid-20140528_095120_974120_D4915094)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These len variables are not used anywhere.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 921d18d599fc..0646203f7518 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2105,7 +2105,6 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_event_id id;
-	u16 len;
 
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
@@ -2113,8 +2112,6 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		return;
 
-	len = skb->len;
-
 	trace_ath10k_wmi_event(id, skb->data, skb->len);
 
 	switch (id) {
@@ -2224,7 +2221,6 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10x_event_id id;
-	u16 len;
 
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
@@ -2232,8 +2228,6 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		return;
 
-	len = skb->len;
-
 	trace_ath10k_wmi_event(id, skb->data, skb->len);
 
 	switch (id) {

