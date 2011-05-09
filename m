Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62343 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1EIRVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 13:21:03 -0400
Received: by iyb14 with SMTP id 14so4478930iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 10:21:02 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1304959783.12202.7.camel@jlt3.sipsolutions.net>
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 13:20:56 -0400
Message-ID: <1304961656.2615.9.camel@mythtv.ewol.com> (sfid-20110509_192107_645499_9BE9F1B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 18:49 +0200, Johannes Berg wrote:
> On Mon, 2011-05-09 at 09:46 -0700, Ben Greear wrote:
> > On 05/09/2011 09:41 AM, Johannes Berg wrote:
> > > From: Johannes Berg<johannes.berg@intel.com>
> > >
> > > Multiple virtual AP interfaces can currently try
> > > to use different beacon intervals, but that just
> > > leads to problems since it won't actually be done
> > > that way by drivers. Return an error in this case
> > > to make sure it won't be done wrong.
> > 
> > I think there is no problem with having different beacon
> > intervals, as long as they are all a multiple of
> > the smallest interval and the driver does things properly.
> > 
> > I'm not sure ath9k or ath5k currently supports this properly,
> > but there was a patch floating around for a while that did
> > this for ath9k I think...
> 
> If you really care greatly about having different beacon intervals (and
> I don't see why you would?) then maybe you can think how we can enforce
> and advertise that to userspace. For now, I'm more comfortable just
> restricting it.
> 
> johannes

I posted a patch for different beacon intervals to the ath9k list last
Jan. This was to allow both a mesh (interval 1000) and ap (interval 100)
vif on the same radio. This combination seems useful, at least for me.

Steve

