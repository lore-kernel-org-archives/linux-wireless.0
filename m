Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ECCC47089
	for <linux-wireless@archiver.kernel.org>; Thu, 27 May 2021 11:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00996113B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 May 2021 11:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhE0LhK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 May 2021 07:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhE0LhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 May 2021 07:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D85F60FF3;
        Thu, 27 May 2021 11:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622115337;
        bh=DxWixa23gF+anpep3fB68ODBXVgwdF9MBay2tRZmV1w=;
        h=From:To:Cc:Subject:Date:From;
        b=qkbR+xqtUcDFjSERe47KzxiCqw651TOL8/IEJLeiFJ+tYpARyalTyRKFDBsSUfFz+
         zrVf1H83h5dRXTtvlYe6H/huyXU/e8h80ngjdgqgUFUA91IbquhP3ShRvtBSLCAKCF
         rCfu23Af8M/k/QY09j5nJ6fPe4hNlHSaXBTgTRkh81DGxDkDeLzKyPWyu2cOdTFTYx
         kbv9Y6adeGUQBaDyRkgFR6nAfjoGu7+y+vhI120f2r4c07aN6gFcIMvkRY3R9/Y/ud
         EXdQvy0YxAGGsNVXIDlepSNjbo3VZfP08MO2VffwMLkaPdRJsEFvsBQvXhU7O16EPR
         3XLmA0AHFqgeQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        shayne.chen@mediatek.com, ryder.lee@mediatek.com
Subject: [PATCH 0/3] mt76 testmode fixes
Date:   Thu, 27 May 2021 13:35:27 +0200
Message-Id: <cover.1622115194.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix an undefined behaviour and a memory leak in mt76 testmode code

Lorenzo Bianconi (3):
  mt76: testmode: fix memory leak in mt76_testmode_alloc_skb
  mt76: testmode: remove unnecessary function calls in
    mt76_testmode_free_skb
  mt76: testmode: remove undefined behaviour in mt76_testmode_alloc_skb

 drivers/net/wireless/mediatek/mt76/testmode.c | 24 ++++++-------------
 1 file changed, 7 insertions(+), 17 deletions(-)

-- 
2.31.1

