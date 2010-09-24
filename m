Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65481 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab0IXTek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 15:34:40 -0400
Received: by qyk36 with SMTP id 36so1747272qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 12:34:38 -0700 (PDT)
Message-ID: <4C9CFD4E.10401@gmail.com>
Date: Fri, 24 Sep 2010 15:34:38 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: greearb@candelatech.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
References: <1285272430-9617-1-git-send-email-greearb@candelatech.com> <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com>
In-Reply-To: <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
> 2010/9/23  <greearb@candelatech.com>:
>   
>> From: Ben Greear <greearb@candelatech.com>
>>
>> +#define ATH5K_VIF_MAX  2048
>>     
>
> This is too much !!! 2048 interfaces with a total of 4 beacon buffers
> 40 rx buffers and 200 tx buffers ? Has anyone tested this ?
>
> Also think about embedded devices, we don't want to waste memory like this...
>
>   
As a sanity check, I can say I've seen AP vendors that permit 32 SSIDs 
each with a unique BSSID/encryption, etc. I've never seen any device 
that does more than that so 32 is a pretty reasonable max vif (the user 
can always change it if desired, I'm looking at you openwrt team). Just 
my 0.02$

-Rick Farina
>> +       struct ieee80211_vif *vifs[ATH5K_VIF_MAX];
>>     
>
>   

