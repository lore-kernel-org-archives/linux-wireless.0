Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36499 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab2CPV0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 17:26:37 -0400
Message-ID: <4F63B00A.4050904@candelatech.com> (sfid-20120316_222647_538321_B10BE2E4)
Date: Fri, 16 Mar 2012 14:26:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ath9k:  Support ethtool getstats api.
References: <1331927952-8706-1-git-send-email-greearb@candelatech.com>  <1331927952-8706-4-git-send-email-greearb@candelatech.com>  <1331931232.2504.9.camel@bwh-desktop.uk.solarflarecom.com> <1331931427.2504.12.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1331931427.2504.12.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 01:57 PM, Ben Hutchings wrote:
> On Fri, 2012-03-16 at 20:53 +0000, Ben Hutchings wrote:
>> On Fri, 2012-03-16 at 12:59 -0700, greearb@candelatech.com wrote:
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> This returns many of the values that formerly could
>>> only be obtained from debugfs.  This should be an
>>> improvement when trying to access these counters
>>> programatically.  Currently this support is only
>>> enabled when DEBUGFS is enabled because otherwise
>>> these stats are not accumulated.
>> [...]
>>
>> Given that ethtool (unlike debugfs) is itself an unconditional feature,
>> why not make this unconditional?  Is it expensive to accumulate the
>> stats?
>>
>> Please at least fix the name.
>                           ^ config option
>

The ath9k stats are currently only gathered when debugfs is enabled.

I could do some patches in the future to allow stats to always
be gathered regardless of debugfs being enabled, but since
ath9k is used on small form factor systems, there may be some
resistance to enabling that all the time.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
