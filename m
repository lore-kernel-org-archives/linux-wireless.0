Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35502 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1AZV3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:29:11 -0500
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <AANLkTi=sLYCiBSjv-c1L86AJ7UtDS6+p+Pax36bLJLFb@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-3-git-send-email-arik@wizery.com>
	 <1296050470.2039.47.camel@pimenta>
	 <AANLkTi=sLYCiBSjv-c1L86AJ7UtDS6+p+Pax36bLJLFb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 23:28:44 +0200
Message-ID: <1296077324.2302.56.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 21:04 +0100, Arik Nemtsov wrote:
> >> @@ -238,6 +254,9 @@ static int wl1271_prepare_tx_frame(struct
> wl1271 *wl, struct sk_buff *skb,
> >>       if (ret < 0)
> >>               return ret;
> >>
> >> +     if (wl->bss_type == BSS_TYPE_AP_BSS)
> >> +             wl1271_tx_ap_update_inconnection_sta(wl, skb);
> >> +
> >>       wl1271_tx_fill_hdr(wl, skb, extra, info);
> >
> > Isn't there any other place where you can put this? Doesn't it add
> too
> > much overhead if you do it for every TX frame?
> 
> At this stage the STA has not been officially added yet, so this is
> just a packet. In fact it won't be added unless authenticated. When
> the STA is added its too late. If we failed to mark it in-connection,
> sometimes the FW will disconnect it.
> 
> Performance wise - its just another "compare + jmp" statement
> basically (checking the packet header). Didn't see any effect on
> throughput. 

No, it's not just a cmp + jmp.  You actually call
wl1271_tx_ap_update_inconnection_sta() and there you dig out the header
and call ieee80211_is_auth(), so you're actually parsing the header of
every frame you transmit if you're an AP.  Isn't there a way to avoid
this only when necessary?

-- 
Cheers,
Luca.

