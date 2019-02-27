Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F0CC10F0B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 02:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 571C0218E0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 02:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfB0CKh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 21:10:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:46422 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729527AbfB0CKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 21:10:37 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DBBA423C17601977DFCD;
        Wed, 27 Feb 2019 10:10:34 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.408.0; Wed, 27 Feb 2019 10:10:27 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8192se: Remove set but not used variable 'seg_ptr'
Date:   Wed, 27 Feb 2019 02:23:47 +0000
Message-ID: <20190227022347.7927-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c: In function '_rtl92s_firmware_downloadcode':
drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c:139:17: warning:
 variable 'seg_ptr' set but not used [-Wunused-but-set-variable]

It's not used after commit 59ae1d127ac0 ("networking: introduce and use
skb_put_data()")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
index faa307a0b148..541b7881735e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
@@ -136,7 +136,6 @@ static bool _rtl92s_firmware_downloadcode(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct sk_buff *skb;
 	struct rtl_tcb_desc *tcb_desc;
-	unsigned char *seg_ptr;
 	u16 frag_threshold = MAX_FIRMWARE_CODE_SIZE;
 	u16 frag_length, frag_offset = 0;
 	u16 extra_descoffset = 0;
@@ -166,9 +165,8 @@ static bool _rtl92s_firmware_downloadcode(struct ieee80211_hw *hw,
 		if (!skb)
 			return false;
 		skb_reserve(skb, extra_descoffset);
-		seg_ptr = skb_put_data(skb,
-				       code_virtual_address + frag_offset,
-				       (u32)(frag_length - extra_descoffset));
+		skb_put_data(skb, code_virtual_address + frag_offset,
+			     (u32)(frag_length - extra_descoffset));
 
 		tcb_desc = (struct rtl_tcb_desc *)(skb->cb);
 		tcb_desc->queue_index = TXCMD_QUEUE;



