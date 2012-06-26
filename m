Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-edu.ch ([195.176.176.171]:22891 "EHLO ti-edu.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab2FZMK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:10:29 -0400
From: "Michal Kudelski" <michal@idsia.ch>
Subject: Re: carl9170 driver - reducing the output power
To: "Christian Lamparter" <chunkeey@googlemail.com>
Cc: <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 14:10:25 +0200
Message-ID: <web-69401031@ti-edu.ch> (sfid-20120626_141032_449144_09D7EAA1)
In-Reply-To: <201206251933.10999.chunkeey@googlemail.com>
References: <web-69364863@ti-edu.ch>
 <201206251933.10999.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Christian,

Thank you for the response! Indeed, when I used the latest 
compat-wireless, I was able to control the output power.

Now, another question arises: what is the lowest supported 
power level? Do you have any hardware specifications of 
AR9170 that would say what is the lowest power level 
supported by the hardware?

With iw/iwconfig commands, the lowest achievable power is 
1 dbm. But I'm thinking about modifying your code in order 
to write fixed values to the corresponding registers. And 
I need to know what to write into the registers in order 
to obtain the lowest possible power :-) . I know that 
there exist wifi cards that accept -12 dbm (e.g., Intel 
Pro-Wireless 2200 with ipw2200 driver under linux), so it 
would be really nice to know what I can get with 
Atheros...

Cheers,
Michal



On Mon, 25 Jun 2012 19:33:10 +0200
  Christian Lamparter <chunkeey@googlemail.com> wrote:
> On Monday, June 25, 2012 12:38:50 PM Michal Kudelski 
>wrote:
>> Thus, my question is: is the function of changing the 
>> txpower really supported? If it is, what steps should I 
>> take to make it work? I tried with ifconfig up/down when 
>>I 
>> change the txpower, but it does not change anything. 
>>Maybe 
>> I do something wrong? Do I use the correct versions of 
>>the 
>> firmware and the driver?
> No special firmware or driver is required. Just as long
> as the driver supports the feature.  
> 
>> I've noticed a patch related to this issue, published on 
>> 2012-01-27 by Christian Lamparter. It seems that it is 
>> included in my driver version, but maybe I'm wrong and I 
>> should apply some additional patch?
>> 
>> We use NetGear WNDA3100(v1) hardware [Atheros 
>> AR9001U-(2)NG] and carl9170 driver 
>> (driverversion=3.0.0-21-generic firmware=1.9.2).
> That's probably too old. The patch you are talking about
> is not a -stable patch so it's not backported to 3.3.x
> (or older) kernels.
> 
> So, either you can upgrade to 3.4, use compat-wireless
> <http://linuxwireless.org/en/users/Download/#Getting_compat-wireless_on_Ubuntu>
> or backport the patch yourself (however, this could be 
>diffcult).
> 
> Regards,
> 	Christian

