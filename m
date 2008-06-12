Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29947 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760087AbYFLNMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 09:12:03 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 06:12:03 -0700
Date: Thu, 12 Jun 2008 06:11:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] First CRDA integration work
Message-ID: <20080612131154.GA28315@tesla> (sfid-20080612_151210_221063_7614BA21)
References: <20080611040402.GE17936@ruslug.rutgers.edu> <1213260106.19369.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1213260106.19369.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 01:41:46AM -0700, Johannes Berg wrote:
> 
> > + * @NL80211_CMD_GET_REG: Get current regulatory domain, this is a query 
> > + * 	to the kernel wireless core, the wireless core returns currently
> > + * 	set alpha2 by %NL80211_ATTR_REG_ALPHA2,.
> 
> Please specify what command it comes in, probably _NEW_REG that you
> haven't added.

We can probably not even add this, what do you think?

> > + * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sets this after
>                                                                 sends
> 
> > + * 	being queried by the kernel.
> 
> How?

This should be the CMD_NEW_REG then, I called it "SET" as we can only
set one regulatory domain. Let me know your preference.

> >  CRDA replies by sending a regulatory domain
> > + * 	structure which consists of %NL80211_ATTR_REG_ALPHA set to our current alpha2
> > + * 	if it found a match.
> 
> Why set the alpha2 again? I thought the kernel queried for that?

This is in case we wanted to support letting userspace query the kernel
what alpha2 it has set. I'm OK with not supporting this though but it
seemed it may have come in handy, hopefully not for abuse for other
things.

> >  It also provides %NL80211_ATTR_REG_NUM,
> 
> What is that for?

The number of reg rules for the current regdomain. We'd convert the
array or reg rules structs to an number of attributes we are sure to
receive. The alternative I think is to pass all the data into a _DATA
type and let us parse it ourselves. I'm not sure, what do you think?

I was thinking something like this:

If NL80211_ATTR_REG_NUM == 3

Then the nested attributes will be packed like this:

reg-rule	Attribute
-----------------------------------------------------------
1		NL80211_ATTR_REG_RULE_FLAGS
1		NL80211_ATTR_REG_RULE_FREQ_START
1		NL80211_ATTR_REG_RULE_FREQ_END
1		NL80211_ATTR_REG_RULE_FREQ_MAX_BW
1		NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN
1		NL80211_ATTR_REG_RULE_POWER_MAX_EIRP

2		NL80211_ATTR_REG_RULE_FLAGS
2		NL80211_ATTR_REG_RULE_FREQ_START
2		NL80211_ATTR_REG_RULE_FREQ_END
2		NL80211_ATTR_REG_RULE_FREQ_MAX_BW
2		NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN
2		NL80211_ATTR_REG_RULE_POWER_MAX_EIRP

3		NL80211_ATTR_REG_RULE_FLAGS
3		NL80211_ATTR_REG_RULE_FREQ_START
3		NL80211_ATTR_REG_RULE_FREQ_END
3		NL80211_ATTR_REG_RULE_FREQ_MAX_BW
3		NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN
3		NL80211_ATTR_REG_RULE_POWER_MAX_EIRP
-----------------------------------------------------------

I wanted your input on this. Not sure what is best. Pleas recommend a
format.

> > + * 	%NL80211_ATTR_REG_PGP_SIGNATURE_CHECK,
> 
> It's not PGP either way, 

Excuse my crypto-fu :)

> and why is that required in the kernel?

I don't have strong reasons for this anymore. We can ignore it.

> >  and a regulatory rule. The regulatory
> > + * 	rule consists of set of frequency ranges given by
> > + * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] with an attached power rule given
> > + * 	by %NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
> > + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. Each regulatory rule also has 
> > + * 	an attached %NL80211_ATTR_REG_RULE_FLAGS.
> 
> How are these attributes used? Nested in some array?

I wasn't sure yet, I wanted your feedback, but you are giving me this
through IRC :)

> > + * @NL80211_ATTR_REG_ALPHA2: an ISO-3166-alpha2 country code for which the
> > + * 	current regulatory domain should be set to or is already set to.
> > + * 	For example, 'CR', for Costa Rica.
> 
> Heh :)
> 
> >  This attribute is used by the kernel
> > + * 	to query the CRDA userspace agent to retrieve one regulatory domain.
> > + * 	This attribute can also be used by userspace to query the kernel for
> > + * 	the currently set regulatory domain.
> 
> ???

OK well I haven't figured out how the kernel->CRDA communication would
work yet. CRDA->kernel is nl80211. You can ignore this for now.

> > + * @NL80211_ATTR_REG_NUM_RULES: number of regulatory rules passed
> 
> Not necessary.

OK.

> > + * @NL80211_ATTR_REG_PGP_SIGNATURE_CHECK: whether or not CRDA has blessed
> > + * 	this information through a PGP signature check. If its not blessed
> > + * 	we go ahead and regulatory-taint the kernel. This is obviously
> > + * 	hackable but the purpose is to allow distributions to be able to use
> > + * 	a CRDA with a regulatory database signed off by the community
> > + * 	and get the communities' blessing on this. Vendors can also
> > + * 	support their own custom databases for custom solutions (AP, military).
> > + * 	Start to shift liablity to the user, where it should be.
> 
> Not PGP. It's just an RSA signature. If liability is at the user, why do
> we need to know this in the kernel?

The original idea was to let vendors decide to be able to ignore or not
bug reports (oops) if the kernel was reguluatory tainted. But since we
are using EEPROM data we're OK without this data. It may be desirable
but I can't think of a strong reason behind this anymore.

> > + * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
> > + * 	considerations for a given frequency range. These are the
> > + * 	&enum nl80211_reg_rule_flags.
> 
> Should we use flag attributes here nested into something? That would be
> more netlink-like and allow easier expansion above 32 should it become
> necessary.

OK.

> > + * @NL80211_ATTR_REG_RULE_FREQ_START: starting frequencry for the regulatory
> > + * 	rule in KHz. This is not a center of frequency but an actual regulatory
>                                             ^^ remove
> > + * 	band edge.
> > + * @NL80211_ATTR_REG_RULE_FREQ_END: ending frequency for the regulatory rule
> > + * 	in KHz. This is not a center a frequency but an actual regulatory
>                                        ^^ remove
> > + * 	band edge.
> > + * @NL80211_ATTR_REG_RULE_FREQ_MAX_BW: maximum allowed bandwidth for this
> > + * 	frequency range, in KHz.
> > + * @NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN: the maximum allowed antenna gain
> > + * 	for a given frequency range. The value is in mBi (100 * dBi).
> 
> Can be left out.

OK.

> > +/* Central wireless core regulatory domains, we only need two,
> > + * the current one and a world regulatory domain in case we have no
> > + * information to give us an alpha2 */
> > +const struct ieee80211_regdomain *cfg80211_regdomain;
> 
> const?

Ignore that.

> > +const struct ieee80211_regdomain *cfg80211_world_regdom;
> > +DEFINE_MUTEX(cfg80211_reg_mutex);
> > +
> >  /* RCU might be appropriate here since we usually
> >   * only read the list, and that can happen quite
> >   * often because we need to do it for each command */
> > @@ -402,9 +410,30 @@ static struct notifier_block cfg80211_netdev_notifier = {
> >  	.notifier_call = cfg80211_netdev_notifier_call,
> >  };
> >  
> > +
> >  static int cfg80211_init(void)
> >  {
> > -	int err = wiphy_sysfs_init();
> > +#define	PASSIVE_AND_NO_IBSS	RRF_PASSIVE_SCAN | RRF_NO_IBSS
> > +	int err;
> > +	static const struct ieee80211_regdomain world_regdom = {
> > +		.n_reg_rules = 7, /* I hope we can count */
> 
> ARRAY_SIZE() helps you count.

the # of rules isn't defined yet in this implementation.

> > +		.pgp_signature_check = 1, /* Duh, we're already here */
> > +		.alpha2 =  { '0', '0' }, /* Got any better ideas? */
> 
> "\0\0" so we can't actually ever use this manually?

OK.

> > +		.reg_rules = {
> > +			REG_RULE(2402, 2472, 40, 0, 20,	RRF_PASSIVE_SCAN),
> > +			REG_RULE(2474, 2494, 40, 0, 20,	PASSIVE_AND_NO_IBSS),
> > +			REG_RULE(5160, 5240, 40, 0, 30,	PASSIVE_AND_NO_IBSS),
> > +			REG_RULE(5250, 5330, 40, 0, 30, PASSIVE_AND_NO_IBSS),
> > +			REG_RULE(5735, 5835, 40, 0, 30, PASSIVE_AND_NO_IBSS),
> > +			REG_RULE(5490, 5710, 40, 0, 30, PASSIVE_AND_NO_IBSS),
> > +			REG_RULE(5490, 5710, 40, 0, 30, PASSIVE_AND_NO_IBSS)
> > +		}
> > +	};
> 
> #undef PASSIVE_AND_NOIBSS
> 
> why not declare this statically in the file rather than statically in
> the init function?

OK.

> > +	cfg80211_regdomain = NULL;
> > +	cfg80211_world_regdom = (struct ieee80211_regdomain *) &world_regdom;
> 
> What's with the cast?

Compiler was bitching. But it may have been previous to some changes I
made.

> > --- a/net/wireless/core.h
> > +++ b/net/wireless/core.h
> > @@ -11,6 +11,7 @@
> >  #include <net/genetlink.h>
> >  #include <net/wireless.h>
> >  #include <net/cfg80211.h>
> > +#include "reg.h"
> 
> Hmm?

Not needed, right.

> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -18,6 +18,7 @@
> >  #include <net/cfg80211.h>
> >  #include "core.h"
> >  #include "nl80211.h"
> > +#include "reg.h"
> >  
> >  /* the netlink family */
> >  static struct genl_family nl80211_fam = {
> > @@ -87,6 +88,16 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
> >  	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
> >  				.len = IEEE80211_MAX_MESH_ID_LEN },
> >  	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
> > +
> > +	[NL80211_ATTR_REG_RULE_ALPHA2] = { .type = NLA_NUL_STRING, .len = 3 },
> 
> Why does it have to be a NUL-string? It is always only two bytes, so
> please just do that. No need to null-terminate.

Sure.

> > +static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> 
> -ECODEMISSING :P

Yeah yeah. Hence "early" relase.

> > @@ -9,137 +10,93 @@
> >   */
> >  
> >  /*
> > - * This regulatory domain control implementation is highly incomplete, it
> > - * only exists for the purpose of not regressing mac80211.
> > - *
> > - * For now, drivers can restrict the set of allowed channels by either
> > - * not registering those channels or setting the IEEE80211_CHAN_DISABLED
> > - * flag; that flag will only be *set* by this code, never *cleared.
> > - *
> >   * The usual implementation is for a driver to read a device EEPROM to
> >   * determine which regulatory domain it should be operating under, then
> >   * looking up the allowable channels in a driver-local table and finally
> >   * registering those channels in the wiphy structure.
> >   *
> > - * Alternatively, drivers that trust the regulatory domain control here
> > - * will register a complete set of capabilities and the control code
> > - * will restrict the set by setting the IEEE80211_CHAN_* flags.
> 
> I think you shouldn't remove that but just rewrite it to make the driver
> trust crda instead of this code.

The EEPROM lets us get a list of supported channels for a product a
customer (a vendor's customer, not a regular customer) decided to support.
If we trust CRDA we then could potentially trust a different set of channels
which the customer may not have tested his products on. They probably
will work, but the safer approach is to support only the intended
channels.

We can then trust CRDA only to disable channels, not to *enable*.

> > + * Another set of compliance enforcement is for drivers to use their
> > + * own compliance limits which can be stored on the EEPROM. The host
> > + * driver or firmware may ensure these are used.
> > + *
> > + * In addition to all this we provide an extra layer of regulatory
> > + * compliance, however, that of what is provided by CRDA. This tries
> > + * to ensure we remain complaint by not letting the user up front try
>                           ^^^^^^^^^ heh

Thanks.

> > + * to set their wireless device to settings we know we shouldn't be
> > + * setting to. We also disable channels on the driver which we know we
> > + * shouldn't be using in current regulatory domain. This is because
> > + * some drivers may have outdated EEPROMs or no regulatory control at all.
> 
> 
> > +static int freq_in_range(const struct ieee80211_freq_range *freq_range, u32 freq)
> > +{
> > +	if (freq >= freq_range->start_freq &&
> > +		freq <= freq_range->end_freq)
> > +		return 1;
> > +	return 0;
> >  }
> 
> That needs a bandwidth check I think.

Thanks.

> > +++ b/net/wireless/reg.h
> > @@ -0,0 +1,56 @@
> > +#ifndef __NET_WIRELESS_REG_H
> > +#define __NET_WIRELESS_REG_H
> > +
> > +extern const struct ieee80211_regdomain *cfg80211_regdomain;
> > +extern const struct ieee80211_regdomain *cfg80211_world_regdom;
> > +
> > +struct ieee80211_freq_range {
> > +	u32 start_freq;
> > +	u32 end_freq;
> > +	u32 max_bandwidth;
> > +};
> > +
> > +struct ieee80211_power_rule {
> > +	u32 max_antenna_gain;
> > +	u32 max_eirp;
> > +};
> > +
> > +/* These must match CRDA regdb.h reg_rule_flags. nl80211
> > + * must also be synced. */
> 
> I think we should use the internal flags directly in nl80211 and have
> nl80211 use flag-attributes in a nested flags attribute (see how monitor
> flags work) and not rely on any shared bit meanings with userspace.

Sounds good to me.

> > +struct ieee80211_reg_rule {
> > +	struct ieee80211_freq_range freq_range;
> > +	struct ieee80211_power_rule power_rule;
> > +	u32 flags;
> > +};
> > +
> > +struct ieee80211_regdomain {
> > +	u32 n_reg_rules;
> > +	int pgp_signature_check;
> > +	char alpha2[2];
> > +	struct ieee80211_reg_rule reg_rules[];
> 
> Make that a pointer instead so we can declare the array and point to it
> and use ARRAY_SIZE().

Alright.

  Luis
