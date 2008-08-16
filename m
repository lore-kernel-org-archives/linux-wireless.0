Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36919 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYHPOA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 10:00:28 -0400
Message-ID: <48A6DD7B.4090201@lwfinger.net> (sfid-20080816_160033_358980_A618FF86)
Date: Sat, 16 Aug 2008 09:00:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808152034.46346.chunkeey@web.de> <48A6209E.1020904@lwfinger.net> <200808160421.33375.chunkeey@web.de>
In-Reply-To: <200808160421.33375.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Saturday 16 August 2008 02:34:38 Larry Finger wrote:
>> This one lasted for 4 hours. What was worse is that it crashed my
>> computer with a 1 Hz blink of the Caps Lock light when it failed. I
>> hadn't seen that before.
> 
> hmm,.... sounds like a bit of a old problem with the minipci card...
> p54_rx_frame_sent walks in the tx_queue without holding the tx_queue.lock.
> 
> However, this problem is next to impossible to trigger in the current code.
> So, a crash log from a serial console would be great?

This one locked up the machine. I don't know how long it lasted as it 
was overnight. This time, the caps lock was not blinking, but the only 
recovery was to power it off.

A serial console is not possible - no hardware. In this case, 
netconsole is no help either as it would need to use the hardware 
whose driver has already failed.

Larry

