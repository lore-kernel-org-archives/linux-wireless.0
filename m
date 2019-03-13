Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4A9C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 13:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B995120657
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 13:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfCMNen (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 09:34:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58963 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfCMNen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 09:34:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA45D80E7B;
        Wed, 13 Mar 2019 13:34:43 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5D69605A8;
        Wed, 13 Mar 2019 13:34:40 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC] mt76: add 3dBm for reporting txpower also for 1x1
Date:   Wed, 13 Mar 2019 14:34:21 +0100
Message-Id: <1552484061-4647-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 13 Mar 2019 13:34:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It's not clear for my why we should add 3dBm for 2x2 devices
and not for 1x1. 3dBm looks rater like minimal txpower and
hardware transmit at 3dBm + dev->txpower_cur / 2 .

With the change reported txpower value are closer to regulatory
values, but honestly I have no idea what should be reported.

Perhaps also some better comment should be added.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 851caabbecda..b04652729112 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -733,15 +733,9 @@ int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     int *dbm)
 {
 	struct mt76_dev *dev = hw->priv;
-	int n_chains = hweight8(dev->antenna_mask);
 
 	*dbm = dev->txpower_cur / 2;
-
-	/* convert from per-chain power to combined
-	 * output on 2x2 devices
-	 */
-	if (n_chains > 1)
-		*dbm += 3;
+	*dbm += 3;
 
 	return 0;
 }
-- 
1.9.3

