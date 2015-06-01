Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8917 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbFAJYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 05:24:21 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: free wmi mgmt event skb when parsing fails
Date: Mon, 1 Jun 2015 14:53:33 +0530
Message-ID: <1433150613-5662-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150601_112424_960752_A9701D3D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wmi mgmt event function fails to parse given skb,
it should be freed on failure condition to avoid memory
leaks. Found this during the code review.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b892eb8..818bd25 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2089,6 +2089,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	ret = ath10k_wmi_pull_mgmt_rx(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse mgmt rx event: %d\n", ret);
+		dev_kfree_skb(skb);
 		return ret;
 	}
 
-- 
1.7.10.4

