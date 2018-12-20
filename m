Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE23C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA604217D4
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbeLTLrP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 06:47:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbeLTLrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 06:47:14 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D7179FDDB;
        Thu, 20 Dec 2018 11:47:14 +0000 (UTC)
Received: from localhost (unknown [10.40.205.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7917C604FF;
        Thu, 20 Dec 2018 11:47:08 +0000 (UTC)
Date:   Thu, 20 Dec 2018 12:47:07 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sid Hayn <sidhayn@gmail.com>
Subject: [PATCH 4.19] mt76x0: mark 802.11w as supported
Message-ID: <20181220114701.GA8660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 20 Dec 2018 11:47:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit 0ae976a11b4fb5704b597e103b5189237641c1a1 upstream.

This is one line hw feature backport from 0ae976a11b4f ("mt76x0: init
hw capabilities"), which add also other different features, however
those are not supported in 4.19.

802.11w is supported by mac80211 and mt76x0u driver in 4.19 correctly
fall-back to software encryption when 802.11w ciphers are used.

Without the patch we fail to associate with WPA3 APs, so this is
considered as fix.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[remove marking non-working features on 4.19, make topic correspond the change]
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 7cdb3e740522..0a3e046d78db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -681,6 +681,7 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
-- 
2.7.5

