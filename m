Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42546 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbXK1QS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:18:56 -0500
Message-ID: <474D94ED.6050403@lwfinger.net> (sfid-20071128_161859_610853_42E1C7F0)
Date: Wed, 28 Nov 2007 10:18:53 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Simple 'fix' for radio switch LED regression
References: <474d8b73.cCPCkkSQe1GIVt4H%Larry.Finger@lwfinger.net> <200711281652.05627.mb@bu3sch.de>
In-Reply-To: <200711281652.05627.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 28 November 2007 16:38:27 Larry Finger wrote:
>> Since addition of the rfkill callback, the LED associated with the off/on
>> switch on the radio has not worked because essential data in the rfkill
>> structure is missing. When that problem was fixed, difficulties in circular
>> locking surfaced. This patch fixes part of the regression in that the LED
>> is turned on if the radio switch is on at startup. Adding the code to toggle
>> the LED with the switch will be more involved and would likely miss the 2.6.24
>> window.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John and Michael,
>>
>> I was able to get the full functionality working, but with two significant
>> problems: (1) the LED toggled only with a switch off-on sequence, not with
>> each switch change and (2) the module would no longer unload cleanly due to
>> circular locking. I will be essentually off-line after today, and I hope that
>> this hack, which will make the LED appear to work correctly, can be pushed
>> into 2.6.24 as it is a fix, but has minimal code impact. Nearly all of the
>> changes are needed just to make the LED on routine available to startup.
>> Furthermore, I'm certain these changes will be needed when the complete fix
>> is available.
> 
> That completely shortcuts the "behaviour" logic.
> This patch trades one bug for another.
> It will get other people upset, because their LEDs don't work as expected anymore.
> 
> This is not a showstopper bug and there is no need to introduce dirty
> fixes that trade one bug for another.
> I'm pretty sure that this patch will break LEDs on my asus card. I didn't
> try that, though.

Please try the patch at least enough to see if it breaks the LEDs on your card. I don't think it
will. The reason that part was needed in the more complete code is that there is no key event to
turn the rfkill LED on otherwise.

I agree that this is not a showstopper, but it is annoying. It is, however, your call.

Larry
