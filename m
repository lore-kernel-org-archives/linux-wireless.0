Return-Path: <SRS0=Yehs=D2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264BEC433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 16:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6C5F2224D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 16:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgJSQDD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730335AbgJSQDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Oct 2020 12:03:03 -0400
Received: from rhcavuit01.kulnet.kuleuven.be (rhcavuit01.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C5C0613CE
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2020 09:03:02 -0700 (PDT)
X-KULeuven-Envelope-From: mathy.vanhoef@kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 16293120336.A4A36
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-smtps-1.cc.kuleuven.be (icts-p-smtps-1e.kulnet.kuleuven.be [134.58.240.33])
        by rhcavuit01.kulnet.kuleuven.be (Postfix) with ESMTP id 16293120336
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2020 18:02:54 +0200 (CEST)
Received: from mathy-work.localhost (unknown [92.96.35.190])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by icts-p-smtps-1.cc.kuleuven.be (Postfix) with ESMTPSA id 7B22440B5;
        Mon, 19 Oct 2020 18:02:52 +0200 (CEST)
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Christian Hesse <list@eworm.de>,
        Thomas Deutschmann <whissi@gentoo.org>
Subject: [PATCH] mac80211: fix regression where EAPOL frames were sent in plaintext
Date:   Mon, 19 Oct 2020 20:01:13 +0400
Message-Id: <20201019160113.350912-1-Mathy.Vanhoef@kuleuven.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When sending EAPOL frames via NL80211 they are treated as injected
frames in mac80211. Due to commit 1df2bdba528b ("mac80211: never drop
injected frames even if normally not allowed") these injected frames
were not assigned a sta context in the function ieee80211_tx_dequeue,
causing certain wireless network cards to always send EAPOL frames in
plaintext. This may cause compatibility issues with some clients or
APs, which for instance can cause the group key handshake to fail and
in turn would cause the station to get disconnected.

This commit fixes this regression by assigning a sta context in
ieee80211_tx_dequeue to injected frames as well.

Note that sending EAPOL frames in plaintext is not a security issue
since they contain their own encryption and authentication protection.

Fixes: 1df2bdba528b ("mac80211: never drop injected frames even if normally not allowed")
Reported-by: Thomas Deutschmann <whissi@gentoo.org>
Tested-by: Christian Hesse <list@eworm.de>
Tested-by: Thomas Deutschmann <whissi@gentoo.org>
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
---
 net/mac80211/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8ba10a48d..55b41167a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3619,13 +3619,14 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
 
-	if (txq->sta && !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
+	if (txq->sta) {
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
 		/*
 		 * Drop unicast frames to unauthorised stations unless they are
-		 * EAPOL frames from the local station.
+		 * injected frames or EAPOL frames from the local station.
 		 */
-		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
+		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+			     ieee80211_is_data(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
-- 
2.28.0

