Return-Path: <SRS0=MKuk=4M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E748C11D2F
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 12:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 724EE20732
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 12:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgBXMT7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:19:59 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:51780 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXMT7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Feb 2020 07:19:59 -0500
Received: from localhost.localdomain (unknown [141.24.207.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 6454F580074;
        Mon, 24 Feb 2020 13:19:57 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] mac80211: only send control port frames over nl80211 control port
Date:   Mon, 24 Feb 2020 13:19:54 +0100
Message-Id: <20200224121954.66739-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As Jouni recently pointed out, the nl80211 control should only transmit
and receive EAPOL frames. This patch removes forwarding of
preauthentication frames over the control port. They are handled as
ordinary data frames again.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 net/mac80211/rx.c | 3 +--
 net/mac80211/tx.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6bd24123456d..9f586a60e783 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2496,8 +2496,7 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct net_device *dev = sdata->dev;
 
-	if (unlikely((skb->protocol == sdata->control_port_protocol ||
-		      skb->protocol == cpu_to_be16(ETH_P_PREAUTH)) &&
+	if (unlikely(skb->protocol == sdata->control_port_protocol &&
 		     sdata->control_port_over_nl80211)) {
 		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 		bool noencrypt = !(status->flag & RX_FLAG_DECRYPTED);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 83147385c200..571e7b08bac6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5317,10 +5317,8 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	u32 flags;
 
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
-	 * or Pre-Authentication
 	 */
-	if (proto != sdata->control_port_protocol &&
-	    proto != cpu_to_be16(ETH_P_PREAUTH))
+	if (proto != sdata->control_port_protocol)
 		return -EINVAL;
 
 	if (unencrypted)
-- 
2.25.1

