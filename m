Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:9712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388254AbeGXMuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 08:50:16 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <wcn36xx@lists.infradead.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] wcn36xx: Use kmemdup instead of duplicating it in wcn36xx_smd_process_ptt_msg_rsp
Date: Tue, 24 Jul 2018 19:43:17 +0800
Message-ID: <20180724114317.18580-1-yuehaibing@huawei.com> (sfid-20180724_134425_760061_A992DCCE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace calls to kmalloc followed by a memcpy with a direct call to
kmemdup.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index b4dadf7..70c97ec 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -792,10 +792,10 @@ static int wcn36xx_smd_process_ptt_msg_rsp(void *buf, size_t len,
 			 rsp->header.len - sizeof(rsp->ptt_msg_resp_status));
 
 	if (rsp->header.len > 0) {
-		*p_ptt_rsp_msg = kmalloc(rsp->header.len, GFP_ATOMIC);
+		*p_ptt_rsp_msg = kmemdup(rsp->ptt_msg, rsp->header.len,
+					 GFP_ATOMIC);
 		if (!*p_ptt_rsp_msg)
 			return -ENOMEM;
-		memcpy(*p_ptt_rsp_msg, rsp->ptt_msg, rsp->header.len);
 	}
 	return ret;
 }
-- 
2.7.0
