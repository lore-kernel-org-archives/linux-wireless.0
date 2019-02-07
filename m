Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C378BC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F0221904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="A5qnjv9r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfBGNr1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:27 -0500
Received: from nbd.name ([46.4.11.11]:47504 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfBGNr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9W3SwsCyYWjEVlTXbTnPQbNZSTcDNVwMrAiKAexAZmQ=; b=A5qnjv9roY04E9VtmwmmEM+pPZ
        wMsI6MI9I38hJpnO3fo3JkOMgNJ0a6GTq08N6JPA34+1zm2kvpEKZmVG25sRQCaz4y06LaofEtFVe
        88bk7+OgWAqKruaeUbikxwAECxUX7Aom3VPwV7Ccyrn4V8ul2uhzEPKPnKXYw+MIf1j0=;
Received: by maeck.lan (Postfix, from userid 501)
        id 84E704F0BF9A; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] mt76: measure the time between mt76x02_edcca_check runs
Date:   Thu,  7 Feb 2019 14:47:22 +0100
Message-Id: <20190207134723.59163-6-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190207134723.59163-1-nbd@nbd.name>
References: <20190207134723.59163-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Based on system load and time needed by other calibration runs, the time
between dev->mac_work runs can vary quite a bit.
Calculate busy time based on the actual time difference in order to avoid
potentially over-estimating busy time, which could lead to unnecessary tx
blocking.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h     |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 7e405297028f..3464b4ca2ea8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -117,6 +117,7 @@ struct mt76x02_dev {
 	bool ed_monitor;
 	u8 ed_trigger;
 	u8 ed_silent;
+	ktime_t ed_time;
 };
 
 extern struct ieee80211_rate mt76x02_rates[12];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index aecf514bb89b..462ac030c08a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -922,6 +922,7 @@ void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable)
 
 	/* clear previous CCA timer value */
 	mt76_rr(dev, MT_ED_CCA_TIMER);
+	dev->ed_time = ktime_get_boottime();
 }
 EXPORT_SYMBOL_GPL(mt76x02_edcca_init);
 
@@ -929,10 +930,16 @@ EXPORT_SYMBOL_GPL(mt76x02_edcca_init);
 #define MT_EDCCA_BLOCK_TH	2
 static void mt76x02_edcca_check(struct mt76x02_dev *dev)
 {
-	u32 val, busy;
+	ktime_t cur_time;
+	u32 active, val, busy;
 
+	cur_time = ktime_get_boottime();
 	val = mt76_rr(dev, MT_ED_CCA_TIMER);
-	busy = (val * 100) / jiffies_to_usecs(MT_MAC_WORK_INTERVAL);
+
+	active = ktime_to_us(ktime_sub(cur_time, dev->ed_time));
+	dev->ed_time = cur_time;
+
+	busy = (val * 100) / active;
 	busy = min_t(u32, busy, 100);
 
 	if (busy > MT_EDCCA_TH) {
-- 
2.17.0

