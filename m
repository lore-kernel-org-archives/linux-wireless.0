Return-Path: <SRS0=HZW5=B7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC8CC433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 08:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29DC9208DB
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 08:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Pf8KlPww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgHUItn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Aug 2020 04:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgHUIte (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Aug 2020 04:49:34 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C52C061345
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 01:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OfH6NMfLVLcdKdvTqmI1pBUX/QDrSXkQLZz48xXmMSA=; b=Pf8KlPwwc6P4nR5sxsqgyNHHA6
        fOoYB3IeQNfoGBBEAydAo6deKdMnqG0RfiAVlZZodCVzMdrDNRrm6G3S+CtYgAROzwQv/DlndaqFO
        3q2EjOWbpLUcojjrYelO1LH0fBeJEyjI0lN47OHQsEgrpZ4adBPk9SVQt7dDHIZ/ItAw=;
Received: from p5b206497.dip0.t-ipconnect.de ([91.32.100.151] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k92jq-0005lO-Ic; Fri, 21 Aug 2020 10:49:30 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH v3 08/13] mac80211: check and refresh aggregation session in encap offload tx
Date:   Fri, 21 Aug 2020 10:49:21 +0200
Message-Id: <20200821084926.10650-9-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200821084926.10650-1-nbd@nbd.name>
References: <20200821084926.10650-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update the last_tx timestamp to avoid tearing down the aggregation session
early. Fall back to the slow path if the session setup is still running

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 04d8e528357b..64590ad930fe 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4198,6 +4198,8 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	bool authorized = false;
 	bool multicast;
 	unsigned char *ra = ehdr->h_dest;
+	struct tid_ampdu_tx *tid_tx;
+	u8 tid;
 
 	if (IS_ERR(sta) || (sta && !sta->uploaded))
 		sta = NULL;
@@ -4235,6 +4237,22 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	memset(info, 0, sizeof(*info));
 
+	if (sta) {
+		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+		if (tid_tx) {
+			if (!test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+				/* fall back to non-offload slow path */
+				__ieee80211_subif_start_xmit(skb, dev, 0, 0, NULL);
+				return;
+			}
+
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
+			if (tid_tx->timeout)
+				tid_tx->last_tx = jiffies;
+		}
+	}
+
 	if (unlikely(!multicast && skb->sk &&
 		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS))
 		info->ack_frame_id = ieee80211_store_ack_skb(local, skb,
-- 
2.28.0

