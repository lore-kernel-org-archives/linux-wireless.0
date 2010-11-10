Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:17261 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0KVGBl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 01:01:41 -0500
Subject: Re: [PATCH 2/2] Revert "wl1271: Change supported channel order for
 a more optimal scan"
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "geryk@ti.com" <geryk@ti.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDA83BD.2000306@ti.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1289384840-28305-2-git-send-email-juuso.oikarinen@nokia.com>
	 <4CDA7F7A.4000705@ti.com> <1289388086.2522.72.camel@wimaxnb.nmp.nokia.com>
	 <4CDA83BD.2000306@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 13:42:58 +0200
Message-ID: <1289389378.2522.78.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 12:36 +0100, ext Gery Kahn wrote:
> On 11/10/2010 01:21 PM, Juuso Oikarinen wrote:
> > On Wed, 2010-11-10 at 12:18 +0100, ext Gery Kahn wrote:
> >> On 11/10/2010 12:27 PM, juuso.oikarinen@nokia.com wrote:
> >>> From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> >>>
> >>> This reverts commit fa21c7a9e4be439e217fe72edbd39b643b643791.
> >>>
> >>> The reverted patch caused more harm than benefit.
> >>>
> >>> Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> >>>
> >> Just couple words what harm it was?
> >
> > The harm is that the supported channels are reported to user-space in
> > the order they are registered in the driver. The result of that is quite
> > messy in userspace PoV.
> >
> > -Juuso
> >
> Thank you for answer.
> 
> The reason of doing such channel sorting was channel overlapping.
> 
> Let's say for 11a (bandwidth 20MHz) it is not a problem.
> While 11g, preferred channel sorting would be 1,6,11,...
> 
> Gery

Yes, this is why we had this reordering in the first place.

One benefit of sorting channels would be to get faster results for the
whole band, as there are responses from the overlapping channels too.

Currently the the scanning code however waits for all channels to be
scanned before sending results to userspace, so this benefit is not
utilized, and removing this patch makes no difference in that sense.

To take advantage of channel reordering, some other changes are needed
too. And the reordering needs to be performed in the mac80211/cfg80211
level (I actually earlier submitted a RFC patch doing just this.)

-Juuso

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


