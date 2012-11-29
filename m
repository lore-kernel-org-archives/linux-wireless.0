Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42058 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2K2PuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 10:50:13 -0500
Message-ID: <1354204171.5254.11.camel@cumari.coelho.fi> (sfid-20121129_165018_077700_3AE1EA36)
Subject: Re: [PATCH 20/20] wl18xx: set last Tx rate from FW status
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 29 Nov 2012 17:49:31 +0200
In-Reply-To: <CA+XVXfdsymv3bSp4SSTCCPCx8igKgE=ODoyT+vf-LRa48cX2xw@mail.gmail.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-21-git-send-email-arik@wizery.com>
	 <1354193471.5254.6.camel@cumari.coelho.fi>
	 <CA+XVXfdsymv3bSp4SSTCCPCx8igKgE=ODoyT+vf-LRa48cX2xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 17:33 +0200, Arik Nemtsov wrote:
> On Thu, Nov 29, 2012 at 2:51 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2012-11-27 at 08:45 +0200, Arik Nemtsov wrote:
> >> Obtain the last Tx rate from the FW status and translate it to
> >> the mac80211 rate+flag format before sending it up via the Tx status.
> >>
> >> Bump up the min FW version to the first FW that supports the rate byte.
> >>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >
> > [...]
> >
> >> +static
> >> +void wl18xx_get_last_tx_rate(struct wl1271 *wl, struct ieee80211_vif *vif,
> >> +                          u8 *tx_rate, u8 *tx_rate_flags)
> >
> > [...]
> >
> >> +     /*
> >> +      * first pass info->control.vif while it's valid, and then fill out
> >> +      * the info->status structures
> >> +      */
> >> +     wl18xx_get_last_tx_rate(wl, info->control.vif,
> >> +                             &info->status.rates[0].idx,
> >> +                             &info->status.rates[0].flags);
> >
> > This doesn't work anymore, because commit 8bc83c24 (mac80211: support
> > VHT rates in TX info) changed the struct like this:
> >
> > @@ -560,10 +568,32 @@ enum mac80211_rate_control_flags {
> >   */
> >  struct ieee80211_tx_rate {
> >         s8 idx;
> > -       u8 count;
> > -       u8 flags;
> > +       u16 count:5,
> > +           flags:11;
> >  } __packed;
> >
> > So you can't get the address of flags anymore.
> >
> > Do you mind respinning it?
> 
> Technically you should do it, since your master branch was pointing to
> an older revision at the time. But I'm feeling generous.

Well, yes I should do it, kind of.


> I'll also rebase the part 3 series on top of the latest code to fix
> any breakage. So I'll at least re-spin the patches containing
> ieee80211_iterate_active_interfaces() (as the prototype was changed)

Thanks! :)

--
Luca.

