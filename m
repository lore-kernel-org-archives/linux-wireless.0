Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2KIVRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 16:17:14 -0500
Message-ID: <1352495862.30006.1.camel@jlt4.sipsolutions.net> (sfid-20121109_221719_702580_AAD693CD)
Subject: Re: [PATCH] nl/cfg80211: advertise OBSS scan offload capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 09 Nov 2012 22:17:42 +0100
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083BBD703C@SC-VEXCH1.marvell.com>
References: <1352415240-5168-1-git-send-email-bzhao@marvell.com>
	 <1352478572.9238.14.camel@jlt4.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083BBD703C@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-09 at 12:18 -0800, Bing Zhao wrote:

> > > New flag is added to inform userspace that this driver doesn't
> > > internally perform OBSS scan. It can use this feature available
> > > in userspace application.
> > 
> > Shouldn't that be a little more precisely worded? Most drivers already
> > expect wpa_s to do this, but apparently the assumption was that without
> > the flag, full-MAC drivers, i.e. drivers implementing the nl80211
> > connect API (rather than auth/assoc) do it themselves?
> 
> That's right.
> 
> > 
> > Or maybe mac80211 should just set the flag?
> 
> Currently wpa_s checks WPA_DRIVER_FLAGS_SME flag for OBSS scan.
> Since WPA_DRIVER_FLAGS_SME bit is set for mac80211, it's unnecessary to set this new flag.
> 
> Or, are you suggesting that we should set the new flag in mac80211
> (and all drivers that need OBSS scan feature in wpa_s) and replace
> WPA_DRIVER_FLAGS_SME check with the new flag?

I don't think that can be done, for the simple reason that wpa_s should
continue to work on older kernels.

Thus, I guess that wpa_s is going to continue with the assumption that
auth/assoc API implies also doing OBSS in wpa_s (which is a fair
assumption), but then I think we should simply change the documentation
of this new feature flag to indicate that it's interesting only in the
case of a driver that has connect API.

johannes

