Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZG0SWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:22:41 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248712821.11808.6.camel@mj>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
	 <1248710568.8500.7.camel@johannes.local>  <1248711120.6965.6.camel@mj>
	 <1248712821.11808.6.camel@mj>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 20:22:09 +0200
Message-Id: <1248718929.13118.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 12:40 -0400, Pavel Roskin wrote:
> On Mon, 2009-07-27 at 12:12 -0400, Pavel Roskin wrote:
> > +			if (!(info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING))
> > +				continue;
> 
> P.S. ieee80211_tx_pending_skb() actually checks
> IEEE80211_TX_INTFL_NEED_TXPROCESSING and doesn't use sdata in that case.
> 
> Perhaps we could use skb->dev instead of sdata->dev in that case.

Nah, the bug is far more far-reaching, please see and try the patch
below.

> Also, the existence of ieee80211_tx_pending_skb() doesn't seem justified
> in its present form.  It's a piece of ieee80211_tx_pending() that
> calculates the same variables and does the checks that the caller should
> be doing.  I would just integrate it into ieee80211_tx_pending().  If
> the result is too complex, we could split it in a more logical way.

Well... go ahead and try to clean it up -- I don't think it's possible
due to the locking in ieee80211_tx_pending(), you definitely don't want
to have a function that must be called with a lock held and then drops
it in the middle only to re-acquire it. Just inlining it makes the whole
thing unreadable imo.

Anyway, please let me know if the patch below fixes things for you.
Again, one of these things where I'm sure there's an issue here, but I'm
not sure it's the one you're seeing.

johannes

---
 net/mac80211/main.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- wireless-testing.orig/net/mac80211/main.c	2009-07-27 19:44:11.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-07-27 20:17:01.000000000 +0200
@@ -310,6 +310,31 @@ static void ieee80211_handle_filtered_fr
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
+	/*
+	 * XXX: This is temporary!
+	 *
+	 *	The problem here is that when we get here, the driver will
+	 *	quilte likely have pretty much overwritten info->control by
+	 *	using info->driver_data or info->rate_driver_data. Thus,
+	 *	when passing out the frame to the driver again, we would be
+	 *	passing completely bogus data since the driver would then
+	 *	expect a properly filled info->control. In mac80211 itself
+	 *	the same problem occurs, since we need info->control.vif
+	 *	internally.
+	 *
+	 *	To fix this, we should send the frame through TX processing
+	 *	again. However, it's not that simple, since the frame will
+	 *	have been software-encrypted (if applicable) already, and
+	 *	encrypting it again doesn't do much good. So to properly do
+	 *	that, we not only have to skip the actual 'raw' encryption
+	 *	(key selection etc. still has to be done!) but also the
+	 *	sequence number assignment since that impacts the crypto
+	 *	encapsulation, of course.
+	 *
+	 *	Hence, for now, fix the bug by just dropping the frame.
+	 */
+	goto drop;
+
 	sta->tx_filtered_count++;
 
 	/*
@@ -363,6 +388,7 @@ static void ieee80211_handle_filtered_fr
 		return;
 	}
 
+ drop:
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (net_ratelimit())
 		printk(KERN_DEBUG "%s: dropped TX filtered frame, "


