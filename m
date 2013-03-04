Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab3CDPsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:48:13 -0500
Message-ID: <1362412079.21028.34.camel@jlt4.sipsolutions.net> (sfid-20130304_164817_570620_EC082B02)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 16:47:59 +0100
In-Reply-To: <3408094.SIuA27EmQ5@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 14:24 +0200, Vladimir Kondratiev wrote:

> Enable p2p find phase offload to the driver.
> Add methods for the struct cfg80211_ops, like
> 
> 	int	(*start_p2p_find)(struct wiphy *wiphy,
> 				  struct cfg80211_p2p_find_params *params);
> 	void	(*stop_p2p_find)(struct wiphy *wiphy);
> 
> where struct cfg80211_p2p_find_params includes info elements
> to be added for probe request and probe response frames;
> social channels etc.

We had something like this before. I think you need to specify not the
wiphy but a netdev though, to know what MAC address to use. In fact, not
a netdev but a wdev, so it can work on P2P_Device type wdevs.

Also, timings? Or is that left to the driver?

> wpa_supplicant will call these methods through nl80211.
> 
> Driver responsible for toggling between search and listen states,
> reporting probe request/response frames to the user space.
> 
> Driver/firmware may answer to the probe request frames on itself,
> in this case probe requests are still reported.

wpa_s will need to know whether or not it responded, unless you mandate
that it must respond by itself -- not sure if you should do that though?

> To satisfy requirements for 60GHz band, additional attribute 'pcp_resolution'
> shall be added to the reported frames, indicating result of the PCP resolution.
> This attribute carries result of PCP factor comparison between probe request
> and response, as defined in the spec for 60GHz. It is enum having values
> 'undefined', 'win' and 'lose'.

?

> For the 2.4GHz band devices, PCP resolution is not used and pcp_resolution
> attribute set to 'undefined'

No ... you'd just leave out the attribute instead of having a special
undefined value.

johannes

