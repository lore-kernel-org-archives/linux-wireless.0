Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58621 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1GANAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:00:50 -0400
Message-ID: <4E0DC4FC.2000309@candelatech.com> (sfid-20110701_150053_186426_871D9BC0)
Date: Fri, 01 Jul 2011 06:00:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in mlme.c, wireless-testing 2.6.39-wl + hacks
References: <4E0CE929.7040300@candelatech.com>	 (sfid-20110630_232253_480125_B86CAA5E) <1309469454.3873.0.camel@jlt3.sipsolutions.net>	 <4E0CECDD.7040409@candelatech.com> <1309507846.3888.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1309507846.3888.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2011 01:10 AM, Johannes Berg wrote:
>
>> Very little significant changes in this area, but I've a non-related
>> proprietary module loaded, and patches to various other parts of the
>> networking code.
>>
>> The full tree is here if you want to take a look, or I can send
>> you a full unified diff:
>>
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing-ct.ct/.git;a=summary
>
> Fair enough, I don't see anything there that would impact this bug.
>
>> Seems a tricky timing related bug, possibly we're only hitting it because
>> we're testing on an older C3 processor system that is significantly slower
>> than our normal test systems.
>
> Hm. That seems odd. I didn't see anything that lacked locking either.
>
> I think the detail that we need to investigate is what you said before:
>
>> configured for in-kernel authentication,
>> re-configure them for supplicant, let them associate, delete one of
>> them.
>
> but I don't see anything there either right now.

Well, would you accept a patch that checked for null bssid, and did a WARN_ON
and bailed out if found?  Seems little harm, and we verified that the system
otherwise remained stable with such a patch added...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
