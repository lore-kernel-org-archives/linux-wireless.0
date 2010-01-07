Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:35879 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0AGPrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 10:47:06 -0500
Date: Thu, 7 Jan 2010 16:47:02 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211: fix queue selection for packets injected via monitor interface
Message-ID: <20100107154702.GN1735@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local> <20100107140137.GA32125@mail.wantstofly.org> <43e72e891001070745i334b7515kf78a95d12b981b95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e891001070745i334b7515kf78a95d12b981b95@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 07, 2010 at 07:45:14AM -0800, Luis R. Rodriguez wrote:

> > Commit 'mac80211: fix skb buffering issue' added an ->ndo_select_queue()
> > for monitor interfaces which can end up dereferencing ieee802_1d_to_ac[]
> > beyond the end of the array for injected data packets (as skb->priority
> > isn't guaranteed to be zero or within [0:7]), which then triggers the
> > WARN_ON in net/core/dev.c:dev_cap_txqueue().  Fix this by always setting
> > the priority to zero on injected data frames.
> >
> > Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> 
> The other patches are for stable as well, so this should be for stable too?

Yep.  Actually, it should probably just be folded into Johannes' patch
as it is queued for stable, I think.
