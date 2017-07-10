Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33885 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753061AbdGJMo1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:44:27 -0400
Received: by mail-pg0-f67.google.com with SMTP id j186so12598576pge.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:44:26 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 02/17] rsi: immediate wakeup bit and priority for TX command packets
Date: Mon, 10 Jul 2017 18:10:33 +0530
Message-Id: <1499690448-9956-3-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144533_073907_37B6BA5E)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

For all TX command packets immediate wakeup bit needs to be
set in descriptor. This will make sure device will wakeup if it
is in any sleep state. Priority of the packet is also set.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 3 +++
 drivers/net/wireless/rsi/rsi_mgmt.h     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index ebd1e56..68771b0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -266,11 +266,14 @@ static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
 					struct sk_buff *skb)
 {
 	struct skb_info *tx_params;
+	struct rsi_cmd_desc *desc;
 
 	if (skb == NULL) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
 		return -ENOMEM;
 	}
+	desc->desc_dword0.len_qno |= cpu_to_le16(DESC_IMMEDIATE_WAKEUP);
+	skb->priority = MGMT_SOFT_Q;
 	tx_params = (struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
 	tx_params->flags |= INTERNAL_MGMT_PKT;
 	skb_queue_tail(&common->tx_queue[MGMT_SOFT_Q], skb);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 63360c2..6f7f181 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -229,6 +229,7 @@ struct rsi_mac_frame {
 #define EOSP_INDICATION			BIT(5)
 #define REQUIRE_TSF_SYNC_CONFIRM	BIT(6)
 #define ENCAP_MGMT_PKT			BIT(7)
+#define DESC_IMMEDIATE_WAKEUP		BIT(15)
 
 struct rsi_cmd_desc_dword0 {
 	__le16 len_qno;
-- 
2.7.4
