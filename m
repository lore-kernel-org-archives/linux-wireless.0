Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69851C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44BE9207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbfA3QCe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:02:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbfA3QCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:02:34 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1826E3DBD2;
        Wed, 30 Jan 2019 16:02:34 +0000 (UTC)
Received: from localhost (ovpn-204-66.brq.redhat.com [10.40.204.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 986315D6A6;
        Wed, 30 Jan 2019 16:02:33 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 7/7] mt76x02: enable support for IBSS and MESH
Date:   Wed, 30 Jan 2019 17:02:19 +0100
Message-Id: <1548864139-27729-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
References: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 30 Jan 2019 16:02:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we implement beconing on USB now, similar interfaces should be
supported for USB as are for MMIO. Tested only on IBSS mode and
AP mode (not enabled due to lack of PS buffering).

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v3: enable only IBSS and MESH, do not change iface_combinations

 .../net/wireless/mediatek/mt76/mt76x02_util.c | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 724b13d91898..87ed00768bc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -140,10 +140,16 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 	hw->max_rate_tries = 1;
 	hw->extra_tx_headroom = 2;
 
+	wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+#ifdef CONFIG_MAC80211_MESH
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	if (mt76_is_usb(dev)) {
 		hw->extra_tx_headroom += sizeof(struct mt76x02_txwi) +
 					 MT_DMA_HDR_LEN;
-		wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	} else {
 		INIT_DELAYED_WORK(&dev->wdt_work, mt76x02_wdt_work);
 
@@ -152,18 +158,9 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 		wiphy->reg_notifier = mt76x02_regd_notifier;
 		wiphy->iface_combinations = mt76x02_if_comb;
 		wiphy->n_iface_combinations = ARRAY_SIZE(mt76x02_if_comb);
-		wiphy->interface_modes =
-			BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-			BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-			BIT(NL80211_IFTYPE_ADHOC);
-
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
 		wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
-		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
-
 		/* init led callbacks */
 		if (IS_ENABLED(CONFIG_MT76_LEDS)) {
 			dev->mt76.led_cdev.brightness_set =
@@ -172,6 +169,8 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 		}
 	}
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
-- 
2.19.2

