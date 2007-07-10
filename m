Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:42218 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757411AbXGJKOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 06:14:43 -0400
Message-ID: <46935BFF.20800@warmcat.com>
Date: Tue, 10 Jul 2007 11:14:23 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Stefan Schweizer <genstef@gentoo.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Monitor mode with RTL8187
References: <59abf66e0707091451p3913ba5enf35edd934840b3cb@mail.gmail.com> <4693176F.6070407@warmcat.com> <f6vep6$n3$1@sea.gmane.org>
In-Reply-To: <f6vep6$n3$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Schweizer wrote:
> Andy Green wrote:
>> ifconfig wlan0 down
>>
>> Then after changing the mode, bring it up and set the channel.
> 
> why can it not do that automatically when issueing the mode monitor command?
> 
> Seems usability has not yet reached wireless configuration - where it is imo
> much needed.

It's really a userspace issue... libpcap could be given the primitives
so tcpdump or whatever can set the mode and bring the interface up.

On the same subject, why is scanning done by a separate app (iwlist)
from iwconfig?  Why is scanning specially modal in the stack (or even
worse the device firmware) when there are enough primitives lying around
to do it from userspace?  I guess the answer is it got started like that
and now people are using it that way changing is harder.

BTW apropos of nothing let me note that the try #13 injection patches
apply to current wireless-dev with only a single fuzz, and are available
right here:

[PATCH Try#lucky13 1/3] mac80211: Monitor mode radiotap injection docs
http://www.spinics.net/lists/linux-wireless/msg03055.html

[PATCH Try#lucky13 2/3] cfg80211: Radiotap parser
http://www.spinics.net/lists/linux-wireless/msg03056.html

[PATCH Try#lucky13 3/3] mac80211: Monitor mode radiotap-based packet
injection
http://www.spinics.net/lists/linux-wireless/msg03054.html

-Andy

