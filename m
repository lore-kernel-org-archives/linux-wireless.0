Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:45823 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaBUVWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 16:22:03 -0500
Message-ID: <1393017719.18879.1.camel@porter.coelho.fi> (sfid-20140221_222230_838612_CA751B3D)
Subject: Re: [PATCH v3 3/7] cfg80211: refactor cfg80211_can_use_iftype_chan()
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 23:21:59 +0200
In-Reply-To: <1392971822.4346.25.camel@jlt4.sipsolutions.net>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-4-git-send-email-luca@coelho.fi>
	 <1392971822.4346.25.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 09:37 +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> 
> > +/**
> > + * cfg80211_check_combinations() - check interface combinations
> 
> I don't think those parentheses are right?

Right.  Fixed.


> > + *
> > + * @wiphy: the wiphy
> > + * @num_different_channels: the number of different channels we want
> > + *	to use for verification
> > + * @num_interfaces: the number of different interfaces we want to use
> > + *	for verification
> > + * @used_iftypes: a bitmap where each bit corresponds to an interface
> > + *	type, as in the definition of &struct
> > + *	ieee80211_iface_limit.@types.
> > + * @radar_detect: a bitmap where each bit corresponds to a channel
> > + *	width where radar detection is needed, as in the definition of
> > + *	&struct ieee80211_iface_combination.@radar_detect_widths
> 
> Doesn't that need to be something like hweight(radar_detect) == 1?

No, at this point we should have already checked all the interfaces and
pass the combination of radar widths required.



> > + * @iftype_num: array with the numbers of interfaces of each interface
> > + *	type.  The index is the interface type as specified in &enum
> > + *	nl80211_iftype.
> > + *
> > + * This function can be called by the driver to check whether a
> > + * combination of interfaces and their types are allowed according to
> > + * the interface combinations.
> > + */
> > +int cfg80211_check_combinations(struct wiphy *wiphy,
> > +				const int num_different_channels,
> > +				const int num_interfaces,
> > +				const u32 used_iftypes,
> > +				const u8 radar_detect,
> > +				const int *iftype_num);
> 
> I think that array should be const int iftype_num[NUM_NL80211_IFTYPES],
> I'm pretty sure that works as a function argument as well and would
> serve as a bit of documentation (and possibly even compiler warnings if
> somebody has an array that's too short)

Yep, sounds good.  Fixed.

--
Luca.

