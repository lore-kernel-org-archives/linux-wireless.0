Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab0JZMSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:18:47 -0400
Subject: Re: [PATCH 1/2] wl1271: Fix scan failure detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288094517.2607.33.camel@wimaxnb.nmp.nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288093257.3761.59.camel@jlt3.sipsolutions.net>
	 <1288094517.2607.33.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 14:18:46 +0200
Message-ID: <1288095526.3761.63.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 15:01 +0300, Juuso Oikarinen wrote:
> On Tue, 2010-10-26 at 13:40 +0200, ext Johannes Berg wrote:

> > > +	if (wl->state == WL1271_STATE_OFF) {
> > > +		/*
> > > +		 * We cannot return -EBUSY here because mac80211 will expect
> > > +		 * a call to ieee80211_scan_completed if we do - in this case
> > > +		 * there won't be any call.
> > > +		 */
> > 
> > ???

> I'll try explain what this is about. In net/wireless/sme.c you'll find
> this:

[snip]

so it's really about cfg80211, that explains my confusion :)

johannes

