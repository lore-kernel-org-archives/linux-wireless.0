Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4E7C4167B
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Sep 2021 16:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1749D610E6
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Sep 2021 16:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhINQoX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Sep 2021 12:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhINQoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Sep 2021 12:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 657D260FD7;
        Tue, 14 Sep 2021 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631637784;
        bh=lWvDjlvmEl4yBD0aljtG/+BcG4nHwNUOy7Klw8GehW0=;
        h=From:To:Cc:Subject:Date:From;
        b=V+kUaNHqfVbwjX3YQVeb3LVttxBnkMCVKMns8MWGqONvz/YJqemuCWvL2clC5xdIh
         R+g+c07G8VMLDgjYMw7IKov9YsEHPU41Kglx0JRGuZ81CBapOrooKWE1sDhXLrOMwe
         AqnX4Rr888VouGTG3q/BbJmSq6W5LwLe0o4vqkN04EJ5KoS4RnS0x+ikilhGG6TuKk
         fSgTzyguBihWTHaJ2uQ2alXhJdtM87xNBgRZOG80ypKM7MYe9dCtkzdoYKx8GeypPo
         XpZqa76toOznRkxU8dtFWq/5IzvAg/pYHEmgipU5iMWubcfEUDgzh4VyYdLjJQpwxA
         ewC0xBlPLgiXQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com
Subject: [PATCH] mt76: mt7915: fix possible infinite loop release semaphore
Date:   Tue, 14 Sep 2021 18:42:51 +0200
Message-Id: <1e170ef07c19a4df305004aeac3da237ef085de2.1631637656.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix possible infinite loop in mt7915_load_patch if
mt7915_mcu_patch_sem_ctrl always returns an error.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 263a99d0b723..cd2d7629714b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2712,7 +2712,7 @@ static int mt7915_load_patch(struct mt7915_dev *dev)
 	default:
 		ret = -EAGAIN;
 		dev_err(dev->mt76.dev, "Failed to release patch semaphore\n");
-		goto out;
+		break;
 	}
 	release_firmware(fw);
 
-- 
2.31.1

