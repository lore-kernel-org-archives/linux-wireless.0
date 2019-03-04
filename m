Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69952C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 379C32082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oCkvpmvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfCDICs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:48 -0500
Received: from nbd.name ([46.4.11.11]:40462 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfCDICs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zG1h7h8LS4WcaOmnCucanD2IdqMldTM1ijy5TdNbF9Y=; b=oCkvpmvXenoDrFzGMzJS0XkL4W
        cPaLywP9gfvytzUosFwUeIhYSjEq61pERsbVe3xtObFuaZ3rv43n67xAPBC6aCTv6wpAeFymTJ76J
        rpbTjic0dhawZnTT5UOit+rEtnsqfhdEpTMngeYD1cF/l0F7uPqN90iB25LhDHQEuBNM=;
Received: by maeck.lan (Postfix, from userid 501)
        id 19CE250E5415; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] mt76: mt7603: clear ps filtering mode before releasing buffered frames
Date:   Mon,  4 Mar 2019 09:02:28 +0100
Message-Id: <20190304080234.3221-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes sending them, otherwise they loop back right into the buffer

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index b10775ed92e6..8da0b8707d24 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -399,6 +399,8 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 
 	__skb_queue_head_init(&list);
 
+	mt7603_wtbl_set_ps(dev, msta, false);
+
 	spin_lock_bh(&dev->ps_lock);
 	skb_queue_walk_safe(&msta->psq, skb, tmp) {
 		if (!nframes)
-- 
2.17.0

