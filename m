Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41859 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYHDQ11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 12:27:27 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <6064CD72-8B4A-4F23-BCFA-4D656729E60D@holtmann.org> (sfid-20080804_182735_091275_8FD40F29)
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1217866765.1299.9.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: [RFC] cfg80211: add PM hooks
Date: Mon, 4 Aug 2008 18:27:23 +0200
References: <1217853236.4721.32.camel@johannes.berg> <99AFB2EC-AECE-419A-B014-8391E45DF6C4@holtmann.org> <1217866765.1299.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>>> +	.suspend = wiphy_suspend,
>>> +	.resume = wiphy_resume,
>>> };
>>
>> this needs to be wrapped into CONFIG_PM, because otherwise the build
>> will fail when CONFIG_PM is not enabled.
>
> I thought so too, but then I looked at include/linux/device.h

when did this got changed? And more to the point, why nobody bothered  
to remove all the CONFIG_PM and CONFIG_HOTPLUG ifdefs splattered  
around the kernel. It must be part of Greg's changes to remove class  
devices. I am not sure this is all the right approach since  
potentially it blots the kernel.

This would also means that the CONFIG_HOTPLUG for dev_uevent can go  
away.

Regards

Marcel

