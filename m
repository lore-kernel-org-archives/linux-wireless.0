Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD80BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B742E2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfCSKie (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfCSKie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 717F0F74B6;
        Tue, 19 Mar 2019 10:38:34 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 931325C25A;
        Tue, 19 Mar 2019 10:38:33 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 12/12] mt76x02: enable AP mode for USB
Date:   Tue, 19 Mar 2019 11:37:47 +0100
Message-Id: <1552991867-5087-13-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 19 Mar 2019 10:38:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable AP mode. For now without multi-vif support, this will require
more testing and investigation.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index ed6463c9166e..284dae65cdf1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -142,6 +142,7 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 
 	wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_AP) |
 #ifdef CONFIG_MAC80211_MESH
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 #endif
@@ -158,7 +159,6 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 		wiphy->reg_notifier = mt76x02_regd_notifier;
 		wiphy->iface_combinations = mt76x02_if_comb;
 		wiphy->n_iface_combinations = ARRAY_SIZE(mt76x02_if_comb);
-		wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
 		wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 		/* init led callbacks */
-- 
1.9.3

