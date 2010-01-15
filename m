Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45823 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0AONvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 08:51:09 -0500
Received: by pzk1 with SMTP id 1so859471pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 05:51:09 -0800 (PST)
From: tom.leiming@gmail.com
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] mac80211: fix memory leak in ieee80211_send_probe_req
Date: Fri, 15 Jan 2010 21:44:21 +0800
Message-Id: <1263563061-3825-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

This patch fixes memory leak in ieee80211_send_probe_req, which
is introduced in 7c12ce8b854df346388ea56d684784e3484012cf:

	mac80211: use Probe Request template when sending a direct scan

The patch is against the latest wireless-test tree.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 net/mac80211/util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e278f97..ca170b4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1028,6 +1028,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
+	kfree(buf);
 }
 
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
-- 
1.6.2.5

