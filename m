Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EC4C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 641302082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ovT2MCSM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfCDICp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:45 -0500
Received: from nbd.name ([46.4.11.11]:40448 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfCDICn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bUN1o7Lq/uMqcGUIivfk6bHhzxFU6DxcDatm/5bWxg0=; b=ovT2MCSM+I/iIATBofMK6aROxW
        4blfrhFXjYLm2nyIPGwS/Zsrk4LGqGlXsKLmk4hEvioNksr5k0uWYQ357Zx7IknRUfjx+tmP9KOHL
        IOnl3l4b5dvhdOMoTs7XAmvObuCdoq4vlOl/LrchJ2cf4C+OxYh2W2kBx9zoeF5XMqiE=;
Received: by maeck.lan (Postfix, from userid 501)
        id 18ED850E5411; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] mt76: mt7603: clear the service period on releasing PS filtered packets
Date:   Mon,  4 Mar 2019 09:02:31 +0100
Message-Id: <20190304080234.3221-8-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These packets have no txwi entry in the ring, so tracking via tx status does
not work. To prevent PS poll requests from being unanswered, end the service
period right away

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 8da0b8707d24..ea25eff5e81c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -416,6 +416,9 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&dev->ps_lock);
 
+	if (!skb_queue_empty(&list))
+		ieee80211_sta_eosp(sta);
+
 	mt7603_ps_tx_list(dev, &list);
 
 	if (nframes)
-- 
2.17.0

