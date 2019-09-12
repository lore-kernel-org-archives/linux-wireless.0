Return-Path: <SRS0=PXnU=XH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3F4C4CEC6
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 16:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C09220830
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 16:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733277AbfILQow (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Sep 2019 12:44:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52378 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbfILQow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Sep 2019 12:44:52 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EDD97724A098D8E9CEE;
        Fri, 13 Sep 2019 00:44:40 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Sep 2019 00:44:33 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] wireless: Remove unneeded variable
Date:   Fri, 13 Sep 2019 00:41:29 +0800
Message-ID: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With the help of Coccinelle, I find some place to use redundant
variable to store the return value, It is unnecessary. Just remove
it and make the funtion to be void.

zhong jiang (3):
  brcmsmac: Remove unneeded variable and make function to be void
  wlegacy: Remove unneeded variable and make function to be void
  libertas: Remove unneeded variable and make function to be void

 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 5 +----
 drivers/net/wireless/intel/iwlegacy/4965-mac.c          | 8 ++------
 drivers/net/wireless/marvell/libertas/cmd.h             | 2 +-
 drivers/net/wireless/marvell/libertas/cmdresp.c         | 5 +----
 4 files changed, 5 insertions(+), 15 deletions(-)

-- 
1.7.12.4

