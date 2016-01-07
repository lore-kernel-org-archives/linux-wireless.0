Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39263 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbcAGQdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:33:37 -0500
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
To: David Mosberger <davidm@egauge.net>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
 <568E913D.7050301@candelatech.com>
 <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <568E9360.3060906@candelatech.com> (sfid-20160107_173340_336533_E1AE129E)
Date: Thu, 7 Jan 2016 08:33:36 -0800
MIME-Version: 1.0
In-Reply-To: <CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2016 08:29 AM, David Mosberger wrote:
> Ben,
>
> On Thu, Jan 7, 2016 at 9:24 AM, Ben Greear <greearb@candelatech.com> wrote:
>> On 01/07/2016 08:19 AM, David Mosberger wrote:
>>>
>>> We are seeing a curious issue where WLAN connectivity sometimes
>>> gets stuck until a "wpa_cli reassociate" command is issued.
>>>
>>> At the WPA level, everything appears to be working fine)
>>> (see thread starting at
>>> http://lists.infradead.org/pipermail/hostap/2016-January/034454.html).
>>
>> I don't remember seeing you mention the driver and NIC you are using.
>>
>> I think this is likely a driver bug, so please provide that info.
>
> Sure, we're using rtl8192cu.  I started out suspecting a driver bug as
> well, but since we're processing management frames during those
> "stuck" periods just fine (see
> debug output in
> http://lists.infradead.org/pipermail/hostap/2016-January/034459.html),
> I'm not so sure anymore.  Like mac80211, we have patched rtl8192cu
> driver with current
> bug-fixes already.

I have no experience with that chip, but wifi is a tricky beast.  Could be
a power-save issue perhaps.  I assume you have sniffed to see if any frames
are going out on the air during the time of trouble?

If correct packets go out on the air and AP doesn't answer, then likely AP problem.

If pkts don't get on the air, then check to see if they at least get to
the driver.

If they don't get to the driver, then probably it is a kernel/stack issue.

If they get to the driver but not on the air, then NIC and/or it's firmware
and/or the driver is likely the culprit.

Thanks,
Ben

>
>    --david
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

