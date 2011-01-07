Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59495 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1AGUZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:25:02 -0500
Message-ID: <4D27769A.9060706@candelatech.com>
Date: Fri, 07 Jan 2011 12:24:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH v2 3/3] ath9k: Keep track of stations for
 debugfs.
References: <1294375752-3946-1-git-send-email-greearb@candelatech.com> <20110107201204.GG21588@tux>
In-Reply-To: <20110107201204.GG21588@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 12:12 PM, Luis R. Rodriguez wrote:
> On Thu, Jan 06, 2011 at 08:49:12PM -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> The stations hold the ath_node, which holds the tid
>> and other xmit logic structures.  In order to debug
>> stuck xmit logic, we need a way to print out the tid
>> state for the stations.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> v1 ->  v2:  Use linked list instead of array.  Protect with spinlock.
>
> Again, see my comments about the # STAs limit. I think this can go in
> as a cfg80211 driver limitation which can be exposed. If you want to go
> over the supported number (known to work, safe, call it what you want)
> then a kconfig option can be used.

Either way, it's a separate patch.

The last thing I want to do is to make it harder to reproduce bugs,
so if 60 causes issues, and we made the default limit to 32,
then it just makes it that much harder for someone to reproduce
bugs and fix them (twiddle kconfig, re-compile kernel, etc).

I surely can't stop you from putting in a similar patch, but
I'm going to focus my own efforts on fixing problems I've already
found.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
