Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53193 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZG0QMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 12:12:02 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248710568.8500.7.camel@johannes.local>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
	 <1248710568.8500.7.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 12:12:00 -0400
Message-Id: <1248711120.6965.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 18:02 +0200, Johannes Berg wrote:

> Actually, you're using ath5k, right? So we can see what
> info->control.vif points to after ath5k has used the skb, because
> apparently it's a valid pointer at least, just not a real vif pointer
> any more.

I'm using ath9k.

Here's something interesting I have found.  sdata->dev is valid if
info->flags is 0x14091 and not valid if it's 0x12091.

0x4000 is IEEE80211_TX_INTFL_NEED_TXPROCESSING and 0x2000 is
IEEE80211_TX_INTFL_RCALGO.

This patch prevents any panics.  Moreover, I get a connection with the 
correct PSK.

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 75604cd..dd1fa8b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1889,6 +1889,9 @@ void ieee80211_tx_pending(unsigned long data)
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			struct ieee80211_sub_if_data *sdata;
 
+			if (!(info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING))
+				continue;
+
 			if (WARN_ON(!info->control.vif)) {
 				kfree_skb(skb);
 				continue;



-- 
Regards,
Pavel Roskin
