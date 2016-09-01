Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28829 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933169AbcIAQMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 12:12:43 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Remove unnecessary error code assignment
Date: Thu, 1 Sep 2016 21:43:36 +0530
Message-ID: <1472746416-23869-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160901_181252_778544_8D287080)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

The error assigned does not seems to be used anywhere,
fixes nothing just a small cleanup

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index eb2831c..3117a71 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3544,7 +3544,6 @@ void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 				ath10k_warn(ar, "failed to map beacon: %d\n",
 					    ret);
 				dev_kfree_skb_any(bcn);
-				ret = -EIO;
 				goto skip;
 			}
 
-- 
1.9.1
