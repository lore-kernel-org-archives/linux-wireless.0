Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124Ab2HWP7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 11:59:32 -0400
Message-ID: <1345737566.4534.12.camel@jlt3.sipsolutions.net> (sfid-20120823_175936_029031_5CA26FF4)
Subject: Re: [PATCH v1] cfg80211: Support for 4-way handshake offloading for
 WPA2-Personal
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Thu, 23 Aug 2012 17:59:26 +0200
In-Reply-To: <1850661.W9RYC5ddVW@lx-vladimir>
References: <1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1343907187-6686-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1345461629.4459.10.camel@jlt3.sipsolutions.net>
	 <1850661.W9RYC5ddVW@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-23 at 18:54 +0300, Vladimir Kondratiev wrote:

> > > + * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP: This is a flag that indicates
> > > to + *	WPA supplicant that 4-way handshake has been offloaded to the
> > > firmware + *	in the AP mode.
> > > + *	In this case, WPA supplicant will provide driver with PSK for
> > > + *	start_ap()
> > 
> > I think you should use the nl80211 driver flags, not extra attributes
> > here.
> 
> I thought I need to use same approach as for other flags. All other use bit in 
> wiphy.flags and NL80211_ATTR_xxx. And reason is simple - in the NL80211, it is 
> enum, while for the driver one need to reserve a bit. This is how other flags 
> are dealt with:
> 
> 	if ((dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN) &&
> 	    nla_put_flag(msg, NL80211_ATTR_SUPPORT_IBSS_RSN))
> 		goto nla_put_failure;

Yes, but we abandoned this approach later, in favour of the nl80211
feature flags.

> I want to do some more work exploring how this offload serves in real life, 
> will submit when (if?) it will be ready.

Ok, sounds good!

johannes

