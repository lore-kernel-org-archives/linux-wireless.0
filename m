Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5195BECDE4D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2238A2081D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2238A2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbeKIAXn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:23:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbeKIAXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:23:43 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EF801F8DC;
        Thu,  8 Nov 2018 14:47:53 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37DA318C41;
        Thu,  8 Nov 2018 14:47:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC/RFT 2/4] mt76x02: reserve wcid 0 for global traffic
Date:   Thu,  8 Nov 2018 15:47:08 +0100
Message-Id: <1541688430-31855-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 08 Nov 2018 14:47:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Restore behaviour on mt76x0 before commit  1bb04bb4b838 ("mt76: move
mt76x02_init_device in mt76x02-lib module"). This will allow to use
wcid 1 for AP when we work in station mode. It's not clear if this
is needed, but this is how vendor driver assign wcid's in STA mode.
This should be harmless for mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 2be4b527477f..e624397b3d8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -113,7 +113,11 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
 	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
 
-	dev->mt76.global_wcid.idx = 255;
+	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
+	 * entry no. 1 like it does in the vendor driver.
+	 */
+	dev->mt76.wcid_mask[0] |= 1;
+	dev->mt76.global_wcid.idx = 0;
 	dev->mt76.global_wcid.hw_key_idx = -1;
 	dev->slottime = 9;
 
-- 
1.9.3

