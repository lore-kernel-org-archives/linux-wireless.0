Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2193 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYAXTCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 14:02:03 -0500
Date: Thu, 24 Jan 2008 13:53:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
Message-ID: <20080124185321.GB3200@tuxdriver.com> (sfid-20080124_190312_222237_247E24EC)
References: <20080120001342.25718.83669.stgit@fate.lan> <1201094475.7733.1.camel@localhost> <20080123145243.GA3129@tuxdriver.com> <1201110286.8696.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201110286.8696.10.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 23, 2008 at 07:44:46PM +0200, Jussi Kivilinna wrote:
> On Wed, 2008-01-23 at 09:52 -0500, John W. Linville wrote:
> > I would like to have this driver soon, and FWIW I just put it in the
> > Fedora Rawhide kernel last night.
> > 
> > However, I find that it does not seem to associate with WEP networks
> > on my USR5421.  I haven't had a chance to try it on open or WPA
> > networks, nor have I had a chance to debug it.  It does scan and see
> > the networks.
> > 
> > Have you tested the driver as posted?  What device(s) are you using?
> > Have you used it on encrypted networks?
> 
> I guess I should start testing more if I'm going to be maintainer,
> you're right WEP doesn't work. Unencrypted and WPA/WPA2 networks do work
> for me but not WEP. Ad-Hoc and hidden WPA networks do not work either. I
> have Buffalo WLI-U2-KG125S which should have same hardware/firmware as
> USR5421.

Overall this looks fine to me for initial merge.  I have a couple
of comments:

	-- I'm not too excited about the "Ndis_802_*" naming scheme for
	data structures, although I know you copied it from elsewhere.
	I'd like to see it changed, but I don't consider that a
	merge blocker.

	-- I foresee this driver surviving a conversion to use the
	new cfg80211 configuraiton API.  So the "rndis_wext" name may
	not be the best long-term choice.  I might suggest something
	like "rndis_wlan".  I don't see why we couldn't change that
	post-merge, although I would prefer to do that before the
	final 2.6.25 release.

So, I intend to push this upstream for 2.6.25.  Please consider making
the changes cited above, especially the name change.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
