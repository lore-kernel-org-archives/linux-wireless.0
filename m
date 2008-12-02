Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65365 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbYLBRfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:35:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:35:06 -0800
Date: Tue, 2 Dec 2008 01:35:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@web.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
Subject: Re: [PATCH 1/6 v2.2] mac80211: add sta_notify_ps callback
Message-ID: <20081202093516.GA5926@tesla> (sfid-20081202_183512_107895_9B19CCA5)
References: <200811292232.56550.chunkeey@web.de> <200811300048.42352.chunkeey@web.de> <20081201191723.GI5992@tesla> <200812021655.53141.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200812021655.53141.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2008 at 07:55:53AM -0800, Christian Lamparter wrote:
> On Monday 01 December 2008 20:17:23 Luis R. Rodriguez wrote:
> > On Sat, Nov 29, 2008 at 03:48:41PM -0800, Christian Lamparter wrote:
> > > This patch is necessary in order to provide a proper Access point support for p54.
> > > Unfortunately for us, there is no documented way to disable the interfering
> > > power save buffering mechanism in firmware completely.
> > >
> > > Therefore we give in and notify the driver through our new sta_notify_ps callback,
> > > so that we can update the filter state.
> > >
> > > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > ---
> > > +/**
> > >   * enum ieee80211_tkip_key_type - get tkip key
> > >   *
> > >   * Used by drivers which need to get a tkip key for skb. Some drivers need a
> > > @@ -1248,6 +1261,9 @@ enum ieee80211_ampdu_mlme_action {
> > >   * @sta_notify: Notifies low level driver about addition or removal
> > >   *     of associated station or AP.
> > >   *
> > > + * @sta_ps_notify: Notifies low level driver about the power state transition
> > > + *     of a associated station. Must be atomic.
> > > + *
> >
> > Can we add documentation that this is only required when the AP cannot
> > figure this out by itself? This can help people working on AP support to
> > not think they need to implement this for all drivers.
> 
> Do you think "This callback is optional. Only use it, if your hardware/
> firmware really implements a station filter table" 

You would know better, I don't know why this callback was needed in
terms of hardware, but from reading the reason why it came up it seems
it was specific to p54. I just wanted that to be pointed out so new
developers reading the kdoc for it would know it maybe optional.

So atheros hardware supports a BSSID mask and we use this to know which
STAs to send ACKs to. Is this what the p54 "station filter table" is
used for? If not what is meant by a "station filter table"?

> is enough (and correct spelled btw?)
> Or do you volunteer for adding one or two DOC entries about APs, BC & MC Buffering,
> TIM and station filters mechanism, caveats, and available callbacks or solutions?

Well I did add this but to the wiki (with Ivan's help on the TIM stuff
and image):

http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings

And unfortunately it is not very hardware design specifics, and has
nothing about caveats, or filter mechanisms. But feel free to take as
you like/refer to it/edit as you see fit.

  Luis
