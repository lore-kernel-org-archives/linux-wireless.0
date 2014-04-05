Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52042 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbaDEGjv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 02:39:51 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andrea Merello <andrea.merello@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: Re: [PATCH 1/4] rtl8180: change module name in rtl818Xpci
References: <1396628142-14351-1-git-send-email-andrea.merello@gmail.com>
	<87bnwgif9n.fsf@purkki.adurom.net> <533FA159.4030300@lwfinger.net>
Date: Sat, 05 Apr 2014 09:39:48 +0300
In-Reply-To: <533FA159.4030300@lwfinger.net> (Larry Finger's message of "Sat,
	05 Apr 2014 01:23:21 -0500")
Message-ID: <877g74i8jv.fsf@purkki.adurom.net> (sfid-20140405_084032_018270_065FCE47)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 04/04/2014 11:14 PM, Kalle Valo wrote:
>> Andrea Merello <andrea.merello@gmail.com> writes:
>>
>>> From: Larry Finger <Larry.Finger@lwfinger.net>
>>>
>>> rtl8180 driver can handle also rtl8185 and rtl8187SE cards,
>>> however in userspace tools (network manager) it still appares
>>> as "rtl8180".
>>> This might lead the user to think the wrong driver is in use.
>>>
>>> This patch changes module name to "rtl818Xpci" that should be
>>> more explanatory.
>>>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>>
>> [...]
>>
>>> -obj-$(CONFIG_RTL8180)	+= rtl8180.o
>>> +obj-$(CONFIG_RTL8180)	+= rtl818Xpci.o
>>
>> Aren't module names usually all lower case?
>
> I do not feel strongly about this, but when I viewed the driver name
> in the KDE applet for NetworkManager, the lower-case x sort of got
> lost, whereas the upper-case one stood out. That was the reason for
> the way I wrote the patch the way I did. In a terminal, the lc value
> looks OK. 

I think it's confusing to use upper case letter in middle of a module
name. There's no way to remember that when you are typing it :)

I checked the ubuntu kernel 3.2.0-60-generic I had installed in this
machine. Out of 3311 kernel modules only 50 had upper case letters and
none of them were in drivers/net.

> Perhaps I should have made it rtl818x_pci.

That would be much more user friendly and also consistent with other
wireless drivers.

-- 
Kalle Valo
