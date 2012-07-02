Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5147 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2GBPBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 11:01:50 -0400
From: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 60g v2 0/5] Infrastructure for 60g (802.11ad)
Date: Mon, 02 Jul 2012 18:01:42 +0300
Message-ID: <5202151.WBzXQarS2v@lx-vladimir> (sfid-20120702_170214_742154_66AE346B)
In-Reply-To: <1341233919.19642.7.camel@jlt3.sipsolutions.net>
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341233662.19642.6.camel@jlt3.sipsolutions.net> <1341233919.19642.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 02, 2012 02:58:39 PM Johannes Berg wrote:
> > > Vladimir Kondratiev (5):
> > >   wireless: add 802.11ad (60gHz band)
> > >   wireless: rate check logic for 60g
> > >   wireless: regulatory for 60g
> > >   wireless: 60g protocol constants
> > >   wireless: bitrate calculation for 60g
> >
> > 
> >
> > Applied the first four patches, but I fixed the subjects for you (this
> > time)
> 
> And I had to squash patches to make it compile without warnings after
> each patch.
> 
> Please be more careful next time.
> 
> johannes

Thanks a lot! I'll do my best.

So, now I'll focus on the last patch - bitrate calculation.

My plan is:

- add new element like NL80211_RATE_INFO_BITRATE_HT with u32 data
- change nl80211_put_sta_rate() to fill both
  NL80211_RATE_INFO_BITRATE (with u16 value)
  and NL80211_RATE_INFO_BITRATE_HT (with u32 value)
- when bitrate not fit into u16, put 0 for u16 value and fill only u32

This opens migration path for the drivers and user space tools to the
new u32 representation without breaking existing code.

Comments?

Thanks, Vladimir
