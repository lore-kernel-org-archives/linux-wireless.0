Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1ALKnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 05:43:31 -0500
Subject: Re: Mesh join/leave
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294828087.16447.2.camel@mythtv.ewol.com>
References: <1294780828.2383.0.camel@mythtv.ewol.com>
	 <1294823034.3639.15.camel@jlt3.sipsolutions.net>
	 <1294828087.16447.2.camel@mythtv.ewol.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 11:44:03 +0100
Message-ID: <1294829043.3639.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 05:28 -0500, Steve Brown wrote:
> On Wed, 2011-01-12 at 10:03 +0100, Johannes Berg wrote:
> > On Tue, 2011-01-11 at 16:20 -0500, Steve Brown wrote:
> > > In testing this, the command "iw mesh0 mesh leave" doesn't stop
> > > beaconing. Beaconing continues with a null mesh id.
> > > 
> > > Is this the intended behavior?
> > 
> > No, it's not -- what driver are you using?
> > 
> > johannes
> > 
> ath9k with adapter AR9160 802.11abgn Wireless PCI Adapter (168c:2082)

No idea then, it looks like ath9k correctly handles
ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED); so
you should look at what's happening around there.

johannes

