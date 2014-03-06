Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from connotech.com ([76.10.176.241]:36790 "EHLO mail.connotech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaCFS7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 13:59:13 -0500
Message-ID: <5318C5A5.7060604@connotech.com> (sfid-20140306_195921_636139_5D269A67)
Date: Thu, 06 Mar 2014 18:59:49 +0000
From: Thierry Moreau <thierry.moreau@connotech.com>
MIME-Version: 1.0
To: Peter Wu <peter@lekensteyn.nl>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning
 works
References: <5316C602.8020504@connotech.com> <53175368.50009@lwfinger.net> <531777F8.5060506@connotech.com> <2046728.MUZsZig9to@al>
In-Reply-To: <2046728.MUZsZig9to@al>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/14 14:54, Peter Wu wrote:
> On Wednesday 05 March 2014 19:16:08 Thierry Moreau wrote:
>> On 03/05/14 16:40, Larry Finger wrote:
>>> Please give me the exact set of commands you use to get this problem. If
>>> possible, capture the console output. As I am currently running
>>> long-term tests of the latest version of rtl8192ce using an RTL8188CE
>>> (10ec:8176), it will be a perfect time to test.
>>
>> Here is the command script, and the console log
>> (....sh 2>&1 | tee ....log)
>
> Instead of cat, I used single-second sleeps as can be seen in the attached
> script. Our logs are roughly the same (I have replaced the last three bytes of
> the MAC address by XX for privacy). The rtlwifi module is patched[1], hence
> the out-of-tree marking.
>
> What is the problem that you are experiencing?
>

Indeed a good question! Likely there is no problem. Likely a
misunderstanding from my part of the wifi logic.

I was going step by step in my integration and I (wrongly?) assumed that 
the command to set a channel in the wifi configuration was a requirement 
for my next step: scanning done on an older wifi system detected signals 
from multiple channels but the newer system scanning saw only channel 1, 
hence I assumed that the newer scanning scheme needed channel changes by 
the user space logic.

Now a number of clues (including your log below -- thanks) point towards 
the inconsequential-ness of the EBUSY result in the specific command I 
was using as a milestone.

Other clues: a) suggestion by Larry to try other tools, and b) an EBUSY 
return code in net/wireless/chan.c .

Somewhere else I might learn how scanning on multiple channels can work, 
but I no longer care for my deployment priorities.

> I am able to connect although
> it took half a minute for the first ICMP ping packets to pass (and then there
> is still a lot of packet loss). This pattern is observable on the past 2.5
> weeks that I have been running ping tests (ping every second to the gateway).
>
>> Is it possible that the Shuttle system be arranged with a digital output
>> enabling/inhibiting the Realtek wifi interface active participation in
>> wifi protocol?
>
> I didn't understand the first part, are you referring to a possible mistake in
> attaching the antennas? When I opened up the case, I saw two antennas that
> were properly secured to the card.
>

Please ignore this other hypothesis.

Thanks a lot to Larry and Peter. If you don't ear from me, please assume 
that I successfully installed hostapd and I am an happy rtlwifi user 
with the kernel 3.14.

-- Thierry Moreau
