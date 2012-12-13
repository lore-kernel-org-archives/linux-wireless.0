Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52396 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2LMPui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 10:50:38 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1908085lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 07:50:37 -0800 (PST)
Message-ID: <50C9F944.6060506@gmail.com> (sfid-20121213_165042_258424_FFCB86A0)
Date: Thu, 13 Dec 2012 16:50:28 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH] wireless: rt2x00: rt{2500,73}usb.c put back duplicate
 id
References: <1334437201-12737-1-git-send-email-xose.vazquez@gmail.com> <4F89EDCC.7080302@lwfinger.net> <4F8D8882.3070004@gmail.com> <4F8D8FBE.7080107@lwfinger.net>
In-Reply-To: <4F8D8FBE.7080107@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 05:43 PM, Larry Finger wrote:
> On 04/17/2012 10:13 AM, Xose Vazquez Perez wrote:
>> On 04/14/2012 11:36 PM, Larry Finger wrote:
>>
>>> On 04/14/2012 04:00 PM, Xose Vazquez Perez wrote:
>>>> put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:
>>>>
>>>> K7SF5D7050A ver 2xxx is rt2500
>>>> K7SF5D7050B ver 3xxx is rt73
>>>>
>>>> <http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>
>>>>
>>>>
>>>> Signed-off-by: Xose Vazquez Perez<xose.vazquez@gmail.com>
>>
>>> I did a quick look at the rt2500 driver and did not see any code
>>> that detects what version chip is being read. If it is possible
>>> to determine if it is ver 2xxx and not 3xxx, then the probe
>>> routine should do that and return an error if the wrong driver
>>> is being loaded. A similar situation arises in the Realtek PCI
>>> devices. In that case, it is a PCI revision that allows a driver
>>> to reject the wrong hardware.
>>
>> This is just a patch to return to the original situation.
>> (0x050d, 0x7050) was deleted by commit
>> 08b8099c128d601fd675b212ef8b10397706b633
>> [1], and I was wrong.
>>
>> [1]<http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=08b8099c128d601fd675b212ef8b10397706b633>
>>
>
> You should not "fix" a mistake by making another. My position is that
> this should be done properly this time, otherwise users get devices that
> don't work merely because the wrong driver got loaded first. As long as
> there is some parameter available early in the load process that
> distinguishes the two devices, the probe routine needs to use it to
> avoid using the wrong driver.
>
> I don't have either of these devices, thus I cannot help in that part.

[old thread, lost on my Inbox]

Me too. I do not have any of these devices.

It should be done by someone with both devices.
