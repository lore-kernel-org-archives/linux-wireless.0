Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43327 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZAEEWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 23:22:36 -0500
Message-ID: <49618B06.7070401@lwfinger.net> (sfid-20090105_052239_365397_1AE69EB3)
Date: Sun, 04 Jan 2009 22:22:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org>
In-Reply-To: <20090105025302.GF496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> 
> BTW I see the problem with RT2561 too.
> 

This one should fix all of the rt2x00 drivers.

Larry


Index: wireless-testing/drivers/net/wireless/rt2x00/rt2x00dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -266,7 +266,7 @@ void rt2x00lib_txdone(struct queue_entry
 	tx_info->status.ack_signal = 0;
 	tx_info->status.rates[0].idx = rate_idx;
 	tx_info->status.rates[0].flags = rate_flags;
-	tx_info->status.rates[0].count = txdesc->retry + 1;
+	tx_info->status.rates[0].count = txdesc->retry;
 	tx_info->status.rates[1].idx = -1; /* terminate */

 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {

---
