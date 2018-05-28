Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:40251 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754230AbeE1JFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 05:05:36 -0400
Received: by mail-qt0-f174.google.com with SMTP id h2-v6so14107889qtp.7
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 02:05:36 -0700 (PDT)
Subject: Re: [RFC 1/3] cfg80211: Add support for HE
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20180518140543.13620-1-luca@coelho.fi>
 <20180518140543.13620-2-luca@coelho.fi> <5B032249.2020900@broadcom.com>
 <b1d344f5f5fa2797fa5b931f019bb7f3bd18b904.camel@coelho.fi>
 <37100d5380fcea97bfc83b92d4e1d89dbf52d674.camel@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B0BC65C.5010800@broadcom.com> (sfid-20180528_110721_692628_D76E2ED1)
Date: Mon, 28 May 2018 11:05:32 +0200
MIME-Version: 1.0
In-Reply-To: <37100d5380fcea97bfc83b92d4e1d89dbf52d674.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/25/2018 9:51 PM, Luca Coelho wrote:
> Arend,
>
> On Fri, 2018-05-25 at 13:11 +0300, Luca Coelho wrote:
>> On Mon, 2018-05-21 at 21:47 +0200, Arend van Spriel wrote:
>>> On 5/18/2018 4:05 PM, Luca Coelho wrote:
>>>> @@ -781,6 +783,23 @@ int wiphy_register(struct wiphy *wiphy)
>>>>    			sband->channels[i].band = band;
>>>>    		}
>>>>
>>>> +		for (i = 0; i < sband->n_iftype_data; i++) {
>>>> +			const struct ieee80211_sband_iftype_data
>>>> *iftd;
>>>> +
>>>> +			iftd = &sband->iftype_data[i];
>>>> +
>>>> +			if (WARN_ON(!iftd->types))
>>>> +				return -EINVAL;
>>>> +			if (WARN_ON(types & iftd->types))
>>>> +				return -EINVAL;
>>>
>>> I suspected the types mask was not allowed to overlap for the
>>> iftype_data entries, but may be worth documenting that in struct
>>> ieee80211_sband_iftype_data kerneldoc.
>>
>> Sure, I'll add it.
>
> Actually, looking into this again, I'm not sure I understand your
> comment.  AFAICT this prevents the same type from appearing twice,
> right? I don't get the "not allowed to overlap"... Can you clarify?

I mean that iftdata entries can not overlap by having the same iftypes 
set in their mask. So yes, a particular iftype may only be used in a 
single entry (yet another way to say it ;-) ).

Gr. AvS
