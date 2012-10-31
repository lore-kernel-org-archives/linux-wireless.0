Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60433 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646Ab2JaV3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 17:29:34 -0400
Message-ID: <50919830.4000800@candelatech.com> (sfid-20121031_222947_700349_658AEF28)
Date: Wed, 31 Oct 2012 14:29:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problem with drv_remove_interface when associated in 3.5.7?
References: <50917587.9010305@candelatech.com>  (sfid-20121031_200131_307985_1A302D25) <1351710420.6281.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351710420.6281.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2012 12:07 PM, Johannes Berg wrote:
> On Wed, 2012-10-31 at 12:01 -0700, Ben Greear wrote:
>> I am working on debugging the splat I reported a few days ago in a tainted
>> 3.5.7 kernel.  I've removed the tainting module, and added some debug.
>>
>> I think at least part of the problem is that drv_remove_interface can
>> be called with ifmgd->associated != NULL.
>
> That should be fixed by this patch, I hope:
>
> http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=commit;h=6863255bd0e48bc41ae5a066d5c771801e92735a
>
> johannes
>

Yes, that seems to have done the trick.

Thanks!
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

