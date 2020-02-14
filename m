Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAE4C3B1A1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2843F246A1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698018;
	bh=862DG/gC210KrjAvzel6lj6KSc4emG7aRy/vuBz4ldE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tDO7Gc6vg4c58vhxWqmK3joZRIjtlHkK//Lg3ED/eOvFxDd2JTOXXp23UYW3AnUE1
	 8vugrwQo44BAYqPx/msWOUQLfi43uoukY6w+ajI5HFj7S5Enss822R0/DrhjVWJdh7
	 3TlPx7256JEmUPY5QTGvjpRHgRob+XuhSm+S0q+E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393557AbgBNQdh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406092AbgBNQZY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198C5247C6;
        Fri, 14 Feb 2020 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697523;
        bh=862DG/gC210KrjAvzel6lj6KSc4emG7aRy/vuBz4ldE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZVQvlYv6kuMkhIsn/VJuiBj3e8QWUQF7L417HwaPi1wRuKI44hs12H1YCq0j/8tl
         WsdBfCe+o2Gqt51HmGw9Ua1VtqDtfWD0xwUPiv4w+UkgzJ9nk8LvoEHJay+L/Ot61h
         7iXgNF/Ji5mb4tRimSGsTW5ypG6JmtFExTdd9Jss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 047/100] bcma: remove set but not used variable 'sizel'
Date:   Fri, 14 Feb 2020 11:23:31 -0500
Message-Id: <20200214162425.21071-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
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
index df806b9c54908..7c6ce250c497c 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -216,7 +216,7 @@ static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 __iomem **eromptr)
 static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 				  u32 type, u8 port)
 {
-	u32 addrl, addrh, sizel, sizeh = 0;
+	u32 addrl, addrh, sizeh = 0;
 	u32 size;
 
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
@@ -236,12 +236,9 @@ static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 
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

