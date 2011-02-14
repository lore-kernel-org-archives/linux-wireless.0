Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1BNKSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:18:35 -0500
Subject: Re: [PATCH 2/2] mwl8k: Tell mac80211 we have rate adaptation in AP
 FW
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, Sandesh Goel <sgoel@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
In-Reply-To: <20110212003420.GG1240@mail.wantstofly.org>
References: <1297469031-21004-1-git-send-email-thomas@cozybit.com>
	 <1297469031-21004-2-git-send-email-thomas@cozybit.com>
	 <20110212003420.GG1240@mail.wantstofly.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:18:31 +0100
Message-ID: <1297678711.3785.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-12 at 01:34 +0100, Lennert Buytenhek wrote:

> >  	/* Set rssi values to dBm */
> >  	hw->flags |= IEEE80211_HW_SIGNAL_DBM;
> > +	/* AP FW has rate control */
> > +	if (priv->ap_fw)
> > +		hw->flags |= IEEE80211_HW_HAS_RATE_CONTROL;
> >  	hw->vif_data_size = sizeof(struct mwl8k_vif);
> >  	hw->sta_data_size = sizeof(struct mwl8k_sta);
> 
> I got this same patch (almost exactly the same -- STA firmware actually
> also has rate control so the added AP check in this version of the patch
> is bogus) sent to me a number of times now, the last time from Pradeep
> Nemavat <pnemavat@marvell.com> in private email on Feb 26 2010.  This
> is what I wrote back to him at the time:
> 
> | mac80211.h says:
> | 
> |  * @IEEE80211_HW_HAS_RATE_CONTROL:
> |  *      The hardware or firmware includes rate control, and cannot be
> |  *      controlled by the stack. As such, no rate control algorithm
> |  *      should be instantiated, and the TX rate reported to userspace
> |  *      will be taken from the TX status instead of the rate control
> |  *      algorithm.
> |  *      Note that this requires that the driver implement a number of
> |  *      callbacks so it has the correct information, it needs to have
> |  *      the @set_rts_threshold callback and must look at the BSS config
> |  *      @use_cts_prot for G/N protection, @use_short_slot for slot
> |  *      timing in 2.4 GHz and @use_short_preamble for preambles for
> |  *      CCK frames.
> | 
> | In particular, the "need to report TX rate used in the TX status"
> | requirement is something that we don't do, which is why I didn't merge
> | the IEEE80211_HW_HAS_RATE_CONTROL change upstream yet.  (I know that
> | it improves performance, but performance is secondary to correctness.)

Well, this objection is bogus. If you ask for minstrel rate control, and
then don't use what it does, then not only will it perform less well and
minstrel will converge to some arbitrary value, it will also mean that
the rate reported to userspace (say in tcpdump) is *WRONG*. That's even
worse than not reporting it.

johannes

