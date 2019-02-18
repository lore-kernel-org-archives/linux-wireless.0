Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08564C10F02
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 07:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D871D217F5
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 07:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfBRHzJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 02:55:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40738 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728541AbfBRHzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 02:55:09 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 65A681D1827D531F9626;
        Mon, 18 Feb 2019 15:55:06 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 15:54:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH] brcmfmac: remove set but not used variable 'old_state'
Date:   Mon, 18 Feb 2019 08:08:46 +0000
Message-ID: <20190218080846.187942-1-yuehaibing@huawei.com>
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

drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function 'brcmf_usb_state_change':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:578:6: warning:
 variable 'old_state' set but not used [-Wunused-but-set-variable]

It's never used and can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 76cfaf6999c8..398536b30b7a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -575,7 +575,6 @@ static void
 brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 {
 	struct brcmf_bus *bcmf_bus = devinfo->bus_pub.bus;
-	int old_state;
 
 	brcmf_dbg(USB, "Enter, current state=%d, new state=%d\n",
 		  devinfo->bus_pub.state, state);
@@ -583,7 +582,6 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 	if (devinfo->bus_pub.state == state)
 		return;
 
-	old_state = devinfo->bus_pub.state;
 	devinfo->bus_pub.state = state;
 
 	/* update state of upper layer */



