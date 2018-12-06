Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3C1C04EB9
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 11:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D317C20878
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 11:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D317C20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbeLFL6H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 06:58:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:37481 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727832AbeLFL6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 06:58:07 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3100692C5E72A;
        Thu,  6 Dec 2018 19:58:02 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.408.0; Thu, 6 Dec 2018 19:57:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tzu-En Huang <tehuang@realtek.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8821ae: remove set but not used variable 'type' in translate_rx_signal_stuff
Date:   Thu, 6 Dec 2018 12:06:08 +0000
Message-ID: <1544097968-68563-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c: In function 'translate_rx_signal_stuff':
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c:309:6: warning:
 variable 'type' set but not used [-Wunused-but-set-variable]

It never used since commit 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from
staging to regular tree")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index b01c3c5..0f2b7c6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -306,14 +306,12 @@ static void translate_rx_signal_stuff(struct ieee80211_hw *hw,
 	u8 *praddr;
 	u8 *psaddr;
 	__le16 fc;
-	u16 type;
 	bool packet_matchbssid, packet_toself, packet_beacon;
 
 	tmp_buf = skb->data + pstatus->rx_drvinfo_size + pstatus->rx_bufshift;
 
 	hdr = (struct ieee80211_hdr *)tmp_buf;
 	fc = hdr->frame_control;
-	type = WLAN_FC_GET_TYPE(hdr->frame_control);
 	praddr = hdr->addr1;
 	psaddr = ieee80211_get_SA(hdr);
 	ether_addr_copy(pstatus->psaddr, psaddr);



