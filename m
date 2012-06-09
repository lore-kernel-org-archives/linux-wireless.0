Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2FIIJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:09:12 -0400
Message-ID: <1339229344.4539.7.camel@jlt3.sipsolutions.net> (sfid-20120609_100921_479961_0FFBE125)
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Sat, 09 Jun 2012 10:09:04 +0200
In-Reply-To: <20120607191803.GA4323@pista>
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <4FD0570D.50303@qca.qualcomm.com> <20120607183820.GA2950@pista>
	 <4FD0F8A0.3000704@qca.qualcomm.com> <20120607191803.GA4323@pista>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:18 -0700, Pedersen, Thomas wrote:
> On Thu, Jun 07, 2012 at 09:53:20PM +0300, Kalle Valo wrote:
> > On 06/07/2012 09:38 PM, Pedersen, Thomas wrote:
> > >>> +	WIPHY_FLAG_SUPPORTS_RSSI_SCAN		= BIT(22),
> > >>> > >  };
> > >> > 
> > >> > Is this flag really needed? For me this looks like an optimisation more
> > >> > than a functional change. If the driver supports this, that's great and
> > >> > we can save some power. But if the driver does not support it does it
> > >> > really make any difference for the user space? Would user space act
> > >> > differently if this feature is not supported by the driver?
> > >
> > > Well, this allows cfg80211 to return an error if this feature is
> > > requested but not supported by the driver / fw.
> > 
> > But do we want to return an error when the driver doesn't support this?
> > I was thinking that driver should just ignore the attribute in that case
> > and let user space filter the results.
> > 
> > Kalle
> 
> Sure, we can just let userspace unconditionally filter the results when
> we do something like:
> 
> iw wlan0 scan rssi -40
> 
> Johannes, does this look OK to you?

I don't see a need to filter in iw, but I agree with Kalle that we
shouldn't impose any restrictions on a performance optimisation.

johannes

