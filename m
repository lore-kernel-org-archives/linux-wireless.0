Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55130 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0LIQoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 11:44:19 -0500
Received: by yxt3 with SMTP id 3so1483939yxt.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 08:44:18 -0800 (PST)
From: Tim Harvey <harvey.tim@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Tim Harvey <harvey.tim@gmail.com>
Subject: [PATCH] mac80211: Fix NULL-pointer deference on ibss merge when not ready
Date: Thu,  9 Dec 2010 08:43:59 -0800
Message-Id: <1291913039-20801-1-git-send-email-harvey.tim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_open will eventually call ieee80211_ibss_join which sets up the
skb used for beacons/probe-responses however it is possible to
receive beacons that attempt to merge before this occurs causing
a null pointer dereference.

This occurs quite easily in the presence of adhoc nodes with hidden SSID's
---
 net/mac80211/ibss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 410d104..24e2482 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -86,6 +86,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	drv_reset_tsf(local);
 
 	skb = ifibss->skb;
+	if (!skb)
+		return; /* not ready to merge yet */
 	rcu_assign_pointer(ifibss->presp, NULL);
 	synchronize_rcu();
 	skb->data = skb->head;
-- 
1.7.0.4

