Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7191C3A5A5
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 16:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 712172339D
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528576;
	bh=jsNo2JAtwLO5t8pQDhbmm0cWLOVY3Kf9g8u0X5fQFxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Adq6SU7Nnbu0Vv1avQ73nH/GHMXqA7EANvGE1Gc3XBfizwV1mxBDGxdpl25a4DSiO
	 RbUAXO+XUGdjH9lvy7IA0RvyEyWd+Am9B35CHy2U0EHQQEZqhyspS+4svYCVnKwZQ1
	 BiozuxU1BZ97mRWeMTCYUwruqF70vKER7/kK1m5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbfICQ12 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730435AbfICQ10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0800238D0;
        Tue,  3 Sep 2019 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528045;
        bh=jsNo2JAtwLO5t8pQDhbmm0cWLOVY3Kf9g8u0X5fQFxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ4TzqjvCH5uSy+yH+F8qU8tUoSiWk1csju1R6EAe+Yqqoj+JEhHMDu0qbbwBrNOy
         un9/6bm/Kku14QmjqCM6L1evoR5aRLfGMXEQnMIcSxEqaoCG+mm7cBJ4JXY3Qq3537
         4+qIn7tqCgkLaVTQZKlPegFnoJ1WRMghsDSd1Mvc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 069/167] mt76: fix corrupted software generated tx CCMP PN
Date:   Tue,  3 Sep 2019 12:23:41 -0400
Message-Id: <20190903162519.7136-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 906d2d3f874a54183df5a609fda180adf0462428 ]

Since ccmp_pn is u8 *, the second half needs to start at array index 4
instead of 0. Fixes a connection stall after a certain amount of traffic

Fixes: 23405236460b9 ("mt76: fix transmission of encrypted management frames")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 6542644bc3259..cec31f0c3017b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -402,7 +402,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 		ccmp_pn[6] = pn >> 32;
 		ccmp_pn[7] = pn >> 40;
 		txwi->iv = *((__le32 *)&ccmp_pn[0]);
-		txwi->eiv = *((__le32 *)&ccmp_pn[1]);
+		txwi->eiv = *((__le32 *)&ccmp_pn[4]);
 	}
 
 	spin_lock_bh(&dev->mt76.lock);
-- 
2.20.1

