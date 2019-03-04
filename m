Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44EFC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 953262082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="VM/g+nkH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfCDICt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:49 -0500
Received: from nbd.name ([46.4.11.11]:40460 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfCDICs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=waiChvUzWUfY738HP17KgcPNWkqU5Y+Vq02APgqC4GI=; b=VM/g+nkHKG9locAUHoXiUgy3yY
        hsfv8D3KtjsIVkjXDqN1WLoTFGbFrml8Hd0XQoL5Meee+uvLFmNn1zlBljieOmItYljilr3kzjc3f
        cwG4iTkEOAu3VDoTREA0rWrX/rKu7SYpF4OlABZ+ydEvrYZKoqQDL6erdAxzAn8ZSo78=;
Received: by maeck.lan (Postfix, from userid 501)
        id 1A0A750E5416; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] mt76: mt76x2: fix external LNA gain settings
Date:   Mon,  4 Mar 2019 09:02:26 +0100
Message-Id: <20190304080234.3221-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Devices with external LNA need different values for AGC registers 8 and 9

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 1848e8ab2e21..c7e71f2ba2a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -260,10 +260,15 @@ mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 	gain_val[0] = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
 	gain_val[1] = dev->cal.agc_gain_cur[1] - dev->cal.agc_gain_adjust;
 
-	if (dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
+	val = 0x1836 << 16;
+	if (!mt76x2_has_ext_lna(dev) &&
+	    dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
 		val = 0x1e42 << 16;
-	else
-		val = 0x1836 << 16;
+
+	if (mt76x2_has_ext_lna(dev) &&
+	    dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ &&
+	    dev->mt76.chandef.width < NL80211_CHAN_WIDTH_40)
+		val = 0x0f36 << 16;
 
 	val |= 0xf8;
 
-- 
2.17.0

