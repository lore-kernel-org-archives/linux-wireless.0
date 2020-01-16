Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEFAC33CB3
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61762214AF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579197727;
	bh=uCIp6mD10XteebAJ2I2AXoP9KgVklKyDJoPbZYmlV6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p1XiW5qTbydpLQTWWwbBxoirxxxNlQbsZ1BLBDt1NWpLkoNSZbkbvGtSE9mTqwW4l
	 DKyKRPvcLv/MiljWkTSdoOlmoKqTu55FPYZiufFA1XGvbmkfjwF45DZUQOaxokagpz
	 +WbryOvOMQyFO+7EetKl3vk/eFlmLdixqZc7Jt6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405625AbgAPRlS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388438AbgAPRlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:41:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB202467C;
        Thu, 16 Jan 2020 17:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196476;
        bh=uCIp6mD10XteebAJ2I2AXoP9KgVklKyDJoPbZYmlV6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0l4BfVvRGzZLA6Cp597VU4/vUFgtFonh9FF0XvAtC9o7ZfTSDAi/5eg5q2KzMxTI
         5m9PUQ/OPw+uF6ahLrnWw+/hLM4asMkKHsCoR8/+/SVFbW9PXjFeoF8lp5nnGOGiOy
         hsxYif7O34qtmDdeeBs2UfSjJwvMXD/rehJFKgr4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 224/251] mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
Date:   Thu, 16 Jan 2020 12:36:13 -0500
Message-Id: <20200116173641.22137-184-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 15e14f76f85f4f0eab3b8146e1cd3c58ce272823 ]

Fix bbp ready check in mt7601u_wait_bbp_ready. The issue is reported by
coverity with the following error:

Logical vs. bitwise operator
The expression's value does not depend on the operands; inadvertent use
of the wrong operator is a likely logic error.

Addresses-Coverity-ID: 1309441 ("Logical vs. bitwise operator")
Fixes: c869f77d6abb ("add mt7601u driver")
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index ca09a5d4305e..71a47459bf8a 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -221,7 +221,7 @@ int mt7601u_wait_bbp_ready(struct mt7601u_dev *dev)
 
 	do {
 		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
-		if (val && ~val)
+		if (val && val != 0xff)
 			break;
 	} while (--i);
 
-- 
2.20.1

