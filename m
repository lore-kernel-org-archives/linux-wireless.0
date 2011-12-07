Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab1LGP4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:56:21 -0500
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20111207155325.GC12498@chvasanth-lnx>
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1323271070.3404.40.camel@jlt3.sipsolutions.net>
	 <20111207153052.GB12498@chvasanth-lnx>
	 <1323272248.3404.43.camel@jlt3.sipsolutions.net>
	 <20111207155325.GC12498@chvasanth-lnx>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 16:56:15 +0100
Message-ID: <1323273375.3404.44.camel@jlt3.sipsolutions.net> (sfid-20111207_165624_230414_3C9A736F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 21:23 +0530, Vasanthakumar Thiagarajan wrote:
> On Wed, Dec 07, 2011 at 04:37:28PM +0100, Johannes Berg wrote:
> > > 
> > > These warnings are added in cfg80211_roamed().
> > 
> > But this can be called directly by the driver with a NULL BSS.
> > 
> > Ohh. I see what you did, you didn't allow drivers calling this now. I
> > think you should export this function still since otherwise the race
> > windows might get tiny, but isn't actually completely closed (the first
> > get_bss() might find it, the next a millisecond later not)
> 
> I can understand the millisecond delay between cfg80211_get_bss() in driver and
> __cfg80211_roamed() as there can be delay in event_work getting
> scheduled. I don't understand the delay between driver and
> cfg80211_roamed() as the later one is direct call. Or this can be
> done later if experienced the delay?.

The computer takes time to execute the functions, so time passes, right?

johannes

