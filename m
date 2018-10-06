Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233E4C67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE5E12064E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="f058r7I9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE5E12064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbeJGAjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
Received: from nbd.name ([46.4.11.11]:35778 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbeJGAjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3sjsKjj2ts57hXCUXzxlaC+vFWbehm71LtIfLyPfFAY=; b=f058r7I9eFBO3DT6e7yE9oZwod
        ZjNml96E9vTCrk1wrxH6X5F9zVSIdmeVzQuj/bLrD/0xv3m24yCPD9qoib3RwymOSw9SCNlkS8KzD
        6XdUn4ItHNKFh5V8cx09PcNwqIWcob+qYS5k3j4GdZFZbf3i9rBxrFArlbDWP0G0IMvc=;
Received: by maeck.local (Postfix, from userid 501)
        id 2E20B3E6EAF3; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 7/9] mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode
Date:   Sat,  6 Oct 2018 19:35:05 +0200
Message-Id: <20181006173507.7316-7-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Long/short preamble selection cannot be sampled separately, since it
depends on the BSS state. Because of that, sampling attempts to
currently not used preamble modes are not counted in the statistics,
which leads to CCK rates being sampled too often.

Fix statistics accounting for long/short preamble by increasing the
index where necessary.
Fix excessive CCK rate sampling by dropping unsupported sample attempts.

This improves throughput on 2.4 GHz channels

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 6cc28ca5d4a6..fdcb4e9b4560 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -281,7 +281,8 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 				break;
 
 		/* short preamble */
-		if (!(mi->supported[group] & BIT(idx)))
+		if ((mi->supported[group] & BIT(idx + 4)) &&
+		    (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
 			idx += 4;
 	}
 	return &mi->groups[group].rates[idx];
@@ -1080,18 +1081,23 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		return;
 
 	sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
+	sample_idx %= MCS_GROUP_RATES;
+
+	if (sample_group == &minstrel_mcs_groups[MINSTREL_CCK_GROUP] &&
+	    (sample_idx >= 4) != txrc->short_preamble)
+		return;
+
 	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	rate->count = 1;
 
-	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+	if (sample_group == &minstrel_mcs_groups[MINSTREL_CCK_GROUP]) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
 	} else if (sample_group->flags & IEEE80211_TX_RC_VHT_MCS) {
 		ieee80211_rate_set_vht(rate, sample_idx % MCS_GROUP_RATES,
 				       sample_group->streams);
 	} else {
-		rate->idx = sample_idx % MCS_GROUP_RATES +
-			    (sample_group->streams - 1) * 8;
+		rate->idx = sample_idx + (sample_group->streams - 1) * 8;
 	}
 
 	rate->flags = sample_group->flags;
-- 
2.17.0

