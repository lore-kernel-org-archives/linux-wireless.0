Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12263 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbXKKUWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 15:22:09 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 07/14] mac80211: adding 802.11n configuration flows
Date: Sun, 11 Nov 2007 22:20:55 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04008799@hasmsx411.ger.corp.intel.com> (sfid-20071111_202213_639312_18624654)
In-Reply-To: <1194626925.4793.144.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will fix all code remarks, thanks.

I would skip answering for each conf_ht callback remark and just relate
to the situation in general, and why I chose to do things currently this
way.

I think you are right, and current situation of all "config" callbacks
is a bit havocked.
On one hand we have the (*config)(struct ieee80211_hw *hw, struct
ieee80211_conf *conf) which I took as a reference to config_ht, and on
the other hand we have callbacks erp_ie_changed (erp) and conf_tx (WMM).
All of them are unique in use, though in general mean one thing to low
level driver - please change HW settings as configuration has been
changed, yet non gives indication on associated/unassociated states
change...
Currently I took an approach similar to that of erp and wmm, for clarity
to low level driver, but I was truly glad to see your remark in the
bottom

> Yeah this is what I was talking about. mac80211 really sucks with all
> this "has changed stuff". Hrmm. Michael, any time-frame on rewriting
the
> interface config stuff?   

Now, I began to work on a solution for this problem (please refer to my
RFC "mac80211: [RFC] adding bss_config to low level driver ops"), in
which I wanted to unite all IE changes into one callback. If Michael is
already working on a more general solution for all "config" callbacks I
would be happy to contribute to his effort, or even continue my RFC to a
more solid patch, but until this will occur I just used similar approach
to already existing callbacks.

(and sorry for this long explanation...)

>> + *
>> + * @conf_ht: Configures low level driver with 802.11n HT data. Must
be >> atomic.

> Why is this a special callback when you pass struct ieee80211_conf?

>> +#ifdef CONFIG_MAC80211_HT
>> +	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf
*conf);
>> +#endif /* CONFIG_MAC80211_HT */

> Shouldn't you use the if_conf callback then? I know that callback
needs
> to be rewritten to indicate what parameters changed, I think Michael
> wanted to do something in that direction? Similar to my filter flags
> change in how it'd work I guess.

>> +#ifdef CONFIG_MAC80211_HT
>> +
>> +/**
>> + * ieee80211_hw_config_ht should be used only after legacy
configuration
>> + * has been determined, as ht configuration depends upon the
hardware's
>> + * HT abilities for a _specific_ band.
>> + */

> This is part of ieee80211_hw_mode right? I have patches to remove
that,
> just to be clear on it, it's band specific not in any other way "mode"
> specific. So without digging through all the details I assume you're
> registering an 802.11 G mode with HT capabilities? That's pretty
warped,
> but yeah, mac80211 works that way right now. Crap. I should hurry up
and
> get that mode -> band change ready.

>> +		conf->flags &= ~(IEEE80211_CONF_SUPPORT_HT_MODE);

>> +		conf->flags &= ~(IEEE80211_CONF_SUPPORT_HT_MODE);

> No parentheses please.

Will fix

>> +		conf->ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);

> Same here. If any of the defines need parentheses they should have
them
> built-in.

>> +		for (i = 0; i < 16; i++)
>> +			conf->ht_conf.supp_mcs_set[i] =
>> +				mode->ht_info.supp_mcs_set[i] &
>> +				  req_ht_cap->supp_mcs_set[i];

> Hmm. No define for that 16?

Will fix
 
>> +#ifdef CONFIG_MAC80211_HT
>> +	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param
&&
>> +	    local->ops->conf_ht) {
>> +		struct ieee80211_ht_bss_info bss_info;
>> +
>> +		ieee80211_ht_cap_ie_to_ht_info(
>> +				(struct ieee80211_ht_cap *)
>> +				elems.ht_cap_elem, &sta->ht_info);
>> +		ieee80211_ht_addt_info_ie_to_ht_bss_info(
>> +				(struct ieee80211_ht_addt_info *)
>> +				elems.ht_info_elem, &bss_info);
>> +		ieee80211_hw_config_ht(local, 1, &sta->ht_info,
&bss_info);
>> +	}
>> +#endif /* CONFIG_MAC80211_HT */

> Since it's part of if_conf, isn't it passed to the driver as part of
> such a call anyway later in this function? I don't see the need for
the
> special ht conf callback.
 
IMHO no, it doesn't as far as I can see in this flow.

>> +		/* check if AP changed bss inforamation */
>> +		if ((conf->ht_bss_conf.primary_channel !=
>> +		     bss_info.primary_channel) ||
>> +		    (conf->ht_bss_conf.bss_cap != bss_info.bss_cap) ||
>> +		    (conf->ht_bss_conf.bss_op_mode !=
bss_info.bss_op_mode))
>> +			ieee80211_hw_config_ht(local, 1, &conf->ht_conf,
>> +						&bss_info);

> Yeah this is what I was talking about. mac80211 really sucks with all
> this "has changed stuff". Hrmm. Michael, any time-frame on rewriting
the
> interface config stuff?

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
