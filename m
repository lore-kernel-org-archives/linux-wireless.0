Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20312 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYJZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 05:25:04 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v10 2/2] cfg80211: P2P find phase offload
Date: Tue, 25 Jun 2013 12:25:00 +0300
Message-ID: <1489286.dFNgzINo7e@lx-vladimir> (sfid-20130625_112510_228350_BD0B390B)
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A01AD22795@HASMSX106.ger.corp.intel.com>
References: <1372063757-24286-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1372063757-24286-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <CB3B3D4774441E42AA3EA0E1BA8230A01AD22795@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 25, 2013 07:06:28 AM Peer, Ilan wrote:
> > + * @listen_channel: channels to listen on; not NULL
> 
> s/channels/channel/  (only a single listen channel)
Sure, thanks

<skip>
> Just to clarify something: even if the driver reports that it supports probe response offloading, can wpas choose not to use this capability and handle all the probe requests on its own (at least for debugging)? For example in case that the probe response IE len is zero, the driver can deduce the it should not respond to probe requests.

Problem is, some hardware do not let you to do so; it simply replies by itself.
NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD indicates device __can__ answer. From this,
wpa_s can conclude it may be answered by device probes that is may see or not.
It is out of scope for this commit to specify how to tell to the device to not answer
(I suppose to use debugfs for this)

> 
> > @@ -1740,6 +1748,10 @@ enum nl80211_attrs {
> > 
> >  	NL80211_ATTR_RXMGMT_FLAGS,
> > 
> > +	NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,
> > +	NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL,
> > +	NL80211_ATTR_LISTEN_FREQ,
> 
> You can use NL80211_ATTR_WIPHY_FREQ

OK, will do so.

> 
> > +TRACE_EVENT(rdev_start_p2p_find,
> > +	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
> > +		 struct cfg80211_p2p_find_params *params),
> > +	TP_ARGS(wiphy, wdev, params),
> > +	TP_STRUCT__entry(
> > +		WIPHY_ENTRY
> > +		WDEV_ENTRY
> > +		__field(u32, min_di)
> > +		__field(u32, max_di)
> > +		__field(int, n_channels)
> 
> Can you also add here the listen channel?

Sure

Thanks, Vladimir
