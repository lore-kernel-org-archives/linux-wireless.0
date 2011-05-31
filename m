Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35550 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1EaD3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 23:29:45 -0400
Received: by gxk21 with SMTP id 21so1616176gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 20:29:45 -0700 (PDT)
Message-ID: <4DE460A6.6050200@lwfinger.net> (sfid-20110531_052948_884255_61CCA917)
Date: Mon, 30 May 2011 22:29:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	Mike McCormack <mikem@ring3k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192se replacing rtl8192e?
References: <1306791271.4277.39.camel@localhost>	 <4DE45D54.9050301@lwfinger.net> <1306812013.4277.89.camel@localhost>
In-Reply-To: <1306812013.4277.89.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2011 10:20 PM, Ben Hutchings wrote:
> On Mon, 2011-05-30 at 22:15 -0500, Larry Finger wrote:
>> On 05/30/2011 04:34 PM, Ben Hutchings wrote:
>>> I'm happy to see rtl8192se in Linux 3.0-rc1.  I noticed that it claims
>>> PCI device ID 10ec:8192, which is already claimed by staging driver
>>> rtl8192e.  Is it intended to replace that driver, or are there two
>>> different devices with that ID which they will distinguish in their
>>> probe functions?
>>>
>>> If is intended to replace rtl8192e, shouldn't it also claim these device
>>> IDs?
>>>
>>> 	/* Corega */
>>> 	{ PCI_DEVICE(0x07aa, 0x0044) },
>>> 	{ PCI_DEVICE(0x07aa, 0x0047) },
>>
>> The RTL8192E is a different device than the RTL8192SE, thus rtl8192se will not
>> replace rtl8192e. The way to tell them apart is the PCIe revision id. At
>> present, I don't have a method to use that info to load the correct driver, but
>> I will be working on it.
>
> It doesn't matter too much if both drivers get loaded, so long as their
> respective probe() functions fail cleanly and return -ENODEV when called
> for the wrong device.

Yes, I understand the issue and I have trial patches but no hardware for testing.

Larry

