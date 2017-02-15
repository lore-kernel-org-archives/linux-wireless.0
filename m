Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33126 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdBOJgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:36:55 -0500
Received: by mail-pf0-f181.google.com with SMTP id c73so27040482pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 01:36:55 -0800 (PST)
Subject: Re: [RFC v2 3/7] ieee80211: add new VHT capability fields/parsing
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170214132208.8715-1-johannes@sipsolutions.net>
 <20170214132208.8715-4-johannes@sipsolutions.net>
 <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com>
 <1487150216.4026.18.camel@sipsolutions.net>
Cc: j@w1.fi, greearb@candelatech.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d050648f-df94-8138-b9af-1ec18ba4af28@broadcom.com> (sfid-20170215_105657_018945_7CAFD95A)
Date: Wed, 15 Feb 2017 10:36:51 +0100
MIME-Version: 1.0
In-Reply-To: <1487150216.4026.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 15-2-2017 10:16, Johannes Berg wrote:
> On Wed, 2017-02-15 at 10:08 +0100, Arend Van Spriel wrote:
>> [snip]
>>
>> Looks good to me.
> 
> Thanks for checking :)
> 
>>> +	/* not covered or invalid combination received */
>>
>> Do you want to inform about the invalid/reserved combination.
> 
> I'm not really sure what to do - we don't really want to print a
> message on something that might have been received from the peer, I
> think? Though I suppose we should return 0 for the invalid
> combinations, indicating that they're not supported.

Ah. This is all non-functional code yet, right? At least having a static
non-inline function in ieee80211.h will give build issues I would think.
Anyway, I would indeed return 0 and have caller deal with that.

Regards,
Arend
