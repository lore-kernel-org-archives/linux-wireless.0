Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34974 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbeGPODv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:51 -0400
Received: by mail-pf0-f196.google.com with SMTP id q7-v6so25192705pff.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:23 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 5/6] rsi: fill rx_params only once.
Date: Mon, 16 Jul 2018 19:09:36 +0530
Message-Id: <1531748377-29215-6-git-send-email-siva8118@gmail.com> (sfid-20180716_153636_882273_ECD49187)
In-Reply-To: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amol Hanwate <amol.hanwate@redpinesignals.com>

rx_params are getting updated two times in driver, which is not required.
Hence, removing duplicate updation of rx_params from rsi_prepare_skb().

Signed-off-by: Amol Hanwate <amol.hanwate@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 1485a0c..34a5d9c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -122,7 +122,6 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 				       u8 extended_desc)
 {
 	struct ieee80211_tx_info *info;
-	struct skb_info *rx_params;
 	struct sk_buff *skb = NULL;
 	u8 payload_offset;
 	struct ieee80211_vif *vif;
@@ -149,10 +148,6 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 	vif = rsi_get_vif(common->priv, wh->addr1);
 
 	info = IEEE80211_SKB_CB(skb);
-	rx_params = (struct skb_info *)info->driver_data;
-	rx_params->rssi = rsi_get_rssi(buffer);
-	rx_params->channel = rsi_get_connected_channel(vif);
-
 	return skb;
 }
 
-- 
2.5.5
