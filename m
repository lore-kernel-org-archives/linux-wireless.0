Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35519 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752818AbcK3JV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 04:21:59 -0500
Received: by mail-pg0-f41.google.com with SMTP id p66so80265488pga.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 01:21:59 -0800 (PST)
Subject: Re: [RFC V2 1/5] nl80211: allow reporting RTT information in scan
 results
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479388726-3288-2-git-send-email-arend.vanspriel@broadcom.com>
 <1480343530.8107.51.camel@sipsolutions.net>
 <6f75b940-d0b1-1e9c-f286-3923089d202d@broadcom.com>
 <1480494148.9990.33.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4ae03959-3da5-1581-dacd-30c3b56b4b46@broadcom.com> (sfid-20161130_102205_554760_B1294D31)
Date: Wed, 30 Nov 2016 10:21:55 +0100
MIME-Version: 1.0
In-Reply-To: <1480494148.9990.33.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-11-2016 9:22, Johannes Berg wrote:
> On Mon, 2016-11-28 at 21:07 +0100, Arend Van Spriel wrote:
>>  
>> I was wondering about the meaning of the term "parent_bssid". Given
>> your remark it means something else than my guess. I actually meant
>> the distance to the AP indicated by this BSS. Our gscan code obtains
>> the gscan results from firmware and in that API it has RTT info. 
> 
> Oh, ok. Right, that's unrelated to the parent_bssid.
> 
> I do wonder how it'd even be possible to *determine* this though?
> Perhaps by the ACK timing, assuming it's precise on the AP?

There is 11v, 11mc, and some proprietary flavor we call 1-way TOF.
However, I do not expect those measurements to be done during the scan
procedure as it would affect duration of the whole scan exercise.

>> However, recent testing revealed those fields are always coming up
>> with zero values :-(
> 
> Heh :-)
> 
>> So right now I am not sure if we need this extension.
> 
> FWIW, we don't seem to have it.

I will drop this in next RFC round.

Regards,
Arend
