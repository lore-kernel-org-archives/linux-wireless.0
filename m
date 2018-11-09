Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6187DC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25AC520827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25AC520827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbeKIUAw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbeKIUAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:00:52 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31C14C0528BD;
        Fri,  9 Nov 2018 10:20:56 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC7C9190CF;
        Fri,  9 Nov 2018 10:20:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 5/5] mt76x02: remove no longer actual comment
Date:   Fri,  9 Nov 2018 11:20:14 +0100
Message-Id: <1541758814-2046-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 09 Nov 2018 10:20:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove comment about one configurable BSSID registers since
we utilize AP-Client feature now.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 2bb79c6eb54b..9fd9b5f9d3f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -250,17 +250,10 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
 
 	/*
-	 * Client mode typically only has one configurable BSSID register,
-	 * which is used for bssidx=0. This is linked to the MAC address.
-	 * Since mac80211 allows changing interface types, and we cannot
-	 * force the use of the primary MAC address for a station mode
-	 * interface, we need some other way of configuring a per-interface
-	 * remote BSSID.
 	 * The hardware provides an AP-Client feature, where bssidx 0-7 are
 	 * used for AP mode and bssidx 8-15 for client mode.
 	 * We shift the station interface bss index by 8 to force the
-	 * hardware to recognize the BSSID.
-	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
+	 * hardware to recognize the BSSID as STA.
 	 */
 	if (vif->type == NL80211_IFTYPE_STATION)
 		idx += 8;
-- 
1.9.3

