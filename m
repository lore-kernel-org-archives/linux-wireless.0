Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3DKJTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 05:19:35 -0400
Message-ID: <1365671968.8272.35.camel@jlt4.sipsolutions.net> (sfid-20130411_111940_553663_F18FB6C8)
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX
 performance.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Apr 2013 11:19:28 +0200
In-Reply-To: <516455CA.6070504@candelatech.com>
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>
	  (sfid-20130403_184908_772897_29241D1E) <1365501478.8465.17.camel@jlt4.sipsolutions.net>
	 <516455CA.6070504@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-09 at 10:54 -0700, Ben Greear wrote:

> >> +struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
> >> +				     const u8 *vif_addr, const u8 * sta_addr) {
> >> +	struct sta_info *sta;
> >> +
> >> +	sta = rcu_dereference_check(local->sta_vhash[STA_HASH(vif_addr)],
> >> +				    lockdep_is_held(&local->sta_mtx));
> >> +	while (sta) {
> >> +		if (ether_addr_equal(sta->sdata->vif.addr, vif_addr) &&
> >> +		    ether_addr_equal(sta->sta.addr, sta_addr))
> >> +			break;
> >> +		sta = rcu_dereference_check(sta->vnext,
> >> +					    lockdep_is_held(&local->sta_mtx));
> >
> > Almost all of your rcu_dereference_check() invocations should be
> > rcu_dereference_protected(). See include/linux/rcupdate.h :)
> 
> Now this, I'm not so sure of.  That rcu_dereference_protected seems to
> be only used for the 'update-side' use.  I was under the impression
> that when the mac80211 rx logic is called we are only protected by rcu,
> not the update mutex.

Ah, yes, I was reading this the wrong way, sorry. Here the _check() is
correct of course -- you want to be either under RCU protection or hold
the sta_mtx.

> I also struggle to understand RCU properly...so maybe I'm just
> wrong about all that...
> 
> The other methods to get sta_info around that code use the _check() variant,
> by the way...

Yeah ... :)

Another question: Have you thought about hashing the virtual interfaces
instead of the stations, and then hashing the stations inside each
virtual interface? That would make it a bit of a two-level thing:

A1 (in the frame) -> virtual interface
    A2 (frame) -> station

But it would address the TX side efficiently without "some_sta" since
you know the virtual interface there already, and could potentially have
less impact on the code? On TX it'd actually even be more efficient if
you have more than 1 station per interface (right now you don't though)

johannes

