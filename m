Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33202 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1AaSpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:45:49 -0500
Message-ID: <4D470359.6050902@candelatech.com>
Date: Mon, 31 Jan 2011 10:45:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Missing config_hw() in ieee80211_ibss_join?
References: <4D46FF7E.9080409@candelatech.com> <1296499385.3812.40.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296499385.3812.40.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2011 10:43 AM, Johannes Berg wrote:
> On Mon, 2011-01-31 at 10:29 -0800, Ben Greear wrote:
>> The method ieee80211_ibss_join can change the operating channel,
>> but I don't see anywhere that it calls config_hw to flush the
>> changes into the kernel.
>>
>> Should we add such a call?
>
> I don't think so -- it doesn't actually really join until it has scanned
> first etc.?

Ok, good enough for me.  I don't think this will cause any problems
with my scan-on-channel logic, but it looked a bit strange while
I was auditing the oper-channel related code.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

