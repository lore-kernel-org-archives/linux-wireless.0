Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0818AC2BA83
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 17:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E7B222C4
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581701645;
	bh=3gwgFUqvJ8N/VlvUVeaLWqEWpiO5LJUZARXPEDPwzPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mBpmbxiaPwKICKGO+3H8Q0U9Ifv9GnhwstUuTBQMesXNZZcRhbFC45A2QBOddkkLh
	 qjmGpZ2lq8S+S/wYHPMH4S4oRTT23DyMl9qBPcjF7ygeUdOZgyDg5OweujwA0lQA/5
	 vfmRzLusYSA+XmQ9sBuKH2pI8sZlpYyOmhJDrLEo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390865AbgBNReC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390349AbgBNQGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 686D0206D7;
        Fri, 14 Feb 2020 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696373;
        bh=3gwgFUqvJ8N/VlvUVeaLWqEWpiO5LJUZARXPEDPwzPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Au94Gvp/99kComdz1wDTto/2QUYOB1VX9439vRvMDJDWl2Jvxcplk1dCSsxl/0MRi
         zJk0sbydqC92lw8rnZCEOjW3X9QadvdwrJiIfOlM/Zpa1oPyeC0cV69mZGvCeP9qE0
         ml48EfoT3nINsah1wIH+LhoakEZzTAeemknbf2wI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 202/459] bcma: remove set but not used variable 'sizel'
Date:   Fri, 14 Feb 2020 10:57:32 -0500
Message-Id: <20200214160149.11681-202-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit f427939391f290cbeabe0231eb8a116429d823f0 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/bcma/scan.c: In function ‘bcma_erom_get_addr_desc’:

drivers/bcma/scan.c:222:20: warning: variable ‘sizel’ set but
not used [-Wunused-but-set-variable]

It is never used, and so can be removed.

Fixes: 8369ae33b705 ("bcma: add Broadcom specific AMBA bus driver")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bcma/scan.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 4a2d1b235fb5a..1f2de714b4017 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -219,7 +219,7 @@ static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 __iomem **eromptr)
 static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 				  u32 type, u8 port)
 {
-	u32 addrl, addrh, sizel, sizeh = 0;
+	u32 addrl, addrh, sizeh = 0;
 	u32 size;
 
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
@@ -239,12 +239,9 @@ static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 
 	if ((ent & SCAN_ADDR_SZ) == SCAN_ADDR_SZ_SZD) {
 		size = bcma_erom_get_ent(bus, eromptr);
-		sizel = size & SCAN_SIZE_SZ;
 		if (size & SCAN_SIZE_SG32)
 			sizeh = bcma_erom_get_ent(bus, eromptr);
-	} else
-		sizel = SCAN_ADDR_SZ_BASE <<
-				((ent & SCAN_ADDR_SZ) >> SCAN_ADDR_SZ_SHIFT);
+	}
 
 	return addrl;
 }
-- 
2.20.1

