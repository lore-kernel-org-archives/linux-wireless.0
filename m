Return-Path: <SRS0=XJ3z=YQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EE8CA9EBA
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Oct 2019 07:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E02B2084C
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Oct 2019 07:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390039AbfJWHyA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Oct 2019 03:54:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727574AbfJWHyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Oct 2019 03:54:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6EB3E66DC43364274BBD;
        Wed, 23 Oct 2019 15:53:58 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 23 Oct 2019
 15:53:48 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <Jes.Sorensen@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtl8xxxu: remove set but not used variable 'rate_mask'
Date:   Wed, 23 Oct 2019 15:53:42 +0800
Message-ID: <20191023075342.26656-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4484:6:
 warning: variable rate_mask set but not used [-Wunused-but-set-variable]

It is never used since commit a9bb0b515778 ("rtl8xxxu: Improve
TX performance of RTL8723BU on rtl8xxxu driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 1e3b716..3843d7a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4481,11 +4481,6 @@ static u16
 rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
 {
 	u16 network_type = WIRELESS_MODE_UNKNOWN;
-	u32 rate_mask;
-
-	rate_mask = (sta->supp_rates[0] & 0xfff) |
-		    (sta->ht_cap.mcs.rx_mask[0] << 12) |
-		    (sta->ht_cap.mcs.rx_mask[0] << 20);
 
 	if (hw->conf.chandef.chan->band == NL80211_BAND_5GHZ) {
 		if (sta->vht_cap.vht_supported)
-- 
2.7.4


