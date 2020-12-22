Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0B7C433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Dec 2020 13:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E8EF23124
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Dec 2020 13:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgLVNv4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Dec 2020 08:51:56 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9472 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgLVNv4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Dec 2020 08:51:56 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D0d515ddDzhvQW;
        Tue, 22 Dec 2020 21:50:13 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Tue, 22 Dec 2020 21:50:40 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Markus.Elfring@web.de>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless v3 -next] brcmfmac: Delete useless kfree code
Date:   Tue, 22 Dec 2020 21:51:13 +0800
Message-ID: <20201222135113.20680-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A null pointer will be passed to a kfree() call after a kzalloc() call failed.
This code is useless. Thus delete the extra function call.

A goto statement is also no longer needed. Thus adjust an if branch.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/firmware.c    | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index d821a4758f8c..d40104b8df55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -319,8 +319,10 @@ static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
 	u8 *nvram;
 
 	nvram = kzalloc(nvp->nvram_len + 1 + 3 + sizeof(u32), GFP_KERNEL);
-	if (!nvram)
-		goto fail;
+	if (!nvram) {
+		nvp->nvram_len = 0;
+		return;
+	}
 
 	/* Copy all valid entries, release old nvram and assign new one.
 	 * Valid entries are of type pcie/X/Y/ where X = domain_nr and
@@ -350,10 +352,6 @@ static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
 	kfree(nvp->nvram);
 	nvp->nvram = nvram;
 	nvp->nvram_len = j;
-	return;
-fail:
-	kfree(nvram);
-	nvp->nvram_len = 0;
 }
 
 static void brcmf_fw_add_defaults(struct nvram_parser *nvp)
-- 
2.22.0

