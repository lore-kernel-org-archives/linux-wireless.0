Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:39384 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaFGTsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 15:48:01 -0400
Received: by mail-oa0-f41.google.com with SMTP id m1so4267718oag.14
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 12:48:00 -0700 (PDT)
Message-ID: <53936C6E.8070800@lwfinger.net> (sfid-20140607_214806_442753_A51A534C)
Date: Sat, 07 Jun 2014 14:47:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Powerful Notageek <powerfulnotageek@yahoo.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: MT7630e availability in kernel by default
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net> <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com> <539356EA.1070004@lwfinger.net> <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com> <53935FFE.10708@lwfinger.net> <1402168424.40608.YahooMailNeo@web193005.mail.sg3.yahoo.com>
In-Reply-To: <1402168424.40608.YahooMailNeo@web193005.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2014 02:13 PM, Powerful Notageek wrote:
> dmesg says nothing and there's probably no firmware for the device (although linux-firmware is installed)
>
> These are the firmwares available to me:
>
> [root@localhost ~]# ll /usr/lib/firmware/rt2*
> -rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561.bin
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

