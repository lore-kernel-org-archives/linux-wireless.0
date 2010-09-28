Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38025 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab0I1TBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 15:01:18 -0400
Message-ID: <4CA23B7A.7020602@candelatech.com>
Date: Tue, 28 Sep 2010 12:01:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  Store premable and g-mode flags in ieee80211_tx_info
References: <4CA224FF.3030103@candelatech.com>	 <1285696089.32597.0.camel@jlt3.sipsolutions.net>	 <4CA22C34.1000107@candelatech.com> <1285699998.32597.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285699998.32597.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 11:53 AM, Johannes Berg wrote:
> On Tue, 2010-09-28 at 10:56 -0700, Ben Greear wrote:
>
>> Anyway, the reason is that the driver may not know the VIF (and
>> vif may be deleted) when calling the ieee80211_rts_duration, so it needs to be stored
>> in the tx_info structure.
>
> But the vif pointer in the tx_info structure is valid during the entire
> tx() call, why would you need to call rts_duration during TX status?

Err, I guess you are right.  I was thinking it might retransmit sometime
later, but at least ath5k doesn't appear to do this.

I'll remove that part of the patch unless someone thinks of a reason
to keep it.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

