Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C58C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18BE20666
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dJzq4xEE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C18BE20666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbeJASEP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:04:15 -0400
Received: from nbd.name ([46.4.11.11]:44238 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbeJASEP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:04:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6lINbkGfPJZesFr6jujeFIqfXR3zem1tdWQi6//02sA=; b=dJzq4xEE/1djc+ElALeThYlaQ7
        AIBhCzcPmU+rPxIAQHhVDAHKqoRIUmnLv8rk+GAxOi1wNPVY1XCTKRQ4/IVgU68Na7v/NcMjvX50x
        9TPeEDMx+ukarpI2U7OJonWQLwRLrAeHjktIqXjP9Rq/eyBC7Lv73szIyX7gGZqwY12k=;
Received: by maeck.local (Postfix, from userid 501)
        id D66043B8DAF3; Mon,  1 Oct 2018 13:26:54 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt76x2: fix multi-interface beacon configuration
Date:   Mon,  1 Oct 2018 13:26:54 +0200
Message-Id: <20181001112654.19362-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If the first virtual interface is a station (or an AP with beacons
temporarily disabled), the beacon of the second interface needs to
occupy hardware beacon slot 0.
For some reason the beacon index was incorrectly masked with the
virtual interface beacon mask, which prevents the secondary
interface from sending beacons unless the first one also does.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 25ce8fcbb873..bb9c0a059a6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -129,8 +129,7 @@ __mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 bcn_idx, struct sk_buff *skb)
 	if (skb) {
 		ret = mt76_write_beacon(dev, beacon_addr, skb);
 		if (!ret)
-			dev->beacon_data_mask |= BIT(bcn_idx) &
-						 dev->beacon_mask;
+			dev->beacon_data_mask |= BIT(bcn_idx);
 	} else {
 		dev->beacon_data_mask &= ~BIT(bcn_idx);
 		for (i = 0; i < beacon_len; i += 4)
-- 
2.17.0

