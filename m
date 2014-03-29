Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:52783 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaC2Sn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2014 14:43:59 -0400
Received: by mail-yk0-f172.google.com with SMTP id 200so4857064ykr.31
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2014 11:43:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5336D767.7050304@meshcoding.com>
References: <773DB8A82AB6A046AE0195C68612A31901734186@sbs2003.acksys.local>
 <773DB8A82AB6A046AE0195C68612A31901734187@sbs2003.acksys.local>
 <20140328132204.GB18560@localhost> <5336D767.7050304@meshcoding.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Sat, 29 Mar 2014 22:43:38 +0400
Message-ID: <CAHNKnsSWBLhjsbByPz4hG5M2YY7AtG6qtEaXDnQF2W+ts1Qr2g@mail.gmail.com> (sfid-20140329_194415_227536_BE2152D4)
Subject: Re: TR: [RFC] 802.11s bitrate correction in airtime metric calculation
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	open80211s <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-03-29 18:23 GMT+04:00 Antonio Quartulli <antonio@meshcoding.com>:
> Hello,
>
> On 28/03/14 14:22, Bob Copeland wrote:
>> On Fri, Mar 28, 2014 at 11:15:06AM +0100, Cedric VONCKEN wrote:
>>> Hi all,
>>>
>>> I am currently using 802.11s for a project using openWrt mesh portals.
>>> All mesh points use 802.11a (non HT) and minstrel. Airtime metric uses a
>>> "rate"
>>> which is ultimately computed using sta->last_tx_rate from minstrel.
>>>
>>> This last_tx_rate is also updated by minstrel attempts at lower and
>>> higher speeds. Even if these occasional attempts are outnumbered by
>>> frames at max_tp_rate[0], they cause unexpected airtime metric
>>> variations resulting in unneeded mesh path changes.
>>> My idea is to use max_tp_rate[0] (from minstrel) instead. This rate is
>>> not subject to minstrel attempts and directly reflects the speed used
>>> for the vast majority of the frames.
>>
>> Interesting -- I tried this exact thing once before, but got mixed results
>> in my testing.
>>
>> Can you share your testing strategy?
>>
>> It's true that last_tx_rate is sub-optimal here, but I feel like using
>> max_tp_rate directly is a layering violation.  Many rate controllers
>> won't have that concept, and some rate controllers will exist entirely
>> in firmware.  So I think perhaps fixing the concept of "last_tx_rate" or
>> adding a new "best_tx_rate" field that excludes probes and such might be
>> the way forward, rather than calling into the rate controllers.
>>
>
> Some time ago I raised a similar problem when trying to extract a
> reasonable value from the RC algorithm to be used in a new metric for
> batman-adv.
>
> I wanted something that could represent the "available bandwidth", so
> the first idea was to use "max_tp_rate" and its probability of success.
> Unfortunately these two values are meaningful if we are using minstrel,
> but mostly meaningless for other RC algorithms, therefore nobody (in
> particular Johannes) liked the idea of "exporting" the two separately.
>
> Then we realised that a sort of "estimated throughput/bandwidth" is
> something that any RC algorithm can somewhat provide and that can
> therefore be exported by a generic RC API[1].
>
> The "expected throughput" should be computed by minstrel as the product
> of the max_tp_rate and its probability of success.
>
> I talked a bit about this with Bob on IRC and it seems that this could
> be a viable approach for 11s as well (even if it requires a
> rearrangement of the way ALM is computed).
>
Seems that this could be useful even for end user if we export these
data via NL80211, since last_tx_rate is quite meaningless when using
minstrel rate control.

-- 
BR,
Sergey
