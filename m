Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60476 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0LISLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 13:11:40 -0500
Received: by pva4 with SMTP id 4so575078pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 10:11:40 -0800 (PST)
From: Tim Harvey <harvey.tim@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Tim Harvey <harvey.tim@gmail.com>
Subject: [PATCH v2] mac80211: Fix NULL-pointer deference on ibss merge when not ready
Date: Thu,  9 Dec 2010 10:11:21 -0800
Message-Id: <1291918281-17965-1-git-send-email-harvey.tim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_open will eventually call ieee80211_ibss_join which sets up the
skb used for beacons/probe-responses however it is possible to
receive beacons that attempt to merge before this occurs causing
a null pointer dereference.  Check ssid_len as that is the last
thing set in ieee80211_ibss_join.

This occurs quite easily in the presence of adhoc nodes with hidden SSID's

Signed-off-by: Tim Harvey <harvey.tim@gmail.com>
---
 net/mac80211/ibss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 410d104..93926c0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -85,6 +85,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local);
 
+	if (!ifibss->ssid_len)
+		return; /* not ready to merge yet */
 	skb = ifibss->skb;
 	rcu_assign_pointer(ifibss->presp, NULL);
 	synchronize_rcu();
-- 
1.7.0.4

