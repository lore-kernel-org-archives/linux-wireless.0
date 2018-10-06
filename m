Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E5FC67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7AB2064E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="n4TKKtTq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD7AB2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbeJGAjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
Received: from nbd.name ([46.4.11.11]:35804 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbeJGAjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b7bSrfewcV2TCJ9mgiP2Vg2MzaP9eAAg1alYTWgaM7M=; b=n4TKKtTqmeiKPMGW/XBn5kTzqQ
        0NIgVTCP9Ao76CAbUfh3zhtKfNRYQMNsqO0ZrhQlGQVlY/8oZELTbM9Jo3NzH234IXTUJfoZ2C4pU
        ypHBqV71oMiIJX9lq7dMmKPCwCO+84N+V35asXOgd2B2ffS+KTE2tphTw9gpiJOysRt4=;
Received: by maeck.local (Postfix, from userid 501)
        id 2FCC93E6EAF9; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 8/9] mac80211: minstrel: do not sample rates 3 times slower than max_prob_rate
Date:   Sat,  6 Oct 2018 19:35:06 +0200
Message-Id: <20181006173507.7316-8-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These rates are highly unlikely to be used quickly, even if the link
deteriorates rapidly. This improves throughput in cases where CCK rates
are not reliable enough to be skipped entirely during sampling.
Sampling these rates regularly can cost a lot of airtime.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index fdcb4e9b4560..f466ec37d161 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1004,10 +1004,13 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		return -1;
 
 	/*
-	 * Do not sample if the probability is already higher than 95%
-	 * to avoid wasting airtime.
+	 * Do not sample if the probability is already higher than 95%,
+	 * or if the rate is 3 times slower than the current max probability
+	 * rate, to avoid wasting airtime.
 	 */
-	if (mrs->prob_ewma > MINSTREL_FRAC(95, 100))
+	sample_dur = minstrel_get_duration(sample_idx);
+	if (mrs->prob_ewma > MINSTREL_FRAC(95, 100) ||
+	    minstrel_get_duration(mi->max_prob_rate) * 3 < sample_dur)
 		return -1;
 
 	/*
@@ -1017,7 +1020,6 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 	cur_max_tp_streams = minstrel_mcs_groups[tp_rate1 /
 		MCS_GROUP_RATES].streams;
-	sample_dur = minstrel_get_duration(sample_idx);
 	if (sample_dur >= minstrel_get_duration(tp_rate2) &&
 	    (cur_max_tp_streams - 1 <
 	     minstrel_mcs_groups[sample_group].streams ||
-- 
2.17.0

