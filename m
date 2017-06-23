Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32841 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754080AbdFWOLG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:11:06 -0400
Received: by mail-pf0-f196.google.com with SMTP id w12so7547662pfk.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:11:06 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 15/17] rsi: Remove internal header from Tx status skb
Date: Fri, 23 Jun 2017 19:37:34 +0530
Message-Id: <1498226856-6305-16-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161116_922764_5F317217)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Device specific descriptor for each TX packet is prepared on top of
skb data address. This descriptor should be pulled out before
indicating the TX status to mac80211.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 021e5ac..36303ae 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -229,12 +229,20 @@ void rsi_indicate_tx_status(struct rsi_hw *adapter,
 			    int status)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct skb_info *tx_params;
 
-	memset(info->driver_data, 0, IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
+	if (!adapter->hw) {
+		rsi_dbg(ERR_ZONE, "##### No MAC #####\n");
+		return;
+	}
 
 	if (!status)
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
+	tx_params = (struct skb_info *)info->driver_data;
+	skb_pull(skb, tx_params->internal_hdr_size);
+	memset(info->driver_data, 0, IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
+
 	ieee80211_tx_status_irqsafe(adapter->hw, skb);
 }
 
-- 
2.7.4
