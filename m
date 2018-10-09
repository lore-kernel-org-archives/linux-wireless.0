Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0916EC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB87F2087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:00:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB87F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbeJIPQQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 11:16:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45580 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbeJIPQQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 11:16:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9mwT-0007NO-FF; Tue, 09 Oct 2018 10:00:33 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: avoid reflecting frames back to the client
Date:   Tue,  9 Oct 2018 10:00:21 +0200
Message-Id: <20181009080021.28519-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

I'm not really sure exactly _why_ I've been carrying a note
for what's probably _years_ to check that we don't do this,
but we clearly do reflect frames back to the station itself
if it sends such.

One way or the other, it's useless since the station doesn't
really need the AP to talk to itself, so suppress it.

While at it, clarify some of the logic by removing skb->data
references in favour of the destination address (pointer) we
already have separately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 96611d5dfadb..9d93d60d0635 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2425,8 +2425,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 			if (!xmit_skb)
 				net_info_ratelimited("%s: failed to clone multicast frame\n",
 						    dev->name);
-		} else if (!is_multicast_ether_addr(ehdr->h_dest)) {
-			dsta = sta_info_get(sdata, skb->data);
+		} else if (!is_multicast_ether_addr(ehdr->h_dest) &&
+			   !ether_addr_equal(ehdr->h_dest, ehdr->h_source)) {
+			dsta = sta_info_get(sdata, ehdr->h_dest);
 			if (dsta) {
 				/*
 				 * The destination station is associated to
@@ -4207,11 +4208,10 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
 	if (fast_rx->internal_forward) {
 		struct sk_buff *xmit_skb = NULL;
-		bool multicast = is_multicast_ether_addr(skb->data);
-
-		if (multicast) {
+		if (is_multicast_ether_addr(addrs.da)) {
 			xmit_skb = skb_copy(skb, GFP_ATOMIC);
-		} else if (sta_info_get(rx->sdata, skb->data)) {
+		} else if (!ether_addr_equal(addrs.da, addrs.sa) &&
+			   sta_info_get(rx->sdata, addrs.da)) {
 			xmit_skb = skb;
 			skb = NULL;
 		}
-- 
2.14.4

