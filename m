Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41516 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbXDHWZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 18:25:29 -0400
Message-ID: <46196C03.4070003@lwfinger.net>
Date: Sun, 08 Apr 2007 17:26:11 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081135.33106.flamingice@sourmilk.net>
In-Reply-To: <200704081135.33106.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 08 April 2007 01:04, Larry Finger wrote:
>> In mac80211 the 'qual' and 'level' values are interchanged. The patch also
>> places the 'qual' value on a 0 - 100 scale and calculated using the formula
>> contained in iwlib.
>>
> NACK. Qual (arbitrary signal quality) and level (RSSI) values are correct and 
> userspace is responsible for scaling any statistics values.

I disagree. For the wireless extensions output, the maximum values are set implicitly in the
iw_range struct. In addition, the level is always in dBm (a negative number), whereas the RSSI is an
arbitrary positive number. Because the maximum value is driver dependent, it must be specified when
the driver initializes the MAC layer.

In any case, the current code is broken. Without my patch, an iwconfig command with bcm43xx-mac80211
produces the line:

Link Quality=216/146  Signal level=-197 dBm  Noise level=-63 dBm

We could argue about the Link Quality, although the x/146 looks pretty strange. The Signal level of
-197 dBm is impossible. With my patch, the same version of bcm43xx gets the line

Link Quality=90/100  Signal level=-36 dBm  Noise level=-69 dBm

That Signal level matches what comes from both bcm43xx-softmac and the Windows driver running under
ndiswrapper.

Larry


