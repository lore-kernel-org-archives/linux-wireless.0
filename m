Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54412 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DQPoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 11:44:03 -0400
Received: by gghe5 with SMTP id e5so3139994ggh.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 08:44:03 -0700 (PDT)
Message-ID: <4F8D8FBE.7080107@lwfinger.net> (sfid-20120417_174408_481169_BB46ABE3)
Date: Tue, 17 Apr 2012 10:43:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH] wireless: rt2x00: rt{2500,73}usb.c put back duplicate
 id
References: <1334437201-12737-1-git-send-email-xose.vazquez@gmail.com> <4F89EDCC.7080302@lwfinger.net> <4F8D8882.3070004@gmail.com>
In-Reply-To: <4F8D8882.3070004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 10:13 AM, Xose Vazquez Perez wrote:
> On 04/14/2012 11:36 PM, Larry Finger wrote:
>
>> On 04/14/2012 04:00 PM, Xose Vazquez Perez wrote:
>>> put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:
>>>
>>> K7SF5D7050A ver 2xxx is rt2500
>>> K7SF5D7050B ver 3xxx is rt73
>>>
>>> <http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>
>>>
>>> Signed-off-by: Xose Vazquez Perez<xose.vazquez@gmail.com>
>
>> I did a quick look at the rt2500 driver and did not see any code
>> that detects what version chip is being read. If it is possible
>> to determine if it is ver 2xxx and not 3xxx, then the probe
>> routine should do that and return an error if the wrong driver
>> is being loaded. A similar situation arises in the Realtek PCI
>> devices. In that case, it is a PCI revision that allows a driver
>> to reject the wrong hardware.
>
> This is just a patch to return to the original situation.
> (0x050d, 0x7050) was deleted by commit 08b8099c128d601fd675b212ef8b10397706b633
> [1], and I was wrong.
>
> [1]<http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=08b8099c128d601fd675b212ef8b10397706b633>

You should not "fix" a mistake by making another. My position is that this 
should be done properly this time, otherwise users get devices that don't work 
merely because the wrong driver got loaded first. As long as there is some 
parameter available early in the load process that distinguishes the two 
devices, the probe routine needs to use it to avoid using the wrong driver.

I don't have either of these devices, thus I cannot help in that part.

Larry



