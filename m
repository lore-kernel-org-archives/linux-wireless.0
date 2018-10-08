Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F141C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 11:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BD720858
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 11:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Xwj5Q9Em"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0BD720858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbeJHS5e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 14:57:34 -0400
Received: from nbd.name ([46.4.11.11]:38028 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbeJHS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 14:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n/n32ISV6ZSHZmYsJcD31D/f/cKoIt+bqKvrn75C2nQ=; b=Xwj5Q9EmhhxlKWpb4zxF1cFEpZ
        2gisMyL535rUYfbdw/Y9CuDDVpIf1DLgTIhoOmClh1fsNl1Iq/gCGI9wM1Vy/xSk74+7LVYWHTYKH
        xmL3Tv/MZ+4iSSEZRDoPynvF0ZcAsni46xDDwMz4ZQXmoFBF6/MWMKJsgEa9mYa/UYKE=;
Received: by maeck.lan (Postfix, from userid 501)
        id 730353EAA62C; Mon,  8 Oct 2018 13:46:12 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: do not store aggregation sequence number for null-data frames
Date:   Mon,  8 Oct 2018 13:46:12 +0200
Message-Id: <20181008114612.44544-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes a rare corner case where a BlockAckReq might get the wrong
sequence number.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index bf0e9e666bc4..7cbce03aa65b 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -96,7 +96,8 @@ mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    !ieee80211_is_data_present(hdr->frame_control))
 		return;
 
 	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
-- 
2.17.0

