Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FC1C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF272075B
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfCDJsw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 04:48:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32087 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfCDJsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 04:48:52 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAA838830B;
        Mon,  4 Mar 2019 09:48:52 +0000 (UTC)
Received: from localhost (unknown [10.40.205.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64A201001943;
        Mon,  4 Mar 2019 09:48:49 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 07/11] mt76x02: disable HW encryption for group frames
Date:   Mon,  4 Mar 2019 10:48:12 +0100
Message-Id: <1551692896-7062-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 04 Mar 2019 09:48:52 +0000 (UTC)
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is required to sent multicast/broadcast frames in USB AP
mode just after beacon.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 84484ca1f6a4..38997076cb03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -424,6 +424,16 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
 
+	/*
+	 * In USB AP mode, broadcast/multicast frames are setup in beacon
+	 * data registers and sent via HW beacons engine, they require to
+	 * be already encrypted.
+	 */
+	if (mt76_is_usb(dev) &&
+	    vif->type == NL80211_IFTYPE_AP &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
 	msta = sta ? (struct mt76x02_sta *) sta->drv_priv : NULL;
 	wcid = msta ? &msta->wcid : &mvif->group_wcid;
 
-- 
2.20.1

