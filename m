Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C1FC65BB0
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78C9C20878
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="k8k3rFJN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78C9C20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbeLCMZH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:25:07 -0500
Received: from nbd.name ([46.4.11.11]:51620 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbeLCMZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KdtoWbuWWrfdzviDcvACafy/MPT2JkcW0psDjtz0SDI=; b=k8k3rFJNeRMoCLYfQuX3ItJ37D
        TJ+wy9Uos7ejQ+zK2LtEdePSTxcTNbChhSX7Rf5/I8fFfOBdKvFLKSxsk+cYDrWH+pQWFKh0gHQ8K
        2pPg7PNuDbyvyJZAmFi3mFvg3ftw6EJYZ63saH71E/a6ZHiSYUcIez/kJ0V4RS3QHJuo=;
Received: by maeck.lan (Postfix, from userid 501)
        id 6906D480F7A7; Mon,  3 Dec 2018 13:24:15 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76: request tx status for powersave released EOSP packet
Date:   Mon,  3 Dec 2018 13:24:15 +0100
Message-Id: <20181203122415.22387-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181203122415.22387-1-nbd@nbd.name>
References: <20181203122415.22387-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allows mac80211 to keep track of the service period

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index f4093dc0e174..06178bdafbac 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -330,7 +330,8 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
 	if (last)
-		info->flags |= IEEE80211_TX_STATUS_EOSP;
+		info->flags |= IEEE80211_TX_STATUS_EOSP |
+			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	mt76_skb_set_moredata(skb, !last);
 	dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, sta);
-- 
2.17.0

