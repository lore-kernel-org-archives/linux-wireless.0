Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46924 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbdBMTVa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 14:21:30 -0500
Subject: Re: VHT 160Mhz and nss related config.
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
 <1486969571.5142.3.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d53a8fac-b4e0-2fb2-c1e1-c537a2c5e8aa@candelatech.com> (sfid-20170213_202133_358839_FCF4A81A)
Date: Mon, 13 Feb 2017 11:21:29 -0800
MIME-Version: 1.0
In-Reply-To: <1486969571.5142.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2017 11:06 PM, Johannes Berg wrote:
> On Fri, 2017-02-10 at 14:58 -0800, Ben Greear wrote:
>> So, it appears that the ath10k QCA9984 4x4 160Mhz chip can do 4x4
>> MIMO at VHT80, but
>> it can do only 2x2 MIMO at VHT160/80+80.
>>
>> When configuring a peer, we need to tell the firmware the number of
>> spatial streams
>> of the peer at VHT160 and at VHT80 and lower.  They are not the same
>> value.
>>
>> I cannot think of any standard way to get this information based on
>> VHT capabilities and such.  Currently, one could just assume VHT160
>> NSS is 1/2 of the VHT80 NSS, but that is unlikely to be true for all
>> vendors.
>
> This was recently added to the VHT capabilities in the spec, see Table
> 9-250 in 802.11-2016.
>
> johannes
>

I don't have that spec...maybe you could post a patch that adds that flag
and/or other fields to the appropriate header files?  I can attempt to
add support to ath10k after that...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
