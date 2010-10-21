Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:55366 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0JUXrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 19:47:05 -0400
Received: from smtp05.web.de  ( [172.20.4.166])
	by fmmailgate03.web.de (Postfix) with ESMTP id 8FC151684AD14
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 01:47:03 +0200 (CEST)
Received: from [77.12.214.88] (helo=[10.48.0.23])
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #24)
	id 1P94qd-0007J4-00
	for linux-wireless@vger.kernel.org; Fri, 22 Oct 2010 01:47:03 +0200
Message-ID: <4CC0D0F6.4080507@web.de>
Date: Fri, 22 Oct 2010 01:47:02 +0200
From: Lee <lee-in-berlin@web.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication
 (2.6.36-, rt73usb)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I noticed a bug (details later) in Linus' git tree, which wasn't there in 
2.6.35.7. So I went on to bisect the bug. 12 compiles and reboots later, I 
could narrow it down to this commit:

# bad: [05318bc905467237d4aa68a701f6e92a2b332218] Merge branch 'master' of 
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6

Unfortunately, I couldn't further bisect down wireless-next, because all three 
commits I picked were unworkable (bringing down an interface caused the kernel 
to oops, which made my test case impossible).

The test case is as follows: I have eth0 and wlan0 (the interface to an 
rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I 
try to connect with a client to my hostapd AP, I can successfully 
authenticate, but all further packets don't reach the interface of the AP.

However, I can see broadcast packets *from* the AP on my client, but not the 
other way round (DHCP requests from client to AP). To make sure the bug was 
not specific to broadcast packets, I manually set an IP on my client and tried 
to ping the AP, but those packets didn't come through, either.

Right now I'm a bit clueless on how to get to the root of this bug, so any 
help is appreciated.

Regards,
Lee
