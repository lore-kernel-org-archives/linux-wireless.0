Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1HVPKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 11:10:19 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 2/3] ath6kl: Add wmi meta data information only it is available
Date: Mon, 22 Aug 2011 20:40:21 +0530
Message-ID: <1314025822-8004-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110822_171022_901347_BC56ADF1)
In-Reply-To: <1314025822-8004-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314025822-8004-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 13b1a20..d116d0e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -167,9 +167,11 @@ int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 	if (WARN_ON(skb == NULL))
 		return -EINVAL;
 
-	ret = ath6kl_wmi_meta_add(wmi, skb, &meta_ver, tx_meta_info);
-	if (ret)
-		return ret;
+	if (tx_meta_info) {
+		ret = ath6kl_wmi_meta_add(wmi, skb, &meta_ver, tx_meta_info);
+		if (ret)
+			return ret;
+	}
 
 	skb_push(skb, sizeof(struct wmi_data_hdr));
 
-- 
1.7.0.4

