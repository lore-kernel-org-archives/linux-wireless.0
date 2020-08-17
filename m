Return-Path: <SRS0=ru0V=B3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14619C433E4
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Aug 2020 18:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BC220716
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Aug 2020 18:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dlESI2WO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390722AbgHQSTT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Aug 2020 14:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388175AbgHQQF3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:29 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F84C061342
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2020 09:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kXaNdzZJduRfaOc+V4bsZYNRnkeBw/Drrl0jQEgix/0=; b=dlESI2WOxj/OSY36NIatwTqfHq
        r4X1HLGUmqif7SDpZhejmmcjRX3zJTIbPL5/bl2fNW63MAn9PU3ljlcsNnyXcN91rd3BZ38rqeIQY
        ZOUoZ519qxV9g5uWuQoRPKhhF5BHnZu3dAzaufwqu76fjWDKefNPc22D2mMIKMJsDckI=;
Received: from p54ae996c.dip0.t-ipconnect.de ([84.174.153.108] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k7hdP-0004Gg-Bq; Mon, 17 Aug 2020 18:05:19 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 3/7] mac80211: remove tx status call to ieee80211_sta_register_airtime
Date:   Mon, 17 Aug 2020 18:05:13 +0200
Message-Id: <20200817160517.94564-3-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817160517.94564-1-nbd@nbd.name>
References: <20200817160517.94564-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

All drivers using airtime fairness are calling ieee80211_sta_register_airtime
directly

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/status.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index b3c356b3fc78..67df7a5acee5 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -988,12 +988,6 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
 						acked, info->status.tx_time);
 
-		if (info->status.tx_time &&
-		    wiphy_ext_feature_isset(local->hw.wiphy,
-					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
-			ieee80211_sta_register_airtime(&sta->sta, tid,
-						       info->status.tx_time, 0);
-
 		if ((tx_time_est = ieee80211_info_get_tx_time_est(info)) > 0) {
 			/* Do this here to avoid the expensive lookup of the sta
 			 * in ieee80211_report_used_skb().
-- 
2.28.0

