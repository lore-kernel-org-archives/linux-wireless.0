Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KCIPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:15:44 -0400
Subject: Re: mac80211: UAPSD - EOSP bit seems to be not set when send qos
 null frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320307683.3950.2.camel@jlt3.sipsolutions.net> (sfid-20111103_090811_283339_BC65CFF7)
References: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com>
	 <1320306440.3950.0.camel@jlt3.sipsolutions.net>
	 <CAFED-j=sP7PSD8yv1U4RA9-NGnjJ9CE5C6qWOQxZ=rzGMdt+2w@mail.gmail.com>
	 (sfid-20111103_090606_495560_51D06706)  <1320307683.3950.2.camel@jlt3.sipsolutions.net>
	 (sfid-20111103_090811_283339_BC65CFF7)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:15:42 +0100
Message-ID: <1320308142.3950.3.camel@jlt3.sipsolutions.net> (sfid-20111103_091550_450359_05F3DDBC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 09:08 +0100, Johannes Berg wrote:

> > Yes, I see this is set correctly before we call ieee80211_set_qos_hdr().
> > Next ieee80211_set_qos_hdr() fuction seems not care about EOSP bit and
> > we have this bit cleared before ieee80211_tx() call.
> 
> Oh, WTH. Somebody had posted a patch that fixed that, I thought that
> went in but in my testing this didn't show up since my device always
> sets/clears it according to what I told it.

Try this please.

johannes

--- wireless-testing.orig/net/mac80211/wme.c	2011-11-02 11:05:29.000000000 +0100
+++ wireless-testing/net/mac80211/wme.c	2011-11-03 09:14:30.000000000 +0100
@@ -143,10 +143,13 @@ void ieee80211_set_qos_hdr(struct ieee80
 	/* Fill in the QoS header if there is one. */
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
-		u8 ack_policy = 0, tid;
+		u8 ack_policy, tid;
 
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
+		/* preserve EOSP bit */
+		ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
+
 		if (unlikely(sdata->local->wifi_wme_noack_test))
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		/* qos header is 2 bytes */


