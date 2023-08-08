Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F16C41513
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Aug 2023 18:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjHHS1U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Aug 2023 14:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbjHHS0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2023 14:26:42 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F0819BE
        for <linux-wireless@vger.kernel.org>; Tue,  8 Aug 2023 10:40:50 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RKm5b1vnhz1hwFd;
        Tue,  8 Aug 2023 16:08:03 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 8 Aug
 2023 16:10:51 +0800
From:   Ruan Jinjie <ruanjinjie@huawei.com>
To:     <briannorris@chromium.org>, <kvalo@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <simon.horman@corigine.com>,
        <linux-wireless@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next RESEND] wifi: mwifiex: use is_zero_ether_addr() instead of ether_addr_equal()
Date:   Tue, 8 Aug 2023 16:10:23 +0800
Message-ID: <20230808081023.2303423-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use is_zero_ether_addr() instead of ether_addr_equal()
to check if the ethernet address is all zeros.

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 644b1e134b01..fb3105a76337 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -828,7 +828,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	u8 ssid_filter;
 	struct mwifiex_ie_types_htcap *ht_cap;
 	struct mwifiex_ie_types_bss_mode *bss_mode;
-	const u8 zero_mac[6] = {0, 0, 0, 0, 0, 0};
 
 	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
 	   in this routine will be preserved since the routine that sends the
@@ -966,7 +965,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				  sizeof(struct mwifiex_ie_types_scan_chan_gap);
 		}
 
-		if (!ether_addr_equal(user_scan_in->random_mac, zero_mac)) {
+		if (!is_zero_ether_addr(user_scan_in->random_mac)) {
 			random_mac_tlv = (void *)tlv_pos;
 			random_mac_tlv->header.type =
 					 cpu_to_le16(TLV_TYPE_RANDOM_MAC);
-- 
2.34.1

