Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:35650 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965077AbXFHCyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 22:54:51 -0400
Date: Thu, 07 Jun 2007 21:54:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] mac80211: Set low initial rate in rc80211_simple
Message-ID: <4668c4f6.9foQu67PRVz5Fh3G%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initial rate for STA's using rc80211_simple is set to the last
rate in the rate table. For situations for which the signal is weak,
the rate may be too high for authentication and association. Although
the rc80211_simple module will adjust the speed, the response may not
be fast enough for a successful connection. This modification sets the
initial rate to the lowest supported value.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-dev/net/mac80211/rc80211_simple.c
===================================================================
--- wireless-dev.orig/net/mac80211/rc80211_simple.c
+++ wireless-dev/net/mac80211/rc80211_simple.c
@@ -283,10 +283,10 @@ static void rate_control_simple_rate_ini
 	int i;
 	sta->txrate = 0;
 	mode = local->oper_hw_mode;
-	/* TODO: what is a good starting rate for STA? About middle? Maybe not
-	 * the lowest or the highest rate.. Could consider using RSSI from
-	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
-	 * after assoc.. */
+	/* TODO: This routine should consider using RSSI from previous packets
+	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
+	 * Until that method is implemented, we will use the lowest supported rate
+	 * as a workaround, */
 	for (i = 0; i < mode->num_rates; i++) {
 		if ((sta->supp_rates & BIT(i)) &&
 		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
