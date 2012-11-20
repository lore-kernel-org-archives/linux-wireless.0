Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:47827 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2KTSLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 13:11:32 -0500
Message-ID: <50ABC7D0.2030303@etit.tu-chemnitz.de> (sfid-20121120_191140_875156_DC34227A)
Date: Tue, 20 Nov 2012 10:11:28 -0800
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: javier@cozybit.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 14/14] mac80211: mesh PS individually-addressed frame release
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>  <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de> <1353145246.9543.39.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353145246.9543.39.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2012 01:40 AM, Johannes Berg wrote:
> On Fri, 2012-11-16 at 22:48 -0800, Marco Porsch wrote:
>
>> +static inline bool test_and_set_psp_flag(struct sta_info *sta,
>> +					 enum ieee80211_sta_info_flags flag)
>> +{
>> +	if (!test_and_set_sta_flag(sta, flag)) {
>> +		atomic_inc(&sta->sdata->u.mesh.num_psp);
>
> This is ... strange? Can a single station really own *two* num_psp
> refcounts?

Yes it can. A station can be both owner and recipient. And it would just 
be overhead to distinguish between num_psp_owner and num_psp_recipient, 
when in the end we only want to know if there is  any PSP ongoing at all.

I'll change the comment to:
	/* number of active PSPs (owner and recipient counted independently) */
	atomic_t num_psp;

>
>> +	nullfunc = (struct ieee80211_hdr *) skb->data;
>> +	if (!eosp)
>> +		nullfunc->frame_control |=
>> +				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
>
> This seems wrong -- EOSP and moredata are orthogonal (with the
> restriction that "!EOSP => moredata") -- but if you just have that in
> the code the moredata bit won't always be set correctly.

Imho, in the context of PSP trigger frames it does.
Sending a trigger frame to a mesh PS STA with no EOSP implies the start 
of a PSP with the sender as owner -> following data. The other two 
combinations imply that there is no more data following in that direction.

>
>> +	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
>> +	drv_allow_buffered_frames(sdata->local, sta, BIT(7), 1,
>> +				  IEEE80211_FRAME_RELEASE_UAPSD, !eosp);
>
> ditto, passing !eosp definitely seems wrong
>
>> +/**
>> + * ieee80211_qos_null_append - append QoS Null as PSP trigger (if necessary)
>
> append? where? why not static?

Append to the skb queue given to the function. - I'll clarify the 
comment for that.
Not static because called from sta_info.c. I can move it there if you 
like, but I valued keeping all the mesh PS stuff in one place.

But now that you mention it... is there any interest in having that 
function used for uAPSD? Because ieee80211_sta_ps_deliver_response sets 
the EOSP flag during uAPSD, but does not enforce a QoS Data frame to 
carry it. But maybe uAPSD just permits transmitting anything else than 
QoS Data frames...

>
>> +		ieee80211_sta_ps_deliver_response(sta, 1, 0,
>> +				IEEE80211_FRAME_RELEASE_UAPSD);
>
> uAPSD?
>
> The standard *explicitly* states that ASPD is *not* supported in mesh.

Absolutely correct. The PSP mechanism is just very similar to uAPSD, 
though. So once the PSP is set up, the mechanisms are the same actually. 
What do you advise? Renaming the release reason? Creating a different 
one that is handled equally?

>
> Ok I don't really get this, need more time I guess .. also it seems
> really hacked together.

Of course it is. You should have seen it before numerous cleanup 
iterations =)

>
> johannes
>
>

