Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44808 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaAZWDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 17:03:10 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
 channels
Date: Sun, 26 Jan 2014 22:03:06 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03336BC8B@HASMSX106.ger.corp.intel.com> (sfid-20140126_230316_131293_FEE41FFF)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-4-git-send-email-ilan.peer@intel.com>
 <20140125000901.GA28512@garbanzo.do-not-panic.com>
In-Reply-To: <20140125000901.GA28512@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Thanks for your comments.

Ilan.

> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Saturday, January 25, 2014 02:09
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; wireless-regdb@lists.infradead.org
> Subject: Re: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
> channels
> 

> > It is assumed that such restrictions are enforced by user space.
> > Furthermore, it is assumed, that if the conditions that allowed for
> > the operation of the GO on such a channel change, i.e., the station
> > interface disconnected from the AP, it is the responsibility of user
> > space to evacuate the GO from the channel.
> 
> You may be interested in perhaps picking up my regulatory quiescing patch.
> Can you check and let me know?
> 

Sure. Will have a look.

> > +config CFG80211_REG_SOFT_CONFIGURATIONS
> 
> Please use something specific to P2P, maybe CFG80211_REG_P2P_RELAX or
> something. It would be good to also provide a reference to a URL on
> wireless.kernel.org on documentation about an example userspace instance
> or effort that is doing this.
> 

Will change the config name. As for the documentation, do you mean something like what I've added to the cover letter? Anyway, I will handle this once these patches are accepted.

> >
> > +#ifdef CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS
> 
> Please use config_enabled(CONFIG_FOO) check to simplify this.

Sure.

> 
> > +/* For GO only, check if the channel can be used under permissive
> > +conditions
> > + * mandated by the some regulatory bodies, i.e., the channel is
> > +marked with
> > + * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station
> > +interface
> > + * associated to an AP on the same channel or on the same UNII band
> > + * (assuming that the AP is an authorized master).
> > + */
> 
> Comments go like this:
> 
> /*
>  * somet suff
>  * bladsf
>  */
> 

I thought I was following the networking comment style :) anyway .. fixing.

> 
> <--
> 
> > +		wdev_lock(wdev_iter);
> > +		if (wdev_iter->current_bss)
> > +			other_chan = wdev_iter->current_bss-
> >pub.channel;
> > +		wdev_unlock(wdev_iter);
> 
> -->
> 
> This is begging to be added as a helper.
> 

Sure. 

> > +
> > +		if (!other_chan)
> > +			continue;
> > +
> > +		if (chan == other_chan) {
> > +			return true;
> 
> No need to use braces for one liners and since you are returning no need to
> indent the code below, as the else is implicit. This in practice helps reduce
> general code identation.
> 
> Likeywise you can follow by a check for ! 5 GHz and bail if, and save yourself
> the identation on the negative.
> 

Fixing 

> > +static bool cfg80211_go_permissive_chan(struct
> cfg80211_registered_device *rdev,
> > +					struct ieee80211_channel *chan)
> > +{
> > +	return false;
> > +}
> > +#endif /* CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS */
> 
> Please review chan.c well and make a call (you decide) if this belongs on
> chan.c or reg.c.
> 

I think that it is more suited in chan.c (similar to dfs handling ...).

> > +	/* Under certain conditions suggested by the some regulatory bodies
> > +	 * a GO can operate on channels marked with IEEE80211_NO_IR
> > +	 * so set this flag only if such relaxations are not enabled and
> > +	 * the conditions are not met.
> 
> Comment style.

Fixing ...

> 
> > +	 */
> > +	if (iftype != NL80211_IFTYPE_P2P_GO ||
> > +	    !cfg80211_go_permissive_chan(rdev, chandef->chan))
> > +		prohibited_flags |= IEEE80211_CHAN_NO_IR;
> 
> Please add a wiphy regulatory feature flag here that allows device drivers to
> disable this, this can be enabled by default.
> Practice shows regulatory stuff varies and I can imagine other vendors
> wanting to consider disabling for some customers or builds for whatever
> unestablished reasons.
> 

Sure. 

> > +/**
> > + * cfg80211_get_unii - get a value specifying the U-NII band the
> > +frequency
> > + * belongs too.
> 
> One liners for top description on kdoc IIRC.
> 

Fixing.

> > + * @freq: the frequency for which we want to get the UNII band.
> > +
> > + * U-NII bands are defined by the FCC in C.F.R 47 part 15.
> > + *
> > + * Returns -EINVAL if freq is invalid, 1 for UNII-1, 2 for UNII-2,
> > + * 3 for UNII-2e, 4 for UNII-3.
> 
> What's your source for UNII definition? Can you provide a URL?
> 

FCC in C.F.R 47 part 15 ... WIP to get the URL. 


