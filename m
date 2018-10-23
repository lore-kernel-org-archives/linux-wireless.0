Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3E4C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A304205F4
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A304205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbeJXFB6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 01:01:58 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:35876 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJXFB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 01:01:58 -0400
Received: from ben-dt3.candelatech.com (firewall.candelatech.com [50.251.239.81])
        by mail2.candelatech.com (Postfix) with ESMTP id 605E940A5A2;
        Tue, 23 Oct 2018 13:36:55 -0700 (PDT)
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Clear beacon_int in ieee80211_do_stop
Date:   Tue, 23 Oct 2018 13:36:52 -0700
Message-Id: <1540327012-8371-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 2.4.11
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This fixes stale beacon-int values that would keep a netdev
from going up.

To reproduce:

Create two VAP on one radio.
vap1 has beacon-int 100, start it.
vap2 has beacon-int 240, start it (and it will fail
  because beacon-int mismatch).
reconfigure vap2 to have beacon-int 100 and start it.
  It will fail because the stale beacon-int 240 will be used
  in the ifup path and hostapd never gets a chance to set the
  new beacon interval.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/iface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 90a59ce..f699cc84 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1059,6 +1059,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (local->open_count == 0)
 		ieee80211_clear_tx_pending(local);
 
+	sdata->vif.bss_conf.beacon_int = 0;
+
 	/*
 	 * If the interface goes down while suspended, presumably because
 	 * the device was unplugged and that happens before our resume,
-- 
2.4.11

