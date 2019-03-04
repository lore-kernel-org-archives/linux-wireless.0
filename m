Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD51FC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A448E2082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y1DYPwgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfCDICk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:40 -0500
Received: from nbd.name ([46.4.11.11]:40442 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfCDICk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kZXpAbKRiftkVW1A1wIIGQ1iudZ4ox3ldmX4q0x0JOM=; b=Y1DYPwgJJ90LB5m/xQ2FTntDmV
        wfbA8Wwan3qCE5Mh4WTt21nRvIl6Hlz8c9m6CCO+b40usewY8DgThxAvQk2InbxuytdaDJStoHyv+
        NTOkXrTvPK9g5Wi56KgQf4vW1Bs1U72TvFwq72Yksa8ir0U7o+Vz8sQSJ7UiLh0Dx3lQ=;
Received: by maeck.lan (Postfix, from userid 501)
        id 1872C50E540F; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] mt76: mt7603: fix tx status HT rate validation
Date:   Mon,  4 Mar 2019 09:02:25 +0100
Message-Id: <20190304080234.3221-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use the correct variable in the check. Fixes an uninitialized variable warning

Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Fixes: c8846e1015022 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 0a0115861b51..5e31d7da96fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1072,7 +1072,7 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	case MT_PHY_TYPE_HT:
 		final_rate_flags |= IEEE80211_TX_RC_MCS;
 		final_rate &= GENMASK(5, 0);
-		if (i > 15)
+		if (final_rate > 15)
 			return false;
 		break;
 	default:
-- 
2.17.0

