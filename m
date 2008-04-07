Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:31134 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYDGOXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 10:23:54 -0400
Received: by nf-out-0910.google.com with SMTP id g13so613849nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 07:23:52 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Date: Mon, 7 Apr 2008 16:26:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <200804051931.58895.IvDoorn@gmail.com> <200804071610.47598.IvDoorn@gmail.com> <1207577549.12481.24.camel@johannes.berg>
In-Reply-To: <1207577549.12481.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804071626.37799.IvDoorn@gmail.com> (sfid-20080407_152612_604387_BA510F9D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 April 2008, Johannes Berg wrote:
> 
> > I'm not sure if I understand completely what you mean but rt61pci/rt73usb hardware does the following:
> > 
> > 1) Receive frame
> > 2) Determine key from register
> > 3) Put IV/EIV into descriptor
> > 4) Decrypt
> > 5) Notifies driver about the frame +  decryption status
> 
> Ok, so you get those out-of-band.
> 
> > Well as an alternative to adding it to tx_control, perhaps a callback function for drivers
> > could be provided? At the moment mac80211 calls:
> > 
> > ieee80211_tkip_add_iv(pos, key,
> >                       (u8) (key->u.tkip.iv16 >> 8),
> >                       (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
> >                             0x7f),
> >                       (u8) key->u.tkip.iv16);
> > 
> > to insert the IV into the skb, if the driver could get a calback function that calls the above
> > function and writes the result into a char* buffer you get the same effect except that the
> > driver can put the iv wherever it wants.
> > That way rt2x00 doesn't have to set the IEEE80211_KEY_FLAG_GENERATE_IV flag, and
> > can request the IV manually from mac80211.
> 
> No, you can't do that because the IV is already incremented at that
> point, so you wouldn't be able to perfectly match things up because
> ops->tx() need not be serialised with this due to deferring to the
> master interface.

Ok, so just to summarize (so I have everything right :) )

TX path)
rt2x00 sets the IEEE80211_KEY_FLAG_GENERATE_IV flag
grabs the IV/EIV from behind the ieee80211 header
memmove ieee80211 header to remove the IV/EIV

TX done path)
memmove ieee80211 header to make room for IV/EIV
reinsert IV/EIV behind ieee80211 header
call ieee80211_tx_status() for mac80211

RX path)
memmove ieee80211 header to make room for IV/EIV
insert IV/EIV behind ieee80211 header
call ieee80211_rx() for mac80211

Thanks,

Ivo
