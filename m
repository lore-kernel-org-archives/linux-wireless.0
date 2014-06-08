Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm26-vm7.bullet.mail.sg3.yahoo.com ([106.10.151.118]:34027 "EHLO
	nm26-vm7.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbaFHCFg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 22:05:36 -0400
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net> <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com> <539356EA.1070004@lwfinger.net> <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com> <53935FFE.10708@lwfinger.net> <1402168424.40608.YahooMailNeo@web193005.mail.sg3.yahoo.com> <53936C6E.8070800@lwfinger.net>
Message-ID: <1402193134.29527.YahooMailNeo@web193005.mail.sg3.yahoo.com> (sfid-20140608_040539_815021_B963AD24)
Date: Sun, 8 Jun 2014 10:05:34 +0800 (SGT)
From: Powerful Notageek <powerfulnotageek@yahoo.in>
Reply-To: Powerful Notageek <powerfulnotageek@yahoo.in>
Subject: Re: MT7630e availability in kernel by default
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <53936C6E.8070800@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for taking time to investigate it with me. Essentially, the driver for it doesn't exist in any form and maybe it will be introduced at a later release after 3.16. 

Thanks again, appreciate it very much. 



On Sunday, 8 June 2014 1:18 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
On 06/07/2014 02:13 PM, Powerful Notageek wrote:
> dmesg says nothing and there's probably no firmware for the device (although linux-firmware is installed)
>
> These are the firmwares available to me:
>
> [root@localhost ~]# ll /usr/lib/firmware/rt2*
> -rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561.bi
> -rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561s.bin
> -rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2661.bin
> -rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2860.bin
> -rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2870.bin

I looked more closely at the code in https://github.com/anthonywong/mt7630. 
There are a number of places where there are branches specific to the MT7630. It 
also needs a firmware file named mt7630.bin. Unfortunately, that file is not 
found in the repo, and a quick Google search failed to find it. The 
linux-firmware git repo has a file named mt7650.bin, but I think that is 
Bluetooth firmware.

Unfortunately, there does not seem to be an easy fix, and only someone with the 
hardware could modify rt2800pci to support this device.




Larry
