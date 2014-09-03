Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60923 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaICMAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:00:39 -0400
Message-ID: <1409745636.911.13.camel@jlt4.sipsolutions.net> (sfid-20140903_140042_136821_51C9400E)
Subject: Re: [PATCH v5 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Sep 2014 14:00:36 +0200
In-Reply-To: <E1XONJB-0005LB-O8@pannekake.samfundet.no> (sfid-20140901_104958_685196_AC8D7017)
References: <20140830184516.GA31497@sesse.net>
	 <E1XONJB-0005LB-O8@pannekake.samfundet.no>
	 (sfid-20140901_104958_685196_AC8D7017)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-08-29 at 19:38 +0200, Steinar H. Gunderson wrote:
> Linux already supports 802.11h, where the access point can tell the
> client to reduce its transmission power. However, 802.11h is only
> defined for 5 GHz, where the need for this is much smaller than on
> 2.4 GHz.
> 
> Cisco has their own solution, called DTPC (Dynamic Transmit Power
> Control). Cisco APs on a controller sometimes but not always send
> 802.11h; they always send DTPC, even on 2.4 GHz. This patch adds support
> for parsing and honoring the DTPC IE in addition to the 802.11h
> element (they do not always contain the same limits, so both must
> be honored); the format is not documented, but very simple.

The format is documented for CCX partners, I suppose, but we don't have
access to that :)

I think for some vendors shipping our stack this might become
problematic. I think it would make sense to have a Kconfig option for
this, probably hidden away under "if EXPERT" and defaulting to yes, to
enable this code, it might be something that interferes with more CCX
implementations maybe?

> +static bool ieee80211_find_cisco_dtpc(struct ieee80211_sub_if_data
> *sdata,

The return value is useless here, so it could be void?

> +                       if (pos[0] != 0x00 || pos[1] != 0x40 ||
> +                           pos[2] != 0x96 || pos[3] != 0x00) {
> +                               break;
> +                       }

Please remove those useless braces - maybe run ./scripts/checkpatch.pl?

johannes

