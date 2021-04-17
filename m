Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEE9C433B4
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Apr 2021 10:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB91C610C8
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Apr 2021 10:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhDQK1q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Apr 2021 06:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhDQK1l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Apr 2021 06:27:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD3060FE9;
        Sat, 17 Apr 2021 10:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618655234;
        bh=JV7GinMEQHcf5xq8a1NY7/FY5uSrO+fxXWtf4fL5cJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=o3sDaRmp7blP2EHN6bcCpYImSo7ctYymuS7cNXVNosMHwM9nyF4VWOmhZR93uIvAB
         Sd7BocDQ3tHqXegHmWMyw3QJXU4844hFTjmkCHcAOTIOpj8J5BkodsCf8nIDiFXfba
         iCYfHxLLewsryP5Wd4/GLbeKTRCPg6bt8D43PUQQutDQz4+lSGRJ1dVmfa/wCXtSw+
         DWDopaCLv+OzRvrrpj35q+9ZFL806FcjpfFvSlSo7zNFjjd/bbwb+yLIjUxB9YJsLp
         VvAT8sXOPmULZZS1tL2LqXs/J7ZmhL2ecJ+r/wA8KNu0hTbLy9s61Y+DS/vX2QjQZ4
         kMab+hitYKS+w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: mt7921: do not use 0 as NULL pointer
Date:   Sat, 17 Apr 2021 12:27:06 +0200
Message-Id: <9348612b6ebb5079760d5a4a168f633327d93fc6.1618655197.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the following sparse warning:
drivers/net/wireless/mediatek/mt76/mt7921/mac.c:1425:70:
  warning: Using plain integer as NULL pointer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 572bab82315a..d77f11d103a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1416,7 +1416,7 @@ void mt7921_mac_reset_work(struct work_struct *work)
 	ieee80211_wake_queues(hw);
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_vif_connect_iter, 0);
+					    mt7921_vif_connect_iter, NULL);
 }
 
 void mt7921_reset(struct mt76_dev *mdev)
-- 
2.30.2

