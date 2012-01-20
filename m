Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63553 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab2ATVmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 16:42:17 -0500
Received: by iacb35 with SMTP id b35so121068iac.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 13:42:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327091044.9857.8.camel@jlt3.sipsolutions.net>
References: <20120119182033.5F60358073@lefflers.sfo.corp.google.com>
	<1327069053.9857.3.camel@jlt3.sipsolutions.net>
	<CA+yqC4Y-nKrX=jaGbPTk7LqsR+3jqPJssOEFuw0dPm+sMyMvGg@mail.gmail.com>
	<1327091044.9857.8.camel@jlt3.sipsolutions.net>
Date: Fri, 20 Jan 2012 13:42:15 -0800
Message-ID: <CA+yqC4a9+KD-eXeQHQcfUngq=7GLG9CS_9Je3PUdEGhsssAmTg@mail.gmail.com> (sfid-20120120_224220_898735_CC6AEFDF)
Subject: Re: [PATCH RESEND] mac80211: support fixed rate packet injection
From: Sam Leffler <sleffler@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 20, 2012 at 12:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Fri, 2012-01-20 at 10:44 -0800, Sam Leffler wrote:
> > On Fri, Jan 20, 2012 at 6:17 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > >
> > > On Thu, 2012-01-12 at 09:53 -0800, Sam Leffler wrote:
> > >
> > > > +     if (fixed_rate != -1) {
> > > > +             struct ieee80211_channel *chan = local->hw.conf.channel;
> > > > +             struct ieee80211_supported_band *sband =
> > > > +                     local->hw.wiphy->bands[chan->band];
> > > > +             struct ieee80211_tx_rate *rates = info->control.rates;
> > > > +             int i;
> > > > +
> > > > +             if (fixed_rate_flags & IEEE80211_TX_RC_MCS) {
> > > > +                     WARN_ON(!sband->ht_cap.ht_supported);
> > > > +                     rates[0].idx = fixed_rate;
> > >
> > > Unless I missed something, this would be *trivial* to trigger by
> > > injection -- doesn't seem like a good idea to me.
> > >
> >
> > Can unprivileged users inject packets?  Is your preference to generate
> > an error or just suppress the warning?
>
> I'm not sure, but it doesn't really matter -- even printing an error
> here is quite pointless.
>

Not sure why you say that.  If you submit a packet and it's tossed w/o
any indication (e.g. you mistakenly set the channel wrong so the
driver tosses the frame) then it's not obvious what's going on.
Anyway, I'll remove the warning.

-Sam
