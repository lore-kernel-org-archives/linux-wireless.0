Return-Path: <SRS0=eW0r=7W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E40C433E0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6956820775
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591661653;
	bh=Ie2mvIvkGQbdrF3H2i6PnpLXDR6Dmda2raGGfUvNt4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=EUrFqb/YN/oDgTxZSRWU8EQZlP/8gT/yQDOeeHv1JZCrGBEbRMRKXf9el+4Dhkg02
	 XikDckUP11Ii+xTpPFH8DT3xk710OlkoiT06He/S92ypggWPAv8ZOz5BdaQyCoxdY2
	 lC1QNYA0zTM5979ud8tGT4wjVHB+r7lGwzySYCV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731486AbgFIANy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgFHXTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C9ED20814;
        Mon,  8 Jun 2020 23:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658361;
        bh=Ie2mvIvkGQbdrF3H2i6PnpLXDR6Dmda2raGGfUvNt4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpdsd84WAkctOlcNkZ4HyjuQKc19aPqKhDgktnld/SRfLuimP8rP6ghA/KZbSi2IE
         UwMphn9BmKhq8kk6VcQFwZRcSyO8coEOw3U2lqA4f4gOIoVGPohBBK/1OFKzy8rTk1
         B+q9eFRtycm3RRwjbeXngfgoDmie6b8Tcp4JlH1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 026/175] rtw88: fix an issue about leak system resources
Date:   Mon,  8 Jun 2020 19:16:19 -0400
Message-Id: <20200608231848.3366970-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit 191f6b08bfef24e1a9641eaac96ed030a7be4599 ]

the related system resources were not released when pci_iomap() return
error in the rtw_pci_io_mapping() function. add pci_release_regions() to
fix it.

Fixes: e3037485c68ec1a ("rtw88: new Realtek 802.11ac driver")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200504083442.3033-1-zhengdejin5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 77a2bdee50fa..4a43c4fa716d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -974,6 +974,7 @@ static int rtw_pci_io_mapping(struct rtw_dev *rtwdev,
 	len = pci_resource_len(pdev, bar_id);
 	rtwpci->mmap = pci_iomap(pdev, bar_id, len);
 	if (!rtwpci->mmap) {
+		pci_release_regions(pdev);
 		rtw_err(rtwdev, "failed to map pci memory\n");
 		return -ENOMEM;
 	}
-- 
2.25.1

