Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:42443 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151AbXLMMJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 07:09:42 -0500
Date: Thu, 13 Dec 2007 13:09:04 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lunn <andrew@lunn.ch>, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
Message-ID: <20071213120904.GB501@lunn.ch> (sfid-20071213_121011_714452_D27A5E0C)
References: <20071212153158.GB16947@lunn.ch> <1197481426.6558.138.camel@johannes.berg> <20071212180204.GP31218@lunn.ch> <1197482969.6558.149.camel@johannes.berg> <1197504975.6558.199.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197504975.6558.199.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 01:16:14AM +0100, Johannes Berg wrote:
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Actually, I take that back.
> 
> The code is correct, as per the comment above it. Stupid wext :/
> 
>         /* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
>         if (freq->e == 0) {
>                 if (freq->m < 0) {
>                         if (sdata->type == IEEE80211_IF_TYPE_STA)
>                                 sdata->u.sta.flags |=
>                                         IEEE80211_STA_AUTO_CHANNEL_SEL;
>                         return 0;
>                 } else  
>                         return ieee80211_set_channel(local, freq->m, -1);
> 

Probably a stupid question, but are you sure the comment is correct?

I added a printk for freq->e and freq->m. When i do

iwconfig wlan0 freq 5240

i see that e = 0, m = 5240 and that with my patch in place everything
is happy. Without the patch, it passes 5240 as a channel, not a
frequency and i get an EINVAL. 

So either the comment is wrong, or the comment is correct but
something is filling in freq wrongly. 

Any ideas?

    Thanks
        Andrew

