Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42571 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab1LGNja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:39:30 -0500
Date: Wed, 7 Dec 2011 19:08:00 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: Define a wrapper function for reporting
 roaming
Message-ID: <20111207133759.GA12354@chvasanth-lnx> (sfid-20111207_143936_260628_31834D6F)
References: <1323262624-30060-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323263077.3404.33.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1323263077.3404.33.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 02:04:37PM +0100, Johannes Berg wrote:
> On Wed, 2011-12-07 at 18:27 +0530, Vasanthakumar Thiagarajan wrote:
> 
> >  /**
> > + * cfg80211_roamed_bss - notify cfg80211 of roaming
> > + *
> > + * @dev: network device
> > + * @bss: entry of bss to which STA got roamed (may be %NULL)
> > + * @channel: the channel of the new AP
> > + * @bssid: the BSSID of the new AP
> > + * @req_ie: association request IEs (maybe be %NULL)
> > + * @req_ie_len: association request IEs length
> > + * @resp_ie: association response IEs (may be %NULL)
> > + * @resp_ie_len: assoc response IEs length
> > + * @gfp: allocation flags
> > + *
> > + * This is just a wrapper to notify cfg80211 of roaming event with driver
> > + * passing bss to avoid a race in timeout of the bss entry. It should be
> > + * called by the underlying driver whenever it roamed from one AP to another
> > + * while connected. Drivers which have roaming implemented in firmware
> > + * may use this function to avoid a race in bss entry timeout where the bss
> > + * entry of the new AP is seen in the driver, but gets timed out by the time
> > + * it is accessed in __cfg80211_roamed() due to delay in scheduling
> > + * rdev->event_work. Returns 0 upon success. Driver has to release a reference
> > + * to bss with cfg80211_put_bss() when the return value is non-zero.
> > + */
> 
> That calling convention is strange. Either make the function responsible
> for it, nor not, but having to do the return value dance is not very
> useful.

Ok, thanks.

Vasanth
