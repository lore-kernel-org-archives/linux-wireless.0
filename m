Return-Path: <SRS0=l8p9=6X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E162BC54E4A
	for <linux-wireless@archiver.kernel.org>; Sat,  9 May 2020 21:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DDD2184D
	for <linux-wireless@archiver.kernel.org>; Sat,  9 May 2020 21:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589060326;
	bh=HnUM259Rdf4B4vhAadEviXCVy23QtKBhprmetFaSX88=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=q/C5nrJ9m9ly3DGw1bpGb59FjdvQNwrbngtPzfKnWVli6aSsO/SEIUjruUgCQiiy1
	 2xLUGZ2/ujD4nDqtx5r/e+AFs8A2i6IzhNEXuC7iqdzwu0mLeqoOuUMWqoKrmVUc91
	 GJJ8cPY2jbeOJK8ZVkPgF3fU+f8IuI7KFY1qfTns=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEIViq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 May 2020 17:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgEIVip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 May 2020 17:38:45 -0400
Received: from localhost.localdomain (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936E220722;
        Sat,  9 May 2020 21:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589060325;
        bh=HnUM259Rdf4B4vhAadEviXCVy23QtKBhprmetFaSX88=;
        h=From:To:Cc:Subject:Date:From;
        b=yTmUnVn2Iu6mS1MblWeMqQmSu9qjA3+KV6eTQvI0x0REAdSa0Oat0eMCDhMKmJHm6
         NRZTELG0rApAUh1/WBfEVkrJqaQZ5WDVWmowemckGgjRugdLWv0PylFcC1g5GU8wUz
         RCQ7HzINTqazXxwUT1PxLs8FRumRuT6u6WhG9GQE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH] mt76: mt7663u: add missing register definitions
Date:   Sat,  9 May 2020 23:38:35 +0200
Message-Id: <597208dd2e236e0fb8d0d517bdd304e218ac157a.1589060245.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing PLE/PSE base register definitions for mt7663u

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
index 06235f83f903..01d60c02512e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
@@ -23,6 +23,8 @@ static const u32 mt7663u_reg_map[] = {
 	[MT_CSR_BASE]		= 0x40000000,
 	[MT_EFUSE_ADDR_BASE]	= 0x78011000,
 	[MT_TOP_MISC_BASE]	= 0x81020000,
+	[MT_PLE_BASE]		= 0x82060000,
+	[MT_PSE_BASE]		= 0x82068000,
 	[MT_PHY_BASE]		= 0x82070000,
 	[MT_WTBL_BASE_ADDR]	= 0x820e0000,
 	[MT_CFG_BASE]		= 0x820f0000,
-- 
2.26.2

