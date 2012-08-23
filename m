Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53127 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030539Ab2HWPyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 11:54:35 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v1] cfg80211: Support for 4-way handshake offloading for WPA2-Personal
Date: Thu, 23 Aug 2012 18:54:20 +0300
Message-ID: <1850661.W9RYC5ddVW@lx-vladimir> (sfid-20120823_175439_601298_646CD86C)
In-Reply-To: <1345461629.4459.10.camel@jlt3.sipsolutions.net>
References: <1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1343907187-6686-2-git-send-email-qca_vkondrat@qca.qualcomm.com> <1345461629.4459.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 20, 2012 01:20:29 PM Johannes Berg wrote:
> On Thu, 2012-08-02 at 14:33 +0300, Vladimir Kondratiev wrote:
> > + * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA: This is a flag that
> > indicates to + *	WPA supplicant that 4-way handshake has been offloaded
> > to the firmware + *	in the STA mode.
> > + *	In this case, WPA supplicant will provide driver with PSK for
> > + *	connect()
> > + *
> > + * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP: This is a flag that indicates
> > to + *	WPA supplicant that 4-way handshake has been offloaded to the
> > firmware + *	in the AP mode.
> > + *	In this case, WPA supplicant will provide driver with PSK for
> > + *	start_ap()
> 
> I think you should use the nl80211 driver flags, not extra attributes
> here.

I thought I need to use same approach as for other flags. All other use bit in 
wiphy.flags and NL80211_ATTR_xxx. And reason is simple - in the NL80211, it is 
enum, while for the driver one need to reserve a bit. This is how other flags 
are dealt with:

	if ((dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN) &&
	    nla_put_flag(msg, NL80211_ATTR_SUPPORT_IBSS_RSN))
		goto nla_put_failure;
	if ((dev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
	    nla_put_flag(msg, NL80211_ATTR_SUPPORT_MESH_AUTH))
		goto nla_put_failure;
	if ((dev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) &&
	    nla_put_flag(msg, NL80211_ATTR_SUPPORT_AP_UAPSD))
		goto nla_put_failure;
	if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM) &&
	    nla_put_flag(msg, NL80211_ATTR_ROAM_SUPPORT))
		goto nla_put_failure;
	if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
	    nla_put_flag(msg, NL80211_ATTR_TDLS_SUPPORT))
		goto nla_put_failure;
	if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
	    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
		goto nla_put_failure;
	if ((dev->wiphy.flags & WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_STA) &&
	    nla_put_flag(msg, NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA))
		goto nla_put_failure;

> 
> And the descriptions (and flag checking!) should make it clear that it
> is only supported with the connect() API, not with the auth/assoc APIs.
> 
> > + * @WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD: Device supports 4-way handshake
> > offload.
> Use nl80211 flag directly. Also, docs are wrong:
> > +	WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_STA	= BIT(22),
> > +	WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_AP	= BIT(23),
> 
> Please also add validation that these flags are specified only when the
> correct APIs (connect/start_ap) are supported.

Agree, will add both doc and validation.

I want to do some more work exploring how this offload serves in real life, 
will submit when (if?) it will be ready.

Thanks, Vladimir.
