Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50581 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2KZS1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 13:27:51 -0500
Message-ID: <50B3B4A2.5000908@etit.tu-chemnitz.de> (sfid-20121126_192755_719483_BF3F505C)
Date: Mon, 26 Nov 2012 10:27:46 -0800
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: javier@cozybit.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 14/14] mac80211: mesh PS individually-addressed frame release
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>   <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de>  <1353145246.9543.39.camel@jlt4.sipsolutions.net>  <50ABC7D0.2030303@etit.tu-chemnitz.de> <1353926751.9488.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353926751.9488.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 02:45 AM, Johannes Berg wrote:
> On Tue, 2012-11-20 at 10:11 -0800, Marco Porsch wrote:
>
>>> This is ... strange? Can a single station really own *two* num_psp
>>> refcounts?
>>
>> Yes it can. A station can be both owner and recipient. And it would just
>> be overhead to distinguish between num_psp_owner and num_psp_recipient,
>> when in the end we only want to know if there is  any PSP ongoing at all.
>>
>> I'll change the comment to:
>> 	/* number of active PSPs (owner and recipient counted independently) */
>> 	atomic_t num_psp;
>
> Ok.
>
>>>> +	nullfunc = (struct ieee80211_hdr *) skb->data;
>>>> +	if (!eosp)
>>>> +		nullfunc->frame_control |=
>>>> +				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
>>>
>>> This seems wrong -- EOSP and moredata are orthogonal (with the
>>> restriction that "!EOSP => moredata") -- but if you just have that in
>>> the code the moredata bit won't always be set correctly.
>>
>> Imho, in the context of PSP trigger frames it does.
>> Sending a trigger frame to a mesh PS STA with no EOSP implies the start
>> of a PSP with the sender as owner -> following data. The other two
>> combinations imply that there is no more data following in that direction.
>
> The EOSP bit in a trigger frame should always be 0 unless the frame is
> also a PSP response, no?

No. That is one weird thing about the standard: the combination 
RSPI:EOSP 0:0 is seen as a MPSP trigger frame when sent towards a 
station in PS mode towards the sender. So whenever a frame should be 
sent in a non-PSP context it has to set the EOSP flag.
Another situation that sets the EOSP flag is a kind of MPSP poll: if one 
STA indicates buffered frames, the other STA can poll it with RSPI:EOSP 1:1.

> What you seem to be missing though is the case when there _is_ more
> data, but the service period has to end nonetheless, say because it was
> limited to a few packets? Nothing here seems to indicate that an MPSP
> ends only after all queued packets are transmitted, which would be a
> requirement if this was supposed to be correct.

MPSPs themselves are not defined in length by the standard.
My current mechanism always sends all packets that are buffered at the 
start of the MPSP. At the time the MPSP starts, the last 
to-be-transmitted frame is the last buffered frame.
Of course, by the time the MPSP ends, new frames may have been buffered 
in the meantime, which are not taken into account here. That would 
require additional feedback from ieee80211_tx_status which always seems 
a bit racy to me.
(In an earlier version I had something like a feedback loop with 
ieee80211_tx_status, where the 'last' frame of a MPSP would always 
trigger a re-check of the PS buffers. That allowed to have infinite 
length MPSPs as long as data is enqueued for transmission. But that 
seemed to be overly complex when something like dynamic PS state 
switching is possible and advised by the standard.)

But I see one situation where the More Data flag is indeed not set 
correctly. That is the case where I only send a single frame to a PS STA 
in a non-MPSP context when no peering is established yet. I'll fix that.

> (Btw, maybe it would be worthwhile to call all of this "MPSP" like the
> spec, not just "PSP"?)

You are right, the standard always says MPSP. Ok, I'll adopt that.

>
>> But now that you mention it... is there any interest in having that
>> function used for uAPSD? Because ieee80211_sta_ps_deliver_response sets
>> the EOSP flag during uAPSD, but does not enforce a QoS Data frame to
>> carry it. But maybe uAPSD just permits transmitting anything else than
>> QoS Data frames...
>
> Well, not really, but non-QoS frames won't happen in that case, because
> the peer will have QoS enabled. Similarly here I think, why would there
> ever be a non-QoS frame? But maybe this can happen with forwarding,
> which can't happen in the non-mesh case.

For mesh also the HWMP routing (Management) frames are transmitted in 
MPSPs. So a valid PSP would look like that:
1) QoS Null (RSPI:EOSP 0:0)
2) Mgmt frame (e.g. HWMP Path Reply)
3) QoS Null (RSPI:EOSP 0:1)
here the additional trailing Null is needed to end the MPSP. That 
scenario happens regularly when no path has been set up previously.

>>>
>>>> +		ieee80211_sta_ps_deliver_response(sta, 1, 0,
>>>> +				IEEE80211_FRAME_RELEASE_UAPSD);
>>>
>>> uAPSD?
>>>
>>> The standard *explicitly* states that ASPD is *not* supported in mesh.
>>
>> Absolutely correct. The PSP mechanism is just very similar to uAPSD,
>> though. So once the PSP is set up, the mechanisms are the same actually.
>> What do you advise? Renaming the release reason? Creating a different
>> one that is handled equally?
>
> Well so far the more-data bit seems to be handled different, although I
> argue above that you're actually not doing that correctly ;-)
>
> But I think doing different reasons could be helpful, if only to
> understand the code better.

In the last iteration of my RFC I created an own function similar to 
ieee80211_sta_ps_deliver_response. That spares adding even more 
complexity to ieee80211_sta_ps_deliver_response and allows me to keep 
the mesh PA code separated in mesh_ps.c. I don't seem to need the 
release reason then.

--Marco
