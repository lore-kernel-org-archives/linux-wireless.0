Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57466 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab0JZMpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:45:45 -0400
Subject: Re: [PATCH 1/2] wl1271: Fix scan failure detection
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288095769.2607.34.camel@wimaxnb.nmp.nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288093257.3761.59.camel@jlt3.sipsolutions.net>
	 <1288094517.2607.33.camel@wimaxnb.nmp.nokia.com>
	 <1288095526.3761.63.camel@jlt3.sipsolutions.net>
	 <1288095769.2607.34.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 15:45:03 +0300
Message-ID: <1288097103.27698.3.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 14:22 +0200, Juuso Oikarinen wrote:
> On Tue, 2010-10-26 at 14:18 +0200, ext Johannes Berg wrote:
> > On Tue, 2010-10-26 at 15:01 +0300, Juuso Oikarinen wrote:
> > > On Tue, 2010-10-26 at 13:40 +0200, ext Johannes Berg wrote:
> > 
> > > > > +	if (wl->state == WL1271_STATE_OFF) {
> > > > > +		/*
> > > > > +		 * We cannot return -EBUSY here because mac80211 will expect
> > > > > +		 * a call to ieee80211_scan_completed if we do - in this case
> > > > > +		 * there won't be any call.
> > > > > +		 */
> > > > 
> > > > ???
> > 
> > > I'll try explain what this is about. In net/wireless/sme.c you'll find
> > > this:
> > 
> > [snip]
> > 
> > so it's really about cfg80211, that explains my confusion :)
> 
> Yeah, it seems it's my confusion :/

Thanks for the patch, Juuso.  Thanks for the comment, Johannes.

I have reviewed this patch, changed the comment to cfg80211 and applied
to the wl12xx tree.

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.

