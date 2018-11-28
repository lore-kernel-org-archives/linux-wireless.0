Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A1FC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 21:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A90942081C
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 21:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="I4vgfd54"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A90942081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbeK2ImV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 03:42:21 -0500
Received: from nbd.name ([46.4.11.11]:46166 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbeK2ImU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 03:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ftk4djMlXPUE/hgg1i5GUznKtvBrjMS4AG8YW9wiDmA=; b=I4vgfd54Ob0/xKNsDwNg1nhkJZ
        6dbpvjJo49kKGMmZ7wePvqNHZDL6iSaZi02nRhIcM+ZiVCZpXAVysJWwuZdDow5qCc6bQ5oanD9/i
        wo4c7S4O11rDTqInhfarcYgww5Dz8SXqlA7UDK8S52hcNxHvt3y1qQxz/lGK4uoDaq48=;
Received: by maeck.lan (Postfix, from userid 501)
        id 008C247DF98B; Wed, 28 Nov 2018 22:39:16 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix reordering of buffered broadcast packets
Date:   Wed, 28 Nov 2018 22:39:16 +0100
Message-Id: <20181128213916.25822-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If the buffered broadcast queue contains packets, letting new packets bypass
that queue can lead to heavy reordering, since the driver is probably throttling
transmission of buffered multicast packets after beacons.

Keep buffering packets until the buffer has been cleared (and no client
is in powersave mode).

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 582b3d49f891..cd35af38d81f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -439,8 +439,8 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_hw_check(&tx->local->hw, QUEUE_CONTROL))
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
-	/* no stations in PS mode */
-	if (!atomic_read(&ps->num_sta_ps))
+	/* no stations in PS mode and no buffered packets */
+	if (!atomic_read(&ps->num_sta_ps) && skb_queue_empty(&ps->bc_buf))
 		return TX_CONTINUE;
 
 	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
-- 
2.17.0

