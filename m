Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8458C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B25CC21473
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfDHMjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:39:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54260 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfDHMjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:39:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDTYV-0006fl-FH; Mon, 08 Apr 2019 14:39:19 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: only allocate one queue when using iTXQs
Date:   Mon,  8 Apr 2019 14:39:11 +0200
Message-Id: <20190408123911.20053-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no need to allocate than one queue in the iTXQs case
now that we no longer use ndo_select_queue to assign the AC.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6e1b031535d5..94459b2b3d2a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1763,13 +1763,13 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			txq_size += sizeof(struct txq_info) +
 				    local->hw.txq_data_size;
 
-		if (local->ops->wake_tx_queue)
+		if (local->ops->wake_tx_queue) {
 			if_setup = ieee80211_if_setup_no_queue;
-		else
+		} else {
 			if_setup = ieee80211_if_setup;
-
-		if (local->hw.queues >= IEEE80211_NUM_ACS)
-			txqs = IEEE80211_NUM_ACS;
+			if (local->hw.queues >= IEEE80211_NUM_ACS)
+				txqs = IEEE80211_NUM_ACS;
+		}
 
 		ndev = alloc_netdev_mqs(size + txq_size,
 					name, name_assign_type,
-- 
2.17.2

