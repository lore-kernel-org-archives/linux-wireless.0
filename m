Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60447 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0IXSRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 14:17:37 -0400
Message-ID: <4C9CEB3F.5090804@candelatech.com>
Date: Fri, 24 Sep 2010 11:17:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
References: <1285272430-9617-1-git-send-email-greearb@candelatech.com> <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com>
In-Reply-To: <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2010 10:46 AM, Nick Kossifidis wrote:
> 2010/9/23<greearb@candelatech.com>:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> +#define ATH5K_VIF_MAX  2048
>
> This is too much !!! 2048 interfaces with a total of 4 beacon buffers
> 40 rx buffers and 200 tx buffers ? Has anyone tested this ?
>
> Also think about embedded devices, we don't want to waste memory like this...
>
>> +       struct ieee80211_vif *vifs[ATH5K_VIF_MAX];

It only costs 4 or 8 bytes per pointer as long as no one actually
adds the vifs.

We've tested at least 128 on an old 1Ghz VIA system, and I'd hope for more
on more modern hardware.  I didn't think the driver should make the decision
to limit un-necessarily.

If you still think this is too much, then tell me the biggest number
you wouldn't complain about :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

