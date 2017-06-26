Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57034 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdFZOPP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 10:15:15 -0400
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170621235022.25362-1-johannes@sipsolutions.net>
 <20170621235022.25362-3-johannes@sipsolutions.net>
 <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
 <1498112650.2246.1.camel@sipsolutions.net>
 <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com>
 <1498209700.2595.2.camel@sipsolutions.net>
 <89353e7a-5c61-eba3-fe34-0e7eadf7588e@candelatech.com>
 <1498474826.3318.4.camel@sipsolutions.net>
Cc: nbd@nbd.name
From: Ben Greear <greearb@candelatech.com>
Message-ID: <b01d8009-80ba-e437-02b8-5a120c2927e4@candelatech.com> (sfid-20170626_161532_576035_A8C65BD1)
Date: Mon, 26 Jun 2017 07:15:13 -0700
MIME-Version: 1.0
In-Reply-To: <1498474826.3318.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/26/2017 04:00 AM, Johannes Berg wrote:
> On Fri, 2017-06-23 at 05:27 -0700, Ben Greear wrote:
>
>> I don't understand the code well enough to know if this matters or
>> not, but the ath10k wave-2 stuff has some txq prefetch logic in the
>> firmware (and support in the driver).  But, it doesn't prefetch for
>> the mgt tid as far as I can tell.  It somehow all mostly works
>> anyway, but possibly this would have some effect on your
>> changes.  wave-1 (QCA 9880, etc) doesn't do txq prefetch at all.  Any
>> tricky changes to this logic would need to test with both chipsets.
>
> I don't think this matters. The issue at hand is that the driver still
> relies on mac80211 buffering.
>
> This *can* be solved, even in this piece of code I inserted here, but
> it'd have to keep state about the queues and then insert some hooks
> elsewhere. I'm pretty sure I can solve that, but don't have the time
> (or even hardware) to test this (easily, I have ath10k in a few
> routers, but ...).

What/how is it relying on buffering?

I'd be happy to send you plenty of ath10k mini-pcie NICs if that would help.

Just let me know.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
