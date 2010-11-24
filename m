Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52576 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0KXTGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 14:06:13 -0500
Message-ID: <4CED6212.4070500@candelatech.com>
Date: Wed, 24 Nov 2010 11:05:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>	 <20101112030035.28522.75318.stgit@localhost6.localdomain6> <1290615890.3790.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290615890.3790.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2010 08:24 AM, Johannes Berg wrote:
> On Fri, 2010-11-12 at 12:00 +0900, Bruno Randolf wrote:
>> Extend nl80211 to report an exponential weighted moving average (EWMA) of the
>> signal value. Since the signal value usually fluctuates between different
>> packets, an average can be more useful than the value of the last packet.
>>
>> This uses the recently added generic EWMA library function.
>
> John, please revert this patch ASAP -- it completely messed up some ABI,
> and the performance discussion is also not over yet.

Just so I understand:  Is the ABI issue because the netlink enum
was added in the middle, or are there other ABI problems?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
