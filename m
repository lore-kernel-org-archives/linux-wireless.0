Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50010 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbXITMyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 08:54:51 -0400
Message-ID: <46F26DAA.6070909@lwfinger.net>
Date: Thu, 20 Sep 2007 07:55:06 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Change loglevel of radio-enable message.
References: <200709191858.38634.mb@bu3sch.de> <46F162AF.9050903@lwfinger.net> <200709191957.59255.mb@bu3sch.de>
In-Reply-To: <200709191957.59255.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 19 September 2007 19:55:59 Larry Finger wrote:
>> Michael Buesch wrote:
>>> Also cleanup the code a bit and remove the inline.
>>>
>>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>>> @@ -2214,7 +2229,7 @@ static int b43_chip_init(struct b43_wlde
>>>  	b43_radio_turn_on(dev);
>>>  	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
>>>  	b43dbg(dev->wl, "Radio %s by hardware\n",           <========================
>>> -	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
>>> +	       dev->radio_hw_enable ? "enabled" : "disabled");
>> Shouldn't this one be b43info rather than b43dbg?
> 
> No, I think it's really only interesting to see if it changed
> in operation.
> If it doesn't work, people will press their rfkill buttons
> before even noticing this message on init. :)

I have a suggestion to simplify the whole business of hardware radio control. Why don't we
unconditionally set radio_hw_enable to one here and dispense with this message? That way, people
without the rfkill switch will never see a message and those that do will only get messages if their
switch is off, or if it is toggled.

Larry
