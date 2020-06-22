Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A947DC433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 08:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1132068F
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 08:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFVIuP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:50:15 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:55745 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFVIuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 04:50:14 -0400
Received: from legolas.fritz.box (unknown [79.211.69.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id CC96058007E;
        Mon, 22 Jun 2020 10:50:12 +0200 (CEST)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, j@w1.fi,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH v2] mac80211: fix control port tx status check
Date:   Mon, 22 Jun 2020 10:49:33 +0200
Message-Id: <20200622084933.118413-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The initial control port tx status patch assumed, that
we have IEEE 802.11 frames, but actually ethernet frames
are stored in the ack skb. Fix this by checking for the
correct ethertype and skb protocol 802.3.

Fixes: a7528198add8 ("mac80211: support control port TX status reporting")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
v2: use __be16, as suggested by Johannes Berg
 net/mac80211/status.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 7b1bacac39c6..ff4362d0a0ee 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -639,11 +639,22 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 		u64 cookie = IEEE80211_SKB_CB(skb)->ack.cookie;
 		struct ieee80211_sub_if_data *sdata;
 		struct ieee80211_hdr *hdr = (void *)skb->data;
+		__be16 ethertype = 0xffff;
+
+		if (skb->len >= ETH_HLEN && skb->protocol == cpu_to_be16(ETH_P_802_3))
+			skb_copy_bits(skb, 2 * ETH_ALEN, &ethertype, ETH_TLEN);

 		rcu_read_lock();
 		sdata = ieee80211_sdata_from_skb(local, skb);
 		if (sdata) {
-			if (ieee80211_is_any_nullfunc(hdr->frame_control))
+			if (ethertype == sdata->control_port_protocol)
+				cfg80211_control_port_tx_status(&sdata->wdev,
+								cookie,
+								skb->data,
+								skb->len,
+								acked,
+								GFP_ATOMIC);
+			else if (ieee80211_is_any_nullfunc(hdr->frame_control))
 				cfg80211_probe_status(sdata->dev, hdr->addr1,
 						      cookie, acked,
 						      info->status.ack_signal,
@@ -654,12 +665,8 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 							skb->data, skb->len,
 							acked, GFP_ATOMIC);
 			else
-				cfg80211_control_port_tx_status(&sdata->wdev,
-								cookie,
-								skb->data,
-								skb->len,
-								acked,
-								GFP_ATOMIC);
+				pr_warn("Unknown status report in ack skb\n");
+
 		}
 		rcu_read_unlock();

--
2.27.0

