Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51135 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab0KPWwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 17:52:09 -0500
Message-ID: <4CE30B17.6090109@candelatech.com>
Date: Tue, 16 Nov 2010 14:52:07 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
References: <4CE1CEC6.2050103@candelatech.com> <20101116094512.GB21872@jm.kir.nu> <4CE2B953.9090509@candelatech.com> <20101116193156.GA32723@jm.kir.nu> <4CE2E215.1090906@candelatech.com> <20101116223658.GA5310@jm.kir.nu>
In-Reply-To: <20101116223658.GA5310@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 02:36 PM, Jouni Malinen wrote:
> On Tue, Nov 16, 2010 at 11:57:09AM -0800, Ben Greear wrote:
>> I earlier attempted to put this sharing/propagation directly into
>> the kernel (instead of -EBUSY, the kernel would just keep a list of
>> interested interfaces and then send results to all interested parties).
>>
>> However, Johannes didn't like this approach, so I'm trying to do a
>> similar thing in user-space.
>
> Johannes is not the only one having something against the kernel
> approach.. ;-)

Well, this is all good for supplicant, but same problem exists for
un-encrypted interfaces that use the built-in kernel scanning.  However,
I can carry my own patch if needed..it's still useful to get this
working with supplicant.

>>   My understanding is that you cannot
>> read scan results from the kernel for one VIF if they were initiated on another
>> VIF.  I might be wrong about that, however.  At any rate, you certainly can't
>> have two VIFS on the same phy scanning at the same time, as you get -EBUSY instead.
>> That makes wpa_supplicant take a long time to scan&  associate lots
>> of VIFS, and speeding that up is my primary goal at this point.
>
> Hmm.. Maybe I'm missing something in your patch, but it seems to be
> doing exactly what you are describing it should not be doing.. It seems

Ok, I think I mis-understood your original question.  You can read shared results
from wpa_supplicant data structures..but not directly from the kernel.

> to share the scan-done event with all interfaces that are from the same
> radio and then each interface would try to read the scan result from
> their own VIF which would be different from the one that actually
> initiated the scan.. Similarly, I did not notice any changes that would
> actually restrict requesting new scans when there is a known scan
> request pending on another interface that shares the same radio.
>
> Are these still waiting to be implemented or did I miss something in
> your patch? Anyway, they approach in the newer version looked reasonable
> to me based on what I believe you are now trying to do.

I wasn't planning to add further restrictions.  Currently, other vifs
making requests would get EBUSY, and that seems to be handled fine.
It's *possible* that someday multiple VIFs can scan simultaneously
in the kernel, so I don't think it's worth adding extra checks in supplicant.

>> One other thing I was worried about:  My patch is going to send scan results
>> to interfaces that have not successfully requested them (they may have not
>> requested at all, or they may have tried and received EBUSY).  Will that be
>> an issue?
>
> If your assumption above is correct, yes. Instead of sharing the
> scan-done event, this change should like share the scan_res from
> wpa_supplicant_get_scan_results() for all interfaces sharing the radio.

Something is needed to kick the other VIFs and tell them there are
scan results available.  That is why I put the logic in events.c
as I did.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

