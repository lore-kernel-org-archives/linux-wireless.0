Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA11C433E6
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Dec 2020 16:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C1E521D94
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Dec 2020 16:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgL2QC1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Dec 2020 11:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgL2QC0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Dec 2020 11:02:26 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F41C06179A
        for <linux-wireless@vger.kernel.org>; Tue, 29 Dec 2020 08:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4Cc2WIYX0G5jqvwSfwbMlmVwB7JJTTi0EjZpMo3oQNI=; b=Thfv4HDgiDx8fATXrmvBzEegrs
        bI9mFlrhpIaNAJggKI1oczkV4QnV1xO2KhSv3cUzLzUNdIALltaJnVbtWmG/stZysKEeNaAnZdlIo
        qsIzYJSu5JKWBHLoRiA0Tr0qH1JhR9l4+OXNvzm2abYz+Ky4Ijc8DGWE+UupmBF4hCu8=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kuHRA-0005ka-IN; Tue, 29 Dec 2020 17:01:28 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 6/8] mac80211: minstrel_ht: improve sample rate selection
Date:   Tue, 29 Dec 2020 17:01:23 +0100
Message-Id: <20201229160125.92794-6-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201229160125.92794-1-nbd@nbd.name>
References: <20201229160125.92794-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Always allow sampling of rates faster than the primary max throughput rate.
When the second max_tp_rate is higher than the first one, sample attempts were
previously skipped, potentially causing rate control to get stuck at a slightly
lower rate

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 950e6d2b4525..dcc4394a872a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1379,13 +1379,13 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	mrs = &mg->rates[sample_idx];
 	sample_idx += sample_group * MCS_GROUP_RATES;
 
-	/* Set tp_rate1, tp_rate2 to the highest / second highest max_tp_rate */
+	tp_rate1 = mi->max_tp_rate[0];
+
+	/* Set tp_rate2 to the second highest max_tp_rate */
 	if (minstrel_get_duration(mi->max_tp_rate[0]) >
 	    minstrel_get_duration(mi->max_tp_rate[1])) {
-		tp_rate1 = mi->max_tp_rate[1];
 		tp_rate2 = mi->max_tp_rate[0];
 	} else {
-		tp_rate1 = mi->max_tp_rate[0];
 		tp_rate2 = mi->max_tp_rate[1];
 	}
 
-- 
2.28.0

