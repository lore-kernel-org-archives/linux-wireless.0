Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81741C433EF
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Nov 2021 12:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629A96120A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Nov 2021 12:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344501AbhKRMJP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Nov 2021 07:09:15 -0500
Received: from ns.iliad.fr ([212.27.33.1]:54592 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344494AbhKRMJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Nov 2021 07:09:13 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2021 07:09:12 EST
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id E8AB2213A9
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2021 12:58:24 +0100 (CET)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id D193E2134A
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2021 12:58:24 +0100 (CET)
Message-ID: <66f51659416ac35d6b11a313bd3ffe8b8a43dd55.camel@freebox.fr>
Subject: [PATCH] mac80211: fix TCP performance on mesh interface
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     linux-wireless@vger.kernel.org
Date:   Thu, 18 Nov 2021 12:58:24 +0100
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Thu Nov 18 12:58:24 2021 +0100 (CET)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

sta is NULL for mesh point (resolved later), so sk pacing parameters
were not applied.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 net/mac80211/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a756a197c770..f8f5bffd6e4b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4197,11 +4197,11 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	ieee80211_aggr_check(sdata, sta, skb);
 
+	sk_pacing_shift_update(skb->sk, sdata->local->hw.tx_sk_pacing_shift);
+
 	if (sta) {
 		struct ieee80211_fast_tx *fast_tx;
 
-		sk_pacing_shift_update(skb->sk, sdata->local->hw.tx_sk_pacing_shift);
-
 		fast_tx = rcu_dereference(sta->fast_tx);
 
 		if (fast_tx &&
-- 
2.17.1


