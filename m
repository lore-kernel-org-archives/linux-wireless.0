Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47034 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab0JWT7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 15:59:09 -0400
Received: from smtp03.web.de  ( [172.20.0.65])
	by fmmailgate01.web.de (Postfix) with ESMTP id 975C9170007D0
	for <linux-wireless@vger.kernel.org>; Sat, 23 Oct 2010 21:59:07 +0200 (CEST)
Received: from [217.186.43.131] (helo=[192.168.178.24])
	by smtp03.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #24)
	id 1P9kF9-0007x3-00
	for linux-wireless@vger.kernel.org; Sat, 23 Oct 2010 21:59:07 +0200
Message-ID: <4CC33E83.4020505@web.de>
Date: Sat, 23 Oct 2010 21:58:59 +0200
From: Lee <lee-in-berlin@web.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
References: <4CC0D0F6.4080507@web.de>
In-Reply-To: <4CC0D0F6.4080507@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/10/10 01:47, Lee wrote:
> Hi everyone,
>
> I noticed a bug (details later) in Linus' git tree, which wasn't there in
> 2.6.35.7. So I went on to bisect the bug. 12 compiles and reboots later, I
> could narrow it down to this commit:
>
> # bad: [05318bc905467237d4aa68a701f6e92a2b332218] Merge branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
>
> Unfortunately, I couldn't further bisect down wireless-next, because all three
> commits I picked were unworkable (bringing down an interface caused the kernel
> to oops, which made my test case impossible).
>
> The test case is as follows: I have eth0 and wlan0 (the interface to an
> rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
> try to connect with a client to my hostapd AP, I can successfully
> authenticate, but all further packets don't reach the interface of the AP.
>
> However, I can see broadcast packets *from* the AP on my client, but not the
> other way round (DHCP requests from client to AP). To make sure the bug was
> not specific to broadcast packets, I manually set an IP on my client and tried
> to ping the AP, but those packets didn't come through, either.
>
> Right now I'm a bit clueless on how to get to the root of this bug, so any
> help is appreciated.
>
> Regards,
> Lee

I checked vanilla 2.6.36, the bug is still there. Is this a known bug? Does 
anyone care to give me some hints? Are any details needed?
