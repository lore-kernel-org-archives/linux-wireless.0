Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35224 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZAQWHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 17:07:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 17 Jan 2009 14:07:07 -0800
Date: Sat, 17 Jan 2009 14:06:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
Message-ID: <20090117220636.GO29609@tesla> (sfid-20090117_230713_598269_B8C3F529)
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com> <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232097659.3854.20.camel@johannes> <20090116163646.GG29609@tesla> <43e72e890901161413n3fdd7031lfdd0a363941b697d@mail.gmail.com> <1232184649.3668.2.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232184649.3668.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 17, 2009 at 01:30:49AM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 14:13 -0800, Luis R. Rodriguez wrote:
> 
> > >> > +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
> > >> > +                    const struct ieee80211_reg_rule **reg_rule)
> > >> > +{
> > >> > +   return freq_reg_info_regd(wiphy, center_freq,
> > >> > +           bandwidth, reg_rule, NULL);
> > >> > +}
> > >>
> > >> Are you not using this or am I just not seeing the user?
> > >
> > > Yeah -- good catch, its just cruft left over from my previous work.
> > 
> > Actually  freq_reg_info_regd() is used by handle_channel_custom(),
> > hence my comment on re-inventing the wheel. But yeah it used.
> 
> Yeah but not freq_reg_info?

That one is used by the reg_notifier() in ath9k to inspect the country IE
regulatory domain processed.

  Luis
