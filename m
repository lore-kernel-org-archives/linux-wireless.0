Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57787 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaCCWIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 17:08:46 -0500
Message-ID: <5314FD54.7070202@candelatech.com> (sfid-20140303_230850_200030_C388C3E8)
Date: Mon, 03 Mar 2014 14:08:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: support msdu chaining.
References: <1393550452-1302-1-git-send-email-greearb@candelatech.com> <CA+BoTQnCjkgr3V4bzXW8GHJDmGRHqg6x8An__vFW5bxdub=uyw@mail.gmail.com>
In-Reply-To: <CA+BoTQnCjkgr3V4bzXW8GHJDmGRHqg6x8An__vFW5bxdub=uyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2014 11:51 PM, Michal Kazior wrote:
> On 28 February 2014 02:20,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Consolidate the list of msdu skbs into the msdu-head skb, delete the
>> rest of the skbs, pass the msdu-head skb on up the stack as normal.
>>
>> Tested with high-speed TCP and UDP traffic on modified firmware that
>> supports raw-rx.
> 
> As for an umodified firmware I expect ath10k will just re-assemble
> corrupted frames just to have them dropped by mac80211. It might be
> worth checking:
> 
>  if (chaining && fcs_error)
>     drop();

As far as I can tell, packets with bad FCS are dropped earlier in that
rx method?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

