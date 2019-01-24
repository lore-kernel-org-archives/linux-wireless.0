Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635ACC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3539A21872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfAXPoj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:44:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfAXPoj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 10:44:39 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B75B75A1FB;
        Thu, 24 Jan 2019 15:44:38 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5C6F10021B1;
        Thu, 24 Jan 2019 15:44:33 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 7/7] mt76x02: enable support for IBSS, AP and MESH
Date:   Thu, 24 Jan 2019 16:44:09 +0100
Message-Id: <1548344649-10404-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 24 Jan 2019 15:44:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we implement beconing on USB now, similar interfaces should be
supported for USB as are for MMIO. Tested only for AP and IBSS modes.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 8732e07c01ad..3880caa0c64a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -150,16 +150,6 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 		mt76x02_dfs_init_detector(dev);
 
 		wiphy->reg_notifier = mt76x02_regd_notifier;
-		wiphy->iface_combinations = mt76x02_if_comb;
-		wiphy->n_iface_combinations = ARRAY_SIZE(mt76x02_if_comb);
-		wiphy->interface_modes =
-			BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-			BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-			BIT(NL80211_IFTYPE_ADHOC);
-
 		wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
@@ -172,6 +162,16 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 		}
 	}
 
+	wiphy->iface_combinations = mt76x02_if_comb;
+	wiphy->n_iface_combinations = ARRAY_SIZE(mt76x02_if_comb);
+	wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+			BIT(NL80211_IFTYPE_ADHOC);
+
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
-- 
1.9.3

