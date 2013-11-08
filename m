Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51686 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3KHQyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 11:54:20 -0500
Received: by mail-wi0-f179.google.com with SMTP id hm2so1219263wib.6
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 08:54:18 -0800 (PST)
Date: Fri, 8 Nov 2013 17:54:02 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mac80211: minstrel_ht: do not sample unsupported
 rates
Message-ID: <20131108165402.GB26361@magnum.frso.rivierawaves.com> (sfid-20131108_175423_979436_D18FABC1)
References: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
 <1383928473-798-2-git-send-email-karl.beldan@gmail.com>
 <527D14B7.3090204@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <527D14B7.3090204@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 08, 2013 at 05:43:35PM +0100, Felix Fietkau wrote:
> On 2013-11-08 17:34, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > ATM minstrel_ht does not check whether the sampling rate is supported.
> > Unsupported rates attempts can trigger when there are holes between
> > supported MCSes belonging to the same group (e.g many devices are
> > capable of MCS32 without being capable of MCS33->MCS39).
> > This change replaces an unsupported sample index with the fls of the
> > bitfield of supported indexes.
> > This is not a problem in minstrel which fills a per STA sample table
> > with only supported rates (though only at init).
> > 
> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> > ---
> >  net/mac80211/rc80211_minstrel_ht.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> > index aeec401..1b835ad 100644
> > --- a/net/mac80211/rc80211_minstrel_ht.c
> > +++ b/net/mac80211/rc80211_minstrel_ht.c
> > @@ -703,6 +703,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
> >  
> >  	mg = &mi->groups[mi->sample_group];
> >  	sample_idx = sample_table[mg->column][mg->index];
> > +	if (!(mg->supported & BIT(sample_idx)))
> > +		sample_idx = fls(sample_idx) - 1;
> You probably meant fls(mg->supported) - 1 here, however I think a better
Arf, yes.

> approach would be to just skip the sample attempt. If there are fewer
> rates in a group, we can run fewer sample attempts on it.
> 
Agreed :)

I was skimming through minstrel before leaving for the week-end because
I had planned to put in shape a hack I did a while ago for vht in
minstrel monday is a holiday here and I have absolutely nothing planned.
 
Karl
