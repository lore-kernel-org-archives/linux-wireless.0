Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab1KDOlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:41:39 -0400
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB2CBCC.6080709@candelatech.com>
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
	 <1320299722-30113-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111103_065549_863747_7FFD5818) <1320310045.3950.23.camel@jlt3.sipsolutions.net>
	 <4EB2CBCC.6080709@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 15:41:30 +0100
Message-ID: <1320417690.3969.88.camel@jlt3.sipsolutions.net> (sfid-20111104_154143_120566_BA915DB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 10:13 -0700, Ben Greear wrote:

> > Here's another argument for splitting the patches differently -- this
> > ought to be part of the disable HT40 patch.
> 
> One thing I could do is move patch 3 to be the first patch.  That gives this method
> reason to exist, but I can leave out the disable-HT40 parts and (re)add that in
> the disable-ht40 patch.

I think the whole thing could just be one cfg80211 and one mac80211
patch, wouldn't that make it simpler?


> >> +	/* Set the AMPDU density. */
> >> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info&
> >> +	    IEEE80211_HT_AMPDU_PARM_DENSITY)
> >> +		ht_cap->ampdu_density =
> >> +			(sdata->u.mgd.ht_capa.ampdu_params_info&
> >> +			 IEEE80211_HT_AMPDU_PARM_DENSITY)
> >> +			>>  IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
> >> +}
> >
> > The AMPDU density should only allow increasing.
> >
> > I think a lot of this validation should live in cfg80211 so if another
> > driver wants to implement it, this kind of thing is already covered.
> 
> The ath9k driver supports 0, and then every value that corresponds to 1us or higher.
> If you set it to 1/2us, for instance, it just quietly rounds up to 1us.  It defaults
> to 8, so it appears valid to decrease or increase this value.

What quietly rounds up?

If it defaults to 8 then I'm sure there's a reason for it, such as the
crypto engine not being fast enough and needing 8us buffer between
frames. As such, I really don't think decreasing it is valid.

> > I think there's a lot of data in the ht_cap struct that you don't use,
> > is that right? If so you should reject it being configured. I'm also not
> > quite sure why you support both disable-HT40, and then this setting here
> > that has SUP_WIDTH_20_40 too.
> 
> If I add rejection like this, it will make writing backwards compat user
> space very difficult.  It would be similar to rejecting unknown netlink
> attributes, for instance.

Good point.

> I was thinking that if ht-40 is disabled, then I should clear both the
> IEEE80211_HT_CAP_SUP_WIDTH_20_40 and the IEEE80211_HT_CAP_SGI_40 from
> the capabilities.  Perhaps there are other flags I should clear as well?

I don't know?

> > I'm more and more coming to the conclusion that it would be clearer to
> > make separate configuration items for the various things. Most
> > capabilities you could only disable (greenfield, ...) except for maybe
> > 40mhz-intol, so maybe that would be easier as a separate u16 attribute
> > "disable these HT capabilities"?
> 
> It seemed like more work for not much gain to me, but I don't mind splitting
> it out into separate netlink configurables if you want.

It just seems to me it would clarify the semantics. Not really sure I
care all that much though.

johannes

