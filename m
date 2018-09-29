Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3297FC43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 13:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 844902087A
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 13:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="HNVC9yS4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 844902087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbeI2TeS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 15:34:18 -0400
Received: from nbd.name ([46.4.11.11]:48618 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbeI2TeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 15:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Su8IB44WmXmnES8CPu+SQ2TwLZzmqoOPkB77gpf2xTk=; b=HNVC9yS4SOHdnhMdBX9b3/pCDQ
        p6G1vDCXC58NHqLaUEb7Z2oPTUlAiBXI4mevwmPGz2ETzBYqPgZf6eZaSy8BGliSMIjFgCPql3Im0
        30xH/EJumUm5h0jk+lv2//JklEBhO6w8a9LTXdjlv9CXO+X0uF5ZuTCupWs70IOKQ3RM=;
Received: by maeck.local (Postfix, from userid 501)
        id 476743B53453; Sat, 29 Sep 2018 15:05:50 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76: fix handling ps-poll frames
Date:   Sat, 29 Sep 2018 15:05:49 +0200
Message-Id: <20180929130550.86187-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hardware station lookup for pspoll frames can fail, which makes the driver
ignore ps-poll frames. Fix the resulting powersave issues by looking up
the station for pspoll frames in software

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 639cbafc1d50..2a699e8b79bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -550,6 +550,12 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 	struct mt76_wcid *wcid = status->wcid;
 	bool ps;
 
+	if (ieee80211_is_pspoll(hdr->frame_control) && !wcid) {
+		sta = ieee80211_find_sta_by_ifaddr(dev->hw, hdr->addr2, NULL);
+		if (sta)
+			wcid = status->wcid = (struct mt76_wcid *) sta->drv_priv;
+	}
+
 	if (!wcid || !wcid->sta)
 		return;
 
-- 
2.17.0

