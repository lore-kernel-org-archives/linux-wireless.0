Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BC5C33CAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 17:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE364246B9
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 17:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579196757;
	bh=JYnzlzmlOi8zxfkZ3gNkyag99DW/iJIorNEPxenw/wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VTiFwwQ+DORxihvgdtpqZqNxeJw9LndarE6ky4tpK49j0WpBHJin5pCDIBZycVmdg
	 VbmydisYMu+HzqWXT5DSzRglR7l73HDB5S3EDhaVGjOLqtScfJYHXuyGJbyzuRpJx6
	 Iz7TIJCCDvZPRkE6swCYihp6efPlS9sJUIYnzc6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406567AbgAPRp5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406558AbgAPRp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83147246B9;
        Thu, 16 Jan 2020 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196756;
        bh=JYnzlzmlOi8zxfkZ3gNkyag99DW/iJIorNEPxenw/wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcZZKOAmn2QhOAkbRTas0K1XfUQkyADmngnefqoG54B9mAPg7ox2EsbEUjCYSvxjZ
         meSP+YXAlLTX4KLJB5woVh4o8ao+LQLy4SOaRxMefJVYTRPlZajlzswa2TthZv3HJH
         u/aEtLf6UXCYhyV/6XCTZsPQeUNoBZXeW7lMwiCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 131/174] bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
Date:   Thu, 16 Jan 2020 12:42:08 -0500
Message-Id: <20200116174251.24326-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 420c20be08a4597404d272ae9793b642401146eb ]

An earlier commit re-worked the setting of the bitmask and is now
assigning v with some bit flags rather than bitwise or-ing them
into v, consequently the earlier bit-settings of v are being lost.
Fix this by replacing an assignment with the bitwise or instead.

Addresses-Coverity: ("Unused value")
Fixes: 2be25cac8402 ("bcma: add constants for PCI and use them")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bcma/driver_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index f499a469e66d..12b2cc9a3fbe 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -78,7 +78,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u16 device, u8 address)
 		v |= (address << BCMA_CORE_PCI_MDIODATA_REGADDR_SHF_OLD);
 	}
 
-	v = BCMA_CORE_PCI_MDIODATA_START;
+	v |= BCMA_CORE_PCI_MDIODATA_START;
 	v |= BCMA_CORE_PCI_MDIODATA_READ;
 	v |= BCMA_CORE_PCI_MDIODATA_TA;
 
@@ -121,7 +121,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u16 device,
 		v |= (address << BCMA_CORE_PCI_MDIODATA_REGADDR_SHF_OLD);
 	}
 
-	v = BCMA_CORE_PCI_MDIODATA_START;
+	v |= BCMA_CORE_PCI_MDIODATA_START;
 	v |= BCMA_CORE_PCI_MDIODATA_WRITE;
 	v |= BCMA_CORE_PCI_MDIODATA_TA;
 	v |= data;
-- 
2.20.1

