Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44408 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3FDKp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:45:27 -0400
Received: by mail-lb0-f170.google.com with SMTP id t11so483694lbd.15
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 03:45:26 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Use IEEE80211_TX_CTL_REQ_TX_STATUS on nullframes
Date: Tue,  4 Jun 2013 12:44:52 +0200
Message-Id: <1370342692-3191-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20130604_124530_003068_AA1D0C14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The connection monitor needs to know the tx status of
nullframes to work properly.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/mac80211/mlme.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 118540b..005fea5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -880,6 +880,10 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
+
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
-- 
1.8.1.2

