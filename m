Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:65190 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZAEA3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 19:29:37 -0500
Message-ID: <49615465.4090604@lwfinger.net> (sfid-20090105_012942_040993_A170F12E)
Date: Sun, 04 Jan 2009 18:29:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org>
In-Reply-To: <20090104174123.GW496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi,

Andi Kleen wrote:
> 
> Anyways with PID i get between 1Mbit/s and 5.5Mbit/s, most of the
> time 1Mbit/s. So it's not really much better.


Does this patch help? Recently mac80211 changed from expecting tries
to retries, and I don't think rtl8180 got changed.

Larry

===============
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -188,7 +188,7 @@ static void rtl8180_handle_tx(struct iee
 		    (flags & RTL818X_TX_DESC_FLAG_TX_OK))
 			info->flags |= IEEE80211_TX_STAT_ACK;

-		info->status.rates[0].count = (flags & 0xFF) + 1;
+		info->status.rates[0].count = (flags & 0xFF);

 		ieee80211_tx_status_irqsafe(dev, skb);
 		if (ring->entries - skb_queue_len(&ring->queue) == 2)

-------


