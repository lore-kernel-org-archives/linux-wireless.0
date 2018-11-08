Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17829ECDE4C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5DF020892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5DF020892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbeKIAXm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:23:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbeKIAXl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:23:41 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51CC83078AD3;
        Thu,  8 Nov 2018 14:47:52 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8EBE6873C;
        Thu,  8 Nov 2018 14:47:41 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC/RFT 1/4] mt76x02: configure basic rates and fallback on STA mode
Date:   Thu,  8 Nov 2018 15:47:07 +0100
Message-Id: <1541688430-31855-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 08 Nov 2018 14:47:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For STA mode configure legacy basic rates according to info
mac80211 provides to us, as well as follback registers, which
are setup in vendor driver under CONFIG_STA_SUPPORT .
For LB_FBK_CFG1 register use values from vendor driver, which
are different for mt76x0 and mt76x2 .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 87ce6a51fb05..2be4b527477f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -678,6 +678,18 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 		tasklet_enable(&dev->pre_tbtt_tasklet);
 	}
 
+	if (changed & BSS_CHANGED_BASIC_RATES &&
+	    vif->type == NL80211_IFTYPE_STATION) {
+		mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
+		mt76_wr(dev, MT_VHT_HT_FBK_CFG0, 0x65432100);
+		mt76_wr(dev, MT_VHT_HT_FBK_CFG1, 0xedcba980);
+		mt76_wr(dev, MT_LG_FBK_CFG0, 0xedcba988);
+		if (is_mt76x2(dev))
+			mt76_wr(dev, MT_LG_FBK_CFG1, 0x87872100);
+		else
+			mt76_wr(dev, MT_LG_FBK_CFG1, 0x00872100);
+	}
+
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
 			       MT_BEACON_TIME_CFG_INTVAL,
-- 
1.9.3

