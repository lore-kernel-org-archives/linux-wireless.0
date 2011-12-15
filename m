Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26693 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1LOEjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:39:53 -0500
Date: Thu, 15 Dec 2011 10:09:21 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] cfg80211: Define a wrapper function for reporting
 roaming
Message-ID: <20111215043919.GA9240@chvasanth-lnx> (sfid-20111215_054015_328646_B07F6A06)
References: <1323265359-1138-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323265604.3404.37.camel@jlt3.sipsolutions.net>
 <20111207135822.GA12398@chvasanth-lnx>
 <20111207150543.GA12498@chvasanth-lnx>
 <20111214185448.GB2607@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20111214185448.GB2607@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 01:54:49PM -0500, John W. Linville wrote:
> On Wed, Dec 07, 2011 at 08:35:45PM +0530, Vasanthakumar Thiagarajan wrote:
> > On Wed, Dec 07, 2011 at 07:28:24PM +0530, Vasanthakumar Thiagarajan wrote:
> > > > 
> > > > Hmm, now that I think about it more, I think the calling convention is
> > > > really strange. Why pass the channel and bssid when the BSS struct is
> > > > already known?
> > > > 
> > > > Why not make cfg80211_roamed() do the BSS lookup (which would also
> > > > reduce the race for drivers that don't use _bss()) based on the info,
> > > > and then call a cfg80211_roamed_bss() that doesn't get channel/bssid.
> > > 
> > > Sure, i'll change it. This looks better.
> > 
> > Also, i'll create a new patch instead of the next version.
> 
> Is that patch still coming?

Please drop this, a different patch (cfg80211: Fix race in bss
timeout) which fixes the same issue has been sent.

Vasanth
