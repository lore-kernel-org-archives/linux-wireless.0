Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53738 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbaDHQDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 12:03:46 -0400
Message-ID: <53441D95.9000409@candelatech.com> (sfid-20140408_180357_994114_D3ECB5E7)
Date: Tue, 08 Apr 2014 09:02:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <5341F1A9.2030202@candelatech.com> <CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com> <53435F89.60500@candelatech.com> <CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com>
In-Reply-To: <CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2014 10:51 PM, Michal Kazior wrote:
> On 8 April 2014 04:31, Ben Greear <greearb@candelatech.com> wrote:
>> On 04/07/2014 02:11 AM, Michal Kazior wrote:
>>
>>> These logs are not enough. I'd love to see traces for this to see what
>>> frames are actually submitted and when tx credits are replenished.
>>>
>>> I also wonder if this can be somehow related to your FW changes to
>>> allow connecting multiple client virtual interfaces to a single AP?
>>
>>
>> I think it is unlikely due to my firmware changes...little of that touched
>> the handling of management frames.  It might very well be a basic problem in
>> either the firmware or driver when using multiple station VIFS.  I think
>> that
>> aside from my testing that code has not been used much.
>>
>> Note my followup email that problems started with patch 3/4...not sure you
>> saw that one or not.  I saw similar failure to associate & get DHCP (and
>> slow/hung user-space) without the kernel error logs.
> 
> I did get that mail. It's just that it makes little sense. Patch 3/4
> simply extends ath10k_flush() to wait for management frames. It
> shouldn't change behaviour of tx credit starvation which appears to be
> the case in the logs you provided.

Maybe this causes unexpected waits (under lock) that in turn causes other
vifs trying to come up at the same time to time out?

It seems easily reproducible, so let me know what sort of logging/tracing
you would like to see (and how to enable it if it is not trivial)
and I'll reproduce it and send you the logs.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

