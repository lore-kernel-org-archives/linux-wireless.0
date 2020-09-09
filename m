Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798ABC10DAA
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 15:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3276A2078E
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 15:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgIIPss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:48:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40364 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730460AbgIIPsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 11:48:47 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 57B99F08137A5C2B9BFE;
        Wed,  9 Sep 2020 21:45:42 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:45:35 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath11k: Remove unused inline function htt_htt_stats_debug_dump()
Date:   Wed, 9 Sep 2020 21:45:33 +0800
Message-ID: <20200909134533.19604-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no caller in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../net/wireless/ath/ath11k/debug_htt_stats.c | 44 -------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug_htt_stats.c b/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
index 6b532dc99c98..ad3f08a5b031 100644
--- a/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
+++ b/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
@@ -3895,50 +3895,6 @@ static inline void htt_print_backpressure_stats_tlv_v(const u32 *tag_buf,
 	}
 }
 
-static inline void htt_htt_stats_debug_dump(const u32 *tag_buf,
-					    struct debug_htt_stats_req *stats_req)
-{
-	u8 *buf = stats_req->buf;
-	u32 len = stats_req->buf_len;
-	u32 buf_len = ATH11K_HTT_STATS_BUF_SIZE;
-	u32 tlv_len = 0, i = 0, word_len = 0;
-
-	tlv_len  = FIELD_GET(HTT_TLV_LEN, *tag_buf) + HTT_TLV_HDR_LEN;
-	word_len = (tlv_len % 4) == 0 ? (tlv_len / 4) : ((tlv_len / 4) + 1);
-	len += HTT_DBG_OUT(buf + len, buf_len - len,
-			   "============================================");
-	len += HTT_DBG_OUT(buf + len, buf_len - len,
-			   "HKDBG TLV DUMP: (tag_len=%u bytes, words=%u)",
-			   tlv_len, word_len);
-
-	for (i = 0; i + 3 < word_len; i += 4) {
-		len += HTT_DBG_OUT(buf + len, buf_len - len,
-				   "0x%08x 0x%08x 0x%08x 0x%08x",
-				   tag_buf[i], tag_buf[i + 1],
-				   tag_buf[i + 2], tag_buf[i + 3]);
-	}
-
-	if (i + 3 == word_len) {
-		len += HTT_DBG_OUT(buf + len, buf_len - len, "0x%08x 0x%08x 0x%08x ",
-				tag_buf[i], tag_buf[i + 1], tag_buf[i + 2]);
-	} else if (i + 2 == word_len) {
-		len += HTT_DBG_OUT(buf + len, buf_len - len, "0x%08x 0x%08x ",
-				tag_buf[i], tag_buf[i + 1]);
-	} else if (i + 1 == word_len) {
-		len += HTT_DBG_OUT(buf + len, buf_len - len, "0x%08x ",
-				tag_buf[i]);
-	}
-	len += HTT_DBG_OUT(buf + len, buf_len - len,
-			   "============================================");
-
-	if (len >= buf_len)
-		buf[buf_len - 1] = 0;
-	else
-		buf[len] = 0;
-
-	stats_req->buf_len = len;
-}
-
 static int ath11k_dbg_htt_ext_stats_parse(struct ath11k_base *ab,
 					  u16 tag, u16 len, const void *tag_buf,
 					  void *user_data)
-- 
2.17.1


