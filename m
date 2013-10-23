Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53759 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3JWKMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 06:12:37 -0400
Received: by mail-pb0-f51.google.com with SMTP id wz7so586399pbc.24
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 03:12:36 -0700 (PDT)
From: Dhahira Thesneem <dhahira.thesneem@mistralsolutions.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dhahira Thesneem <dhahira.thesneem@mistralsolutions.com>
Subject: [PATCH 1/1] mac80211:Resetting connection monitor timers in transmit path
Date: Wed, 23 Oct 2013 15:42:25 +0530
Message-Id: <1382523145-2302-1-git-send-email-dhahira.thesneem@mistralsolutions.com> (sfid-20131023_121240_677818_8751C6F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset connection monitor timers when we are able to successfully transmit data to an AP.

Signed-off-by: Dhahira Thesneem <dhahira.thesneem@mistralsolutions.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3456c04..e7725cf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1700,7 +1700,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	ieee80211_xmit(sdata, skb, chan->band);
 	rcu_read_unlock();
-
+	/*To reset connection monitor timers, after successful transmission*/
+	ieee80211_sta_reset_conn_monitor(sdata);
 	return NETDEV_TX_OK;
 
 fail_rcu:
@@ -2139,7 +2140,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	ieee80211_xmit(sdata, skb, band);
 	rcu_read_unlock();
-
+	/*To reset connection monitor timers, after successful transmission*/
+	ieee80211_sta_reset_conn_monitor(sdata);
 	return NETDEV_TX_OK;
 
  fail_rcu:
-- 
1.7.5.4

