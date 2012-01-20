Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2ATUYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 15:24:06 -0500
Subject: Re: [PATCH RESEND] mac80211: support fixed rate packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <CA+yqC4Y-nKrX=jaGbPTk7LqsR+3jqPJssOEFuw0dPm+sMyMvGg@mail.gmail.com> (sfid-20120120_194506_497637_8B1FBA8F)
References: <20120119182033.5F60358073@lefflers.sfo.corp.google.com>
	 <1327069053.9857.3.camel@jlt3.sipsolutions.net>
	 <CA+yqC4Y-nKrX=jaGbPTk7LqsR+3jqPJssOEFuw0dPm+sMyMvGg@mail.gmail.com>
	 (sfid-20120120_194506_497637_8B1FBA8F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jan 2012 21:24:04 +0100
Message-ID: <1327091044.9857.8.camel@jlt3.sipsolutions.net> (sfid-20120120_212410_571896_765ABF7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-01-20 at 10:44 -0800, Sam Leffler wrote:
> On Fri, Jan 20, 2012 at 6:17 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> > On Thu, 2012-01-12 at 09:53 -0800, Sam Leffler wrote:
> >
> > > +     if (fixed_rate != -1) {
> > > +             struct ieee80211_channel *chan = local->hw.conf.channel;
> > > +             struct ieee80211_supported_band *sband =
> > > +                     local->hw.wiphy->bands[chan->band];
> > > +             struct ieee80211_tx_rate *rates = info->control.rates;
> > > +             int i;
> > > +
> > > +             if (fixed_rate_flags & IEEE80211_TX_RC_MCS) {
> > > +                     WARN_ON(!sband->ht_cap.ht_supported);
> > > +                     rates[0].idx = fixed_rate;
> >
> > Unless I missed something, this would be *trivial* to trigger by
> > injection -- doesn't seem like a good idea to me.
> >
> 
> Can unprivileged users inject packets?  Is your preference to generate
> an error or just suppress the warning?

I'm not sure, but it doesn't really matter -- even printing an error
here is quite pointless.

johannes

