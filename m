Return-Path: <SRS0=CTeQ=C4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B091C43463
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Sep 2020 02:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5FD207D3
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Sep 2020 02:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgISCHm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Sep 2020 22:07:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54446 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISCHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Sep 2020 22:07:41 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 66475C1F8229E992EFC4;
        Sat, 19 Sep 2020 10:07:39 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 19 Sep 2020 10:07:38 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] brcmfmac: check return value of driver_for_each_device()
Date:   Sat, 19 Sep 2020 10:06:31 +0800
Message-ID: <1600481191-14250-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1576:6: warning:
 variable 'ret' set but not used [-Wunused-but-set-variable]
  1576 |  int ret;
       |      ^~~

driver_for_each_device() has been declared with __must_check, so the
return value should be checked.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
v2:
- cc linux-wireless
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index ac54638..6f67fef 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1578,6 +1578,9 @@ void brcmf_usb_exit(void)
 	brcmf_dbg(USB, "Enter\n");
 	ret = driver_for_each_device(drv, NULL, NULL,
 				     brcmf_usb_reset_device);
+	if (ret)
+		brcmf_err("failed to reset all usb devices %d\n", ret);
+
 	usb_deregister(&brcmf_usbdrvr);
 }
 
-- 
2.9.5

