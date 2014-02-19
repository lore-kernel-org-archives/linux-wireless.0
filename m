Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbaBSO4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:56:40 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v3 3/6] cfg80211: Enable GO operation on additional
 channels
Date: Wed, 19 Feb 2014 14:52:13 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0333823B5@HASMSX106.ger.corp.intel.com> (sfid-20140219_155643_489298_836A8235)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
 <20140218233852.GC14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140218233852.GC14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Note that this is a permissive approach to the FCC definitions, that
> > require a clear assessment that the device operating the AP is an
> > authorized master, i.e., with radar detection and DFS capabilities.
> 
> OK It seems here you are clarifying that the feature is only when you can
> verify the AP is DFS-capable. How can you verify that?

The assumption here is that if the AP is operating under the known regulatory restrictions, and radar detection capabilities are ONLY given as an example.
As you pointed in the previous patch, regardless of the AP regulatory constraints, if the local device thinks that the current operating channel of the AP is a radar channel this relaxation is not allowed. Will clarify this in the commit message.

> 
> > It is assumed that such restrictions are enforced by user space.
> > Furthermore, it is assumed, that if the conditions that allowed for
> > the operation of the GO on such a channel change, i.e., the station
> > interface disconnected from the AP, it is the responsibility of user
> > space to evacuate the GO from the channel.
> 
> This is a pretty important piece of information as well. Once these patches go
> in I really want to make it clear that we should update the documentation the
> wiki as noted before.
> 

Sure. 

[...]

> > + * @REGULATORY_DISABLE_RELAX_NO_IR: for devices that do not wish
> to allow the
> > + *      NO_IR relaxation, which enables transmissions on channels on which
> > + *      otherwise initiating radiation is not allowed.
> 
> Please provide an example. A read of this documentation likely cannot guess
> the available relaxations available, and this is only obvious to the reader of
> this patch series. If you are adding a Kconfig entry you can refer to it, or you
> can refer to the channel flags as pointers to further documentation.
> 

I will add a reference to the Kconfig option.

> > +config CFG80211_REG_RELAX_NO_IR
> > +	bool "cfg80211 support for NO_IR relaxation"
> > +	depends on CFG80211_CERTIFICATION_ONUS
> > +	---help---
> > +	  This option enables relaxation of the NO_IR flag. The relaxation
> > +	  allows initiating radiation on channels that are marked with the
> > +	  NO_IR flag which forbids transmissions on the channel.
> > +
> > +	  For example, enabling this option allows the operation of a P2P
> > +	  group owner on channels marked with NO_IR if there is an
> additional
> > +	  BSS interface which is connected to an AP which is assumed to be
> > +	  an authorized master, i.e., with radar detection support and DFS
> > +	  capabilities
> 
> Please use:
> 
> This option enables support for relaxation of the NO_IR flag for situations
> that certain regulatory bodies have provided clarifications on how relaxation
> can occur. This feature has an inherent dependency on userspace features
> which must have been properly tested and as such is not enabled by default.
> 
> A relaxation feature example is allowing the operation of a P2P group owner
> (GO) on channels marked with NO_IR if there is an additional BSS interface
> which associated to an AP which userspace assumes or confirems to be an
> authorized master, i.e., with radar detection support and DFS capabilities.
> 
> 

Done.

> Ilan, also extend the above with language similar to the one I provided on the
> cellular base station hints if you ended up adding a device feature capability.
> 

You mean specify that this option is enabled, drivers can still use the device specific flags to disable this?

> > diff --git a/net/wireless/chan.c b/net/wireless/chan.c index
> > 78559b5..87a9d0e 100644
> > --- a/net/wireless/chan.c
> > +++ b/net/wireless/chan.c
> > @@ -605,15 +605,77 @@ bool cfg80211_chandef_usable(struct wiphy
> > *wiphy,  }  EXPORT_SYMBOL(cfg80211_chandef_usable);
> >
> > +/*
> > + * For GO only, check if the channel can be used under permissive
> > +conditions
> > + * mandated by the some regulatory bodies, i.e., the channel is
> > +marked with
> > + * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station
> > +interface
> > + * associated to an AP on the same channel or on the same UNII band
> > + * (assuming that the AP is an authorized master).
> > + */
> > +static bool cfg80211_go_permissive_chan(struct
> cfg80211_registered_device *rdev,
> > +					struct ieee80211_channel *chan)
> > +{
> > +	struct wireless_dev *wdev_iter;
> > +
> > +	ASSERT_RTNL();
> 
> You can simplify the check that calls this by having the
> config_enabled() check here. You can also add the check for
> REGULATORY_DISABLE_RELAX_NO_IR here.

Done.

> 
> > +
> > +	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
> > +		return false;
> > +
> > +	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
> > +		struct ieee80211_channel *other_chan = NULL;
> > +		int r1, r2;
> > +
> > +		if (wdev_iter->iftype != NL80211_IFTYPE_STATION ||
> > +		    !netif_running(wdev_iter->netdev))
> > +				continue;
> > +
> > +		wdev_lock(wdev_iter);
> > +		if (wdev_iter->current_bss)
> > +			other_chan = wdev_iter->current_bss-
> >pub.channel;
> > +		wdev_unlock(wdev_iter);
> 
> Please wrap this up into a helper either for this series or after.
> Just a friendly reminder :)

Ok.

> > +
> > +		if (!other_chan)
> > +			continue;
> > +
> > +		if (chan == other_chan)
> > +			return true;
> 
> This seems to me to indicate that we have allowed here daisy chaining / trust
> on another GO who also trusted its AP. That is, we are leaving it up to the
> kernel for the above few lines of code to check if the STA was associated to
> an AP that had DFS support. How do we know the AP the STA was associated
> to was not another GO that ran through this permissive check? Is the FCC
> happy with that?
> 

This verification should be done by user space, i.e., if the station is a legacy client associated to a GO, then wpa_supplicant should not allow the GO_CONCURRENT relaxation. In addition, a GO instantiated on channel based on this relaxation should not allow connection from legacy clients ... again this should be enforced by user space. System wise this should adhere to the FCC expectations and prevent daisy chaining.

> Also to be clear, you check for IEEE80211_CHAN_GO_CONCURRENT only on
> the caller's channel, not the STA's device, is that OK ? Lets consider the case
> case of two different types of interfaces on the same system. I am aware of
> at least one
> 802.11 AP company selling devices with one 802.11 vendor as the AP and
> another as the STA. I don't consider this rare anymore now, as such please
> think about this case as well.

The property is of the channel so this should suffice. Overall, I think that the FCC definition rules are centered on the UNII bands, so the rules mandated for a given channel in a specific channel should also hold to other channels in the same UNII band. Ultimately, I would expect all channels in the same UNII band to share the same settings.

The iteration in this case is over all the interfaces of the same registered device
 
> > +
> > +		if (chan->band != IEEE80211_BAND_5GHZ)
> > +			continue;
> > +
> > +		r1 = cfg80211_get_unii(chan->center_freq);
> > +		r2 = cfg80211_get_unii(other_chan->center_freq);
> > +
> > +		if (r1 != -EINVAL && r1 == r2)
> > +			return true;
> 
> Looks good, the same concern about IEEE80211_CHAN_GO_CONCURRENT
> on the other_chan applies here.
> 

Same as above.

> > +	}
> > +
> > +	return false;
> > +}
> > +	/*
> > +	 * Under certain conditions suggested by the some regulatory bodies
> > +	 * a GO can operate on channels marked with IEEE80211_NO_IR
> > +	 * so set this flag only if such relaxations are not enabled and
> > +	 * the conditions are not met.
> > +	 */
> > +	if (iftype != NL80211_IFTYPE_P2P_GO ||
> > +	    !config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
> > +	    (wiphy->regulatory_flags & REGULATORY_DISABLE_RELAX_NO_IR)
> ||
> > +	    !cfg80211_go_permissive_chan(rdev, chandef->chan))
> 
> This is the check I was saying you could simplify by tossing the config checks
> and wiphy->regulatory_flags check there.
> 

Ok :)

> >
> >
> > +int cfg80211_get_unii(int freq)
> 
> A reference to where this is documented would be good.
> 

Done.

> > +{
> > +	/* UNII-1 */
> > +	if (freq >= 5150 && freq <= 5250)
> > +		return 0;
> > +
> > +	/* UNII-2A */
> > +	if (freq > 5250 && freq <= 5350)
> > +		return 1;
> > +
> > +	/* UNII-2B */
> > +	if (freq > 5350 && freq <= 5470)
> > +		return 2;
> > +
> > +	/* UNII-2C */
> > +	if (freq > 5470 && freq <= 5725)
> > +		return 3;
> > +
> > +	/* UNII-3 */
> > +	if (freq > 5725 && freq <= 5825)
> > +		return 4;
> > +
> > +	WARN_ON(1);
> 
> probably best to avoid that warning -- there are some
> 4 GHz channels used out there, and pretty sure we'll hit this fast.
> 

Done.

Thanks,

Ilan.
