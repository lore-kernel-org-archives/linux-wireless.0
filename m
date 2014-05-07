Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37856 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGMlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:41:06 -0400
Message-ID: <536A29E0.4030208@candelatech.com> (sfid-20140507_144110_754167_4F98222A)
Date: Wed, 07 May 2014 05:41:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: How to configure monitor devices for HT80?
References: <5367E13C.2020208@candelatech.com>	  (sfid-20140505_211155_884363_141E505C) <1399317771.22235.23.camel@jlt4.sipsolutions.net>	 <53692240.5010001@candelatech.com> <1399453264.10517.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399453264.10517.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/07/2014 02:01 AM, Johannes Berg wrote:
> On Tue, 2014-05-06 at 10:56 -0700, Ben Greear wrote:
>
>> But, it seems if I have another vif up, it will fail, even if that
>> vif is (should be?) using the exact same frequency.
>>
>> ./local/sbin/iw phy wiphy0 interface add moni0 type monitor
>> ./local/sbin/ip link set dev moni0 up
>> ./local/sbin/iw dev moni0 set freq 5180 80 5210
>> -> yields error:
>> command failed: Device or resource busy (-16)
>
> You can't set the monitor frequency if you're using the hardware for
> something else already. We could potentially allow that if the chandefs
> are compatible, but that's getting into really messy territory so I'm
> not sure I want to go there - if for example the other interface
> switches bandwidth or even channel the monitor would usually simply
> follow around.

Ok, as long as I know why then the failure is not so concerning.

Another question:  if I create a monitor interface first, and
successfully set it's frequency, what do I need to do to allow
a station to move to a different frequency later?

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
