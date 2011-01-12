Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1ALKpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 05:45:39 -0500
Subject: Re: Mesh join/leave
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294828087.16447.2.camel@mythtv.ewol.com>
References: <1294780828.2383.0.camel@mythtv.ewol.com>
	 <1294823034.3639.15.camel@jlt3.sipsolutions.net>
	 <1294828087.16447.2.camel@mythtv.ewol.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 11:46:20 +0100
Message-ID: <1294829180.3639.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 05:28 -0500, Steve Brown wrote:
> On Wed, 2011-01-12 at 10:03 +0100, Johannes Berg wrote:
> > On Tue, 2011-01-11 at 16:20 -0500, Steve Brown wrote:
> > > In testing this, the command "iw mesh0 mesh leave" doesn't stop
> > > beaconing. Beaconing continues with a null mesh id.
> > > 
> > > Is this the intended behavior?
> > 
> > No, it's not -- what driver are you using?

Of course maybe mac80211 should be doings omething like this too:

johannes

--- wireless-testing.orig/net/mac80211/tx.c	2011-01-12 11:44:52.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2011-01-12 11:45:52.000000000 +0100
@@ -2299,6 +2299,11 @@ struct sk_buff *ieee80211_beacon_get_tim
 		struct ieee80211_mgmt *mgmt;
 		u8 *pos;
 
+#ifdef CONFIG_MAC80211_MESH
+		if (!sdata->u.mesh.mesh_id_len)
+			goto out;
+#endif
+
 		/* headroom, head length, tail length and maximum TIM length */
 		skb = dev_alloc_skb(local->tx_headroom + 400 +
 				sdata->u.mesh.vendor_ie_len);


