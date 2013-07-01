Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44743 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3GAJeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 05:34:07 -0400
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Huawei Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] mwifiex: add tx info to skb when forming mgmt frame
Date: Mon,  1 Jul 2013 17:33:50 +0800
Message-Id: <1372671230-8733-1-git-send-email-harvey.huawei.yang@gmail.com> (sfid-20130701_113424_546447_D4E7949E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Huawei Yang <harvey.huawei.yang@gmail.com>

In function 'mwifiex_write_data_complete' it need tx info to find the mwifiex_private to updates statistics and wake up tx queues. Or we may trigger tx queues timeout when transmitting lots of mgmt frames burstly.

Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e42b266..e8655f9 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -166,6 +166,10 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 	memcpy(skb_put(skb, len - sizeof(struct ieee80211_hdr_3addr)),
 	       buf + sizeof(struct ieee80211_hdr_3addr),
 	       len - sizeof(struct ieee80211_hdr_3addr));
+	
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_num = priv->bss_num;
+	tx_info->bss_type = priv->bss_type;
 
 	skb->priority = LOW_PRIO_TID;
 	do_gettimeofday(&tv);
-- 
1.7.10.4

