Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F45FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C542171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbfB1IEl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:04:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730263AbfB1IEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:04:41 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FFF330B9F4E;
        Thu, 28 Feb 2019 08:04:41 +0000 (UTC)
Received: from localhost (unknown [10.40.205.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C36617B66;
        Thu, 28 Feb 2019 08:04:37 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 12/12] mt76x02: remove set_tim
Date:   Thu, 28 Feb 2019 09:03:33 +0100
Message-Id: <1551341013-24519-13-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 28 Feb 2019 08:04:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

set_tim callback is not used by mac80211 if AP_LINK_PS hw flag is set.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      | 8 --------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 7 -------
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index fafe57653ac0..68d44929dafa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -74,13 +74,6 @@ mt76x0e_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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
@@ -101,7 +94,6 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.get_survey = mt76_get_survey,
 	.get_txpower = mt76_get_txpower,
 	.flush = mt76x0e_flush,
-	.set_tim = mt76x0e_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x02_set_coverage_class,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 878ce92405ed..f45847f48920 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -135,12 +135,6 @@ mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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
@@ -197,7 +191,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x02_set_coverage_class,
 	.get_survey = mt76_get_survey,
-	.set_tim = mt76x2_set_tim,
 	.set_antenna = mt76x2_set_antenna,
 	.get_antenna = mt76x2_get_antenna,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
-- 
2.20.1

