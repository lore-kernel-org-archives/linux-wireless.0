Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49777 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3CGHKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 02:10:32 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] P2P find offload
Date: Thu, 7 Mar 2013 09:10:24 +0200
Message-ID: <1686131.738LDv7O6j@lx-vladimir> (sfid-20130307_081037_276101_0B5577E7)
In-Reply-To: <1362412079.21028.34.camel@jlt4.sipsolutions.net>
References: <3408094.SIuA27EmQ5@lx-vladimir> <1362412079.21028.34.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 04, 2013 04:47:59 PM Johannes Berg wrote:
> On Wed, 2013-02-27 at 14:24 +0200, Vladimir Kondratiev wrote:
> 
> > Enable p2p find phase offload to the driver.
> > Add methods for the struct cfg80211_ops, like
> > 
> > 	int	(*start_p2p_find)(struct wiphy *wiphy,
> > 				  struct cfg80211_p2p_find_params *params);
> > 	void	(*stop_p2p_find)(struct wiphy *wiphy);
> > 
> > where struct cfg80211_p2p_find_params includes info elements
> > to be added for probe request and probe response frames;
> > social channels etc.
> 
> We had something like this before. I think you need to specify not the
> wiphy but a netdev though, to know what MAC address to use. In fact, not
> a netdev but a wdev, so it can work on P2P_Device type wdevs.
Why do we need wdev here? It should be similar to scan, as p2p scan composed
of legacy scan and p2p find. Scan have only wiphy.
It's no problem to add wdev as well, of course. I'll add it.

> 
> Also, timings? Or is that left to the driver?
Yes, timing is up to the driver. Point is, firmware may have its reasons
when switch search/listen phases.

> 
> > wpa_supplicant will call these methods through nl80211.
> > 
> > Driver responsible for toggling between search and listen states,
> > reporting probe request/response frames to the user space.
> > 
> > Driver/firmware may answer to the probe request frames on itself,
> > in this case probe requests are still reported.
> 
> wpa_s will need to know whether or not it responded, unless you mandate
> that it must respond by itself -- not sure if you should do that though?
Same way as today wpa_s know whether driver/firmware answer probes - 
WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD. Or, should I add one more flag, like
WIPHY_FLAG_P2P_PROBE_RESP_OFFLOAD?

> 
> > To satisfy requirements for 60GHz band, additional attribute 'pcp_resolution'
> > shall be added to the reported frames, indicating result of the PCP resolution.
> > This attribute carries result of PCP factor comparison between probe request
> > and response, as defined in the spec for 60GHz. It is enum having values
> > 'undefined', 'win' and 'lose'.
> 
> ?
> 
> > For the 2.4GHz band devices, PCP resolution is not used and pcp_resolution
> > attribute set to 'undefined'
> 
> No ... you'd just leave out the attribute instead of having a special
> undefined value.
I think I was not clear here. On nl80211 - yes, just leave out attribute if it is
'undefined', I meant this 'undefined' to be used on driver API level.
> 
> johannes
> 
