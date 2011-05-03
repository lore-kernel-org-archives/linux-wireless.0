Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49838 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1ECIxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 04:53:14 -0400
Received: by wwa36 with SMTP id 36so7184958wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 01:53:13 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: set TID of internal mgmt packets to 7
Date: Tue,  3 May 2011 11:53:07 +0300
Message-Id: <1304412787-13883-1-git-send-email-arik@wizery.com> (sfid-20110503_105317_954972_908CF2B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue mapping of internal mgmt packets is set to VO. Set the TID
value to match the queue mapping. Otherwise drivers that only look at
the TID might get confused.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e3e3aa1..e1a39ed 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2534,8 +2534,9 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	skb_set_network_header(skb, 0);
 	skb_set_transport_header(skb, 0);
 
-	/* send all internal mgmt frames on VO */
-	skb_set_queue_mapping(skb, 0);
+	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
+	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+	skb->priority = 7;
 
 	/*
 	 * The other path calling ieee80211_xmit is from the tasklet,
-- 
1.7.4.1

