Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:51748 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab0JZMXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:23:18 -0400
Subject: Re: [PATCH 1/2] wl1271: Fix scan failure detection
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288095526.3761.63.camel@jlt3.sipsolutions.net>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288093257.3761.59.camel@jlt3.sipsolutions.net>
	 <1288094517.2607.33.camel@wimaxnb.nmp.nokia.com>
	 <1288095526.3761.63.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 15:22:49 +0300
Message-ID: <1288095769.2607.34.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 14:18 +0200, ext Johannes Berg wrote:
> On Tue, 2010-10-26 at 15:01 +0300, Juuso Oikarinen wrote:
> > On Tue, 2010-10-26 at 13:40 +0200, ext Johannes Berg wrote:
> 
> > > > +	if (wl->state == WL1271_STATE_OFF) {
> > > > +		/*
> > > > +		 * We cannot return -EBUSY here because mac80211 will expect
> > > > +		 * a call to ieee80211_scan_completed if we do - in this case
> > > > +		 * there won't be any call.
> > > > +		 */
> > > 
> > > ???
> 
> > I'll try explain what this is about. In net/wireless/sme.c you'll find
> > this:
> 
> [snip]
> 
> so it's really about cfg80211, that explains my confusion :)

Yeah, it seems it's my confusion :/

-Juuso

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


