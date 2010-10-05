Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50809 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0JEUgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:36:18 -0400
Message-ID: <4CAB8C39.5090201@candelatech.com>
Date: Tue, 05 Oct 2010 13:36:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH wireless-2.6] mac80211: delete AddBA response timer
References: <1286307633.3641.29.camel@jlt3.sipsolutions.net> <1286309408.3641.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286309408.3641.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 01:10 PM, Johannes Berg wrote:
> On Tue, 2010-10-05 at 21:40 +0200, Johannes Berg wrote:
>> From: Johannes Berg<johannes.berg@intel.com>
>>
>> We never delete the addBA response timer, which
>> is typically fine, but if the station it belongs
>> to is deleted very quickly after starting the BA
>> session, before the peer had a chance to reply,
>> the timer may fire after the station struct has
>> been freed already. Therefore, we need to delete
>> the timer in a suitable spot -- best when the
>> session is being stopped (which will happen even
>> then) in which case the delete will be a no-op
>> most of the time.
>>
>> I've reproduced the scenario and tested the fix.
>
> Ok, can you add:
>
> This fixes the crash reported at
> http://mid.gmane.org/4CAB6F96.6090701@candelatech.com

I can no longer reproduce that problem, so it looks fixed
to me.

The data corruption issue still exists, however...

Thanks!
Ben

>
> to the changelog?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

