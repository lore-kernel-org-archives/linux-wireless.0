Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41143 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab3FDODo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 10:03:44 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Tue, 4 Jun 2013 17:03:40 +0300
Message-ID: <2224703.CMJXhTQ6XL@lx-vladimir> (sfid-20130604_160348_906156_A949F657)
In-Reply-To: <1370347656.8287.15.camel@jlt4.sipsolutions.net>
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <2446389.or6hSZ58yP@lx-vladimir> <1370347656.8287.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 04, 2013 02:07:36 PM Johannes Berg wrote:
> 
> > > > +struct cfg80211_p2p_find_params {
> > > 
> > > The parameters are missing the listen channel (which is needed to the listen phase).
> > 
> > There are n_channels and channels that define set of social channels
> > to operate on. It applies to both listen and search.
> 
> I don't think that's true -- you only respond on the listen channel but
> send probe requests on all the channels?

Yes, you are right - it was my mis-interpretation.
I'll add listen channel as mandatory attribute.
Indeed, spec says:

The Listen Channel shall be chosen at the beginning of the
Device Discovery and shall remain the same until P2P Discovery completes.

> 
> > > > +	attr = info->attrs[NL80211_ATTR_IE_PROBE_RESP];
> > > > +	if (attr) {
> > > > +		params.probe_resp_ie_len = nla_len(attr);
> > > > +		params.probe_resp_ie = nla_data(attr);
> > > > +	}
> > > 
> > > Is it valid to get Probe response IEs even if the driver did not report support for it?
> > 
> > One can't do p2p_find if it does not reply to P2P discovery probes.
> > It is unrelated to answering probes in AP mode - driver may leave this
> > to supplicant.
> 
> I think what Ilan is asking is whether you should reject the probe_resp
> attribute if NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD isn't set. I'm fine
> with just ignoring it (as is done now) though, might make wpa-s easier.

On Tuesday, June 04, 2013 12:10:52 PM Peer, Ilan wrote:
> But you got NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD for driver that support probe response offloading. In case that the driver does not report this flag, wpa_supplicant should understand this and not configure the driver with the probe response IEs.
> 

> BTW, in case that the probe response offload is enabled, do you think that the corresponding probe requests should be reported to the host? If this is not the case, the wpa_supplicant will not have the full list of p2p_peers.
> 

Agree with Johannes, it is easier for wpa_s if we will not be too strict here.
And, probes must be reported to the host in all cases, for wpa_s to have peer list.
Need to add comment describing this.

Thanks, Vladimir
