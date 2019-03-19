Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3267C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E0982085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfCSKid (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfCSKic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82F8F309264B;
        Tue, 19 Mar 2019 10:38:32 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BB5518154;
        Tue, 19 Mar 2019 10:38:29 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 11/12] mt76: unify set_tim
Date:   Tue, 19 Mar 2019 11:37:46 +0100
Message-Id: <1552991867-5087-12-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 19 Mar 2019 10:38:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

All mt76 drivers (now also USB drivers) require empty .set_tim
callback. Add it to common mt76 module and use on all drivers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c        | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76.h            | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7603/main.c     | 8 +-------
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      | 9 +--------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c      | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 8 +-------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 1 +
 7 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 47eecb4d4d01..851caabbecda 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -785,3 +785,10 @@ void mt76_csa_check(struct mt76_dev *dev)
 		__mt76_csa_check, dev);
 }
 EXPORT_SYMBOL_GPL(mt76_csa_check);
+
+int
+mt76_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_set_tim);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index edff44f32c8e..c163ba68647e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -732,6 +732,8 @@ int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void mt76_csa_check(struct mt76_dev *dev);
 void mt76_csa_finish(struct mt76_dev *dev);
 
+int mt76_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set);
+
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 7849528db134..a03729824c4d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -664,12 +664,6 @@ static void mt7603_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *cont
 	mt76_tx(&dev->mt76, control->sta, wcid, skb);
 }
 
-static int
-mt7603_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
-{
-	return 0;
-}
-
 const struct ieee80211_ops mt7603_ops = {
 	.tx = mt7603_tx,
 	.start = mt7603_start,
@@ -691,7 +685,7 @@ static void mt7603_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *cont
 	.sta_rate_tbl_update = mt7603_sta_rate_tbl_update,
 	.release_buffered_frames = mt7603_release_buffered_frames,
 	.set_coverage_class = mt7603_set_coverage_class,
-	.set_tim = mt7603_set_tim,
+	.set_tim = mt76_set_tim,
 	.get_survey = mt76_get_survey,
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index e35165416cf0..a7ff7e32b9b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -74,13 +74,6 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
 {
 }
 
-static int
-mt76x0e_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
-		bool set)
-{
-	return 0;
-}
-
 static const struct ieee80211_ops mt76x0e_ops = {
 	.tx = mt76x02_tx,
 	.start = mt76x0e_start,
@@ -101,7 +94,7 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
 	.get_survey = mt76_get_survey,
 	.get_txpower = mt76_get_txpower,
 	.flush = mt76x0e_flush,
-	.set_tim = mt76x0e_set_tim,
+	.set_tim = mt76_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x02_set_coverage_class,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index b9b8a1dafbc9..cf97bbd89485 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -152,6 +152,7 @@ static void mt76x0u_stop(struct ieee80211_hw *hw)
 	.set_rts_threshold = mt76x02_set_rts_threshold,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.get_txpower = mt76_get_txpower,
+	.set_tim = mt76_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 878ce92405ed..16dc8e2451b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -135,12 +135,6 @@
 {
 }
 
-static int
-mt76x2_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
-{
-	return 0;
-}
-
 static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
 			      u32 rx_ant)
 {
@@ -197,7 +191,7 @@ static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x02_set_coverage_class,
 	.get_survey = mt76_get_survey,
-	.set_tim = mt76x2_set_tim,
+	.set_tim = mt76_set_tim,
 	.set_antenna = mt76x2_set_antenna,
 	.get_antenna = mt76x2_get_antenna,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 46c6b3764f5a..eb414fb75fb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -129,5 +129,6 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.get_txpower = mt76_get_txpower,
+	.set_tim = mt76_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
 };
-- 
1.9.3

