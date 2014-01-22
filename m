Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37785 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaAVX6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 18:58:42 -0500
Message-ID: <52E05B2E.7030200@candelatech.com> (sfid-20140123_005846_761437_19DC13C9)
Date: Wed, 22 Jan 2014 15:58:38 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211:  Extra debug info for station cleanup case.
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>  (sfid-20140122_235532_670534_4FD6E588) <1390432284.20070.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390432284.20070.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2014 03:11 PM, Johannes Berg wrote:
> On Wed, 2014-01-22 at 14:54 -0800, greearb@candelatech.com wrote:
>> -		WARN_ON_ONCE(ret != 0);
>> +		if (WARN_ON_ONCE(ret != 0))
>> +			sdata_info(sdata, "sta-info-destroy: drv-sta-state error: %i, sta: %pM\n",
>> +				   ret, sta->sta.addr);
> 
> You should put the string into the warning
> 
> WARN_ONCE(ret, "sta-info-destroy: ...", ...)

I wanted it to kernel splat once and print out a message, and after that, only print
messages.

I think your suggestion will only splat _and_ print once?

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

