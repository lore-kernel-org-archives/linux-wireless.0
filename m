Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:2963 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYJ3LiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 07:38:05 -0400
Received: by ug-out-1314.google.com with SMTP id 39so888166ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 04:38:03 -0700 (PDT)
Message-ID: <49099C8E.9000303@gmail.com> (sfid-20081030_123811_672326_BF803FF6)
Date: Thu, 30 Oct 2008 11:37:50 +0000
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] don't use net/ieee80211.h
References: <1225243531.1369.18.camel@johannes.berg>	 <490880EA.9090207@gmail.com> (sfid-20081029_162811_514174_02C4E1A0) <1225363138.3690.13.camel@johannes.berg>
In-Reply-To: <1225363138.3690.13.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2008-10-29 at 15:27 +0000, Dave wrote:
> 
>>> -static inline u8 *orinoco_get_ie(u8 *data, size_t len,
>>> -				 enum ieee80211_mfie eid)
>>> +static inline u8 *orinoco_get_ie(u8 *data, size_t len, u8 eid)
>> Would it be better to change to enum ieee80211_eid here?
> 
> Not sure. You could very well use it to find arbitrary IEs that don't
> have constants, or find dynamic ones based on a u8 variable. I don't
> really care, up to you, which would you prefer?

I don't expect orinoco to be doing anything non-standard with IE's, so
anything we want should be available from the enum. And I like the extra
type checking. So I'd go with the enum if you don't mind.

>>> @@ -839,7 +838,8 @@ static int orinoco_change_mtu(struct net
>>>  	if ( (new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU) )
>>>  		return -EINVAL;
>>>  
>>> -	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
>>> +	/* MTU + encapsulation + header length */
>>> +	if ( (new_mtu + ENCAPS_OVERHEAD + 24) >
>> I think that constant should be 30. I'd prefer it if we didn't use a
>> magic number here. How about sizeof(ieee80211_hdr)?
> 
> I wanted to use sizeof, but then I checked and realised the driver
> doesn't support WDS mode, so it never needs a 4-addr header format, so
> 24 is the right header size.

I'm not sure how this was originally set, and what the MTU is all
about... so I'll defer to you on this. However it might make sense to do
the change in value in a separate commit.

I had a quick reread for sanity: in orinoco_xmit we always write at
least 46 (HERMES_802_3_OFFSET) bytes of header before the payload.
Shouldn't our max MTU key off of that? It looks fishy to me.

>>> @@ -3289,7 +3289,7 @@ static int orinoco_init(struct net_devic
>>>  
>>>  	/* No need to lock, the hw_unavailable flag is already set in
>>>  	 * alloc_orinocodev() */
>>> -	priv->nicbuf_size = IEEE80211_FRAME_LEN + ETH_HLEN;
>>> +	priv->nicbuf_size = IEEE80211_MAX_FRAME_LEN + ETH_HLEN;
>> Note that this changes nicbuf_size from 2334 to 2352. I don't expect any
>> problems, and haven't noticed anything while running my version with
>> this change.
> 
> Oh. I wasn't aware the constants differed. What's this used for?

I think this just allocates the hardware buffer we copy our frames into
for transmission. It looks like the hw buffer can go up to 4k (except on
buggy Symbol firmware).


Thanks,

Dave.
