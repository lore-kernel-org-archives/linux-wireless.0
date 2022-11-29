Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB08C4167B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Nov 2022 09:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiK2Jrk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Nov 2022 04:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiK2Jri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2022 04:47:38 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0DA116F;
        Tue, 29 Nov 2022 01:47:35 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NLyCy2ZNBzmWGd;
        Tue, 29 Nov 2022 17:46:54 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 17:47:33 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <aspriel@gmail.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <arend@broadcom.com>, Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH] wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
Date:   Tue, 29 Nov 2022 18:07:38 +0800
Message-ID: <1669716458-15327-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix to return a negative error code -EINVAL instead of 0.

Compile tested only.

Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 465d95d..329ec8ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3414,6 +3414,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	/* Take arm out of reset */
 	if (!brcmf_chip_set_active(bus->ci, rstvec)) {
 		brcmf_err("error getting out of ARM core reset\n");
+		bcmerror = -EINVAL;
 		goto err;
 	}
 
-- 
1.8.3.1

