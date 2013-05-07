Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28344 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3EGQ1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 12:27:21 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v6] cfg80211: P2P find phase offload
Date: Tue, 7 May 2013 19:27:17 +0300
Message-ID: <3561208.okpkftdEFW@lx-vladimir> (sfid-20130507_182724_444664_2C8C702A)
In-Reply-To: <1367935836.8328.45.camel@jlt4.sipsolutions.net>
References: <1367235610-10375-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1367235610-10375-2-git-send-email-qca_vkondrat@qca.qualcomm.com> <1367935836.8328.45.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, May 07, 2013 04:10:36 PM Johannes Berg wrote:
> Hi,
> 
> sorry for the delay. Looks good, a few comments below.
> 
> > to perform p2p scan, wpa_supplicant:
> > - perform legacy scan, through driver's cfg80211_ops 'scan' method
> > - configure rx management filter to get probe-request and probe-response frames
> 
> Does that part make sense? Why should the supplicant be required to
> configure the filter, if the next thing is going to be
> 
> > - start p2p find via driver's cfg80211_ops start_p2p_find method
> 
> starting the p2p find? I mean, it seems that should implicitly enable
> the filter? Or is there a reason you think this command would be useful
> _without_ enabling the filter??

Packet filtering already managed by the wpa_sup; and is kind of orthogonal
to the p2p flows. Yes, wpa_sup need to assemble reasonable combinations to
make whole system work. I want wpa_sup to take care of packet filtering;
it deals with filtering within the cfg80211_rx_mgmt().

wpa_sup may have its own idea for filtering, it may be more restrictive
then just pass all probe-request and probe-response frames.

Technically it is possible to call cfg80211_mlme_register_mgmt and
cfg80211_mlme_unregister_socket, but then I need to save nlportid, and it
becomes more complicated then it is when wpa_sup takes care of filtering.

> 
> > +/**
> > + * cfg80211_p2p_find_notify_end - report p2p find phase ended
> > + * @wdev: the wireless device reporting the event
> > + * @gfp: allocation flags
> > + *
> > + * p2p find phase may be ended either unsolicited or in response to
> > + * ops->p2p_stop_find
> > + *
> > + * In any case, if @start_p2p_find from driver's struct cfg80211_ops called,
> > + * @cfg80211_p2p_find_notify_end should be eventually called
> > + */
> > +void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp);
> 
> Please clarify whether or not this should be called when a stop is
> explicitly requested by userspace. I don't think it's all that useful,
> and if required maybe cfg80211 should send the event itself instead of
> having the driver do it?

There may be delay between request from wpa_sup and actual end of p2p find.
I want wpa_sup to know when p2p find actually get finished; for timing/race
reasons.

> 
> > + * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL:
> > + * @NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL: min/max discoverable interval
> > + *	for the p2p find, multiple of 100 TUs, represented as u32
> > + *
> > + *
> 
> One blank line is enough :-)

Sure, will fix. Perhaps, I was not careful when rebasing.

> 
> > +	struct cfg80211_p2p_find_params params = {};
> 
> > +	attr = info->attrs[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL];
> > +	if (attr)
> > +		params.min_discoverable_interval = nla_get_u32(attr);
> > +
> > +	attr = info->attrs[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL];
> > +	if (attr)
> > +		params.max_discoverable_interval = nla_get_u32(attr);
> 
> Shouldn't those have better defaults than 0/0? Or should they just be
> required?

You are right: defaults, accordingly to spec, are 1 and 3; I'll fix.

> 
> > +	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", disc. int. [%d..%d]"
> > +		  ", n_channels %d",
> 
> you shouldn't break strings across lines (and in fact checkpatch
> shouldn't warn about 80 cols there, but if it does ignore it)

Sure.

> 
> johannes

Let me some 1 day to cook next version.
 
