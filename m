Return-Path: <SRS0=efDY=C3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A16C43463
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 02:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF0A23444
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 02:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397618;
	bh=gpve+ix1TNFA73P/2Os4vBWUlyekpeWuT9lTKuaZeNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NQnQmx+yuwuoTl/Ga6f35i9+qCI7QBmst+K5SaT0S19/TRPatAmzd1HR5p7Uo1MkQ
	 xPaEHyvvckYBns63fChdeQJRHl5OYfvVUwFIGb/5WQ5GxVExcFQtLT3oxW6dgcD0dj
	 6KhLPkcEODCtxfL0j9z4r6pJPuosTRoR4luZZ16Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgIRCxN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbgIRCHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28697238E3;
        Fri, 18 Sep 2020 02:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394873;
        bh=gpve+ix1TNFA73P/2Os4vBWUlyekpeWuT9lTKuaZeNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXCyT0ldKmK4JesZf39P1yxMpT5fZLUYqb4OO4jw8/al0uMttGe2TeP3BfqPMjV+a
         +BNoip66qIcuNB+pfQ3Nl4qqrCFDFIr/0HzCB6JOOSse5kavivrGf2RLe9GQ+X9YZT
         gdbm2HVkrX4r7eKzvtN8T2/FRsI0C34EFLDTGjMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 324/330] mt76: fix LED link time failure
Date:   Thu, 17 Sep 2020 22:01:04 -0400
Message-Id: <20200918020110.2063155-324-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d68f4e43a46ff1f772ff73085f96d44eb4163e9d ]

The mt76_led_cleanup() function is called unconditionally, which
leads to a link error when CONFIG_LEDS is a loadable module or
disabled but mt76 is built-in:

drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_unregister_device':
mac80211.c:(.text+0x2ac): undefined reference to `led_classdev_unregister'

Use the same trick that is guarding the registration, using an
IS_ENABLED() check for the CONFIG_MT76_LEDS symbol that indicates
whether LEDs can be used or not.

Fixes: 36f7e2b2bb1d ("mt76: do not use devm API for led classdev")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 7be5806a1c398..8bd191347b9fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -368,7 +368,8 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
-	mt76_led_cleanup(dev);
+	if (IS_ENABLED(CONFIG_MT76_LEDS))
+		mt76_led_cleanup(dev);
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
 }
-- 
2.25.1

