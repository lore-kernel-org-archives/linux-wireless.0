Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30138 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0I0Kux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:50:53 -0400
Subject: Re: [PATCH 07/25] wl1271: Change supported channel order for a
 more optimal scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
In-Reply-To: <1285577334.4043.1.camel@jlt3.sipsolutions.net>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-8-git-send-email-luciano.coelho@nokia.com>
	 <1285577334.4043.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 13:50:31 +0300
Message-ID: <1285584631.5768.73.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 10:48 +0200, ext Johannes Berg wrote:
> On Mon, 2010-09-27 at 11:37 +0300, Luciano Coelho wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The mac80211 inserts channels into a scan request in the same order the driver
> > registers them. Use this fact to optimize scan by ordering the channels so
> > that adjacent channels don't get scanned consecutively.
> 
> Cute, but not really ...
> 
> First of all, iw will also report channels in this order, and that's
> just weird.
> 
> Secondly, if you pass any channels to scan manually (say with iw), this
> assertion is no longer true -- cfg80211 will actually _sort_ the
> channels in that case to make sure there are no duplicates.
> 
> So you really shouldn't be doing this.

Indeed, thanks for pointing out.

This was a shortcut that seemed so easy to follow that we couldn't
resist.

I think we can release this patch as is, because it already helps in
some cases.  And we'll come with a proper and generic solution in
mac80211/cfg80211 soon.

-- 
Cheers,
Luca.

