Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36242 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1AGCpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:45:38 -0500
Message-ID: <4D267E4D.7000608@candelatech.com>
Date: Thu, 06 Jan 2011 18:45:33 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for debugfs.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-3-git-send-email-greearb@candelatech.com> <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com>
In-Reply-To: <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2011 06:30 PM, Luis R. Rodriguez wrote:
> On Thu, Jan 6, 2011 at 4:46 PM,<greearb@candelatech.com>  wrote:
>> +#define ATH9K_MAX_STATIONS 1024
>
> How about making this a Kconfig with a default to a value of the known
> (by you) max workable number of STAs that one can use on ath9k, which
> is modifiable to other values by power of two up to 1024. Advise in
> the kconfig that if more STAs are used then some issue may arise but
> should be reported (so the issue can be fixed). This way by default
> normal users (you're not normal) won't enable>  max known workable
> stable number of STAs on ath9k.

This is just for debugging at this point.  It wastes a bit of memory
when debugfs is enabled, but otherwise doesn't affect anything.  It's
not even really a problem if there are more stations than fit in
the array.

I can reproduce all my problems with < 128, so if you'd prefer
the number be smaller, that's fine with me.  I don't think it's
worth a configurable value, however.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
