Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11327C48BC2
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jun 2021 17:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEDDE61353
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jun 2021 17:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhFUR6N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232893AbhFUR4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D3A61245;
        Mon, 21 Jun 2021 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298000;
        bh=KhbiyuLLERIEN3mwW3CiOReyCEtnWfy9EMZ7F+JCMOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXHcY8lHtLRzc+uqeIZyVj/hssOdzxsFVUazomRWwouyJHbKmb42DE6y1T6ciLk8J
         kYo6b5N41hxwyD4aeeoLBzieCorAVHePVZgv1yBwvsbO7w3+nn/qx6qgnaTuLi++Cw
         cT9DAoj4lscCnmpT/ngtXIynYb/mP1jclKTpxqvNWEvL/Lr318TKEWeoRiBnWHZnPM
         l0VSR8sCilG/z0xmazJp/0SQ/XXEx9saqbYMjixhvYThpOY031891hfBMwzTZ8xKKK
         zHWWIdtyxPEHFOMe6tJ0M9PrW1+mhvaEpndyyyzSSR4jfeTvgFx6F3MPFWTW0q4fnj
         gKnPMKGKdQE7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/35] mac80211: drop multicast fragments
Date:   Mon, 21 Jun 2021 13:52:38 -0400
Message-Id: <20210621175300.735437-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a9799541ca34652d9996e45f80e8e03144c12949 ]

These are not permitted by the spec, just drop them.

Link: https://lore.kernel.org/r/20210609161305.23def022b750.Ibd6dd3cdce573dae262fcdc47f8ac52b883a9c50@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ef8ff0bc66f1..38b5695c2a0c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2250,17 +2250,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (is_multicast_ether_addr(hdr->addr1)) {
-		I802_DEBUG_INC(rx->local->dot11MulticastReceivedFrameCount);
-		goto out_no_led;
-	}
-
 	if (rx->sta)
 		cache = &rx->sta->frags;
 
 	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
 		goto out;
 
+	if (is_multicast_ether_addr(hdr->addr1))
+		return RX_DROP_MONITOR;
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
 	if (skb_linearize(rx->skb))
@@ -2386,7 +2384,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

