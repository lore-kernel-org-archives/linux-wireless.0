Return-Path: <SRS0=676Y=DZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F5DC433E7
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Oct 2020 19:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD22220714
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Oct 2020 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050715;
	bh=0Si8sYFictuo/anSAUU6Sehfcghwz4mryykeuuymkMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bTrVdzjdPvZqRxl06cCwV//c1UfpYszeGsmH7cn4j405h5NVOlEFmrbvY3SJJpBio
	 zLRQ6yNmUeF7eeaZlf6JtxvnUocL3fQGs6a5n+MOW6PvhjDmB//fQBbTJ102VhlsEw
	 bg4zOfibeE6C0isiM0Wz2tgXtG33DIEWhESzJ4lk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387821AbgJRTvy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbgJRTVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B50C0222C8;
        Sun, 18 Oct 2020 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048871;
        bh=0Si8sYFictuo/anSAUU6Sehfcghwz4mryykeuuymkMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNKTQvENaRbBbfm3Nz+PB4UayVKHcKAUZwuNJDWKr4StlZ5UfhvigvwBwJyz2u+rr
         u9+HLr60N4eMjfLm3JdMOVP1nOPuxoIvuCboyKlj/s2iZTceHdlZA3FGCEKidxAqHK
         GX9w+pzMijwfyIZCerOBSOJLZHT/uYcCRL3GpqLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 036/101] mac80211: handle lack of sband->bitrates in rates
Date:   Sun, 18 Oct 2020 15:19:21 -0400
Message-Id: <20201018192026.4053674-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Thomas Pedersen <thomas@adapt-ip.com>

[ Upstream commit 8b783d104e7f40684333d2ec155fac39219beb2f ]

Even though a driver or mac80211 shouldn't produce a
legacy bitrate if sband->bitrates doesn't exist, don't
crash if that is the case either.

This fixes a kernel panic if station dump is run before
last_rate can be updated with a data frame when
sband->bitrates is missing (eg. in S1G bands).

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
Link: https://lore.kernel.org/r/20201005164522.18069-1-thomas@adapt-ip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c      | 3 ++-
 net/mac80211/sta_info.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1079a07e43e49..d74cfec685477 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -709,7 +709,8 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		u16 brate;
 
 		sband = ieee80211_get_sband(sta->sdata);
-		if (sband) {
+		WARN_ON_ONCE(sband && !sband->bitrates);
+		if (sband && sband->bitrates) {
 			brate = sband->bitrates[rate->idx].bitrate;
 			rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 05e966f1609e2..b93916c382cdb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2122,6 +2122,10 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 		int rate_idx = STA_STATS_GET(LEGACY_IDX, rate);
 
 		sband = local->hw.wiphy->bands[band];
+
+		if (WARN_ON_ONCE(!sband->bitrates))
+			break;
+
 		brate = sband->bitrates[rate_idx].bitrate;
 		if (rinfo->bw == RATE_INFO_BW_5)
 			shift = 2;
-- 
2.25.1

