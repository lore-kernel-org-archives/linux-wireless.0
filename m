Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:60726 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750981Ab1CKQ6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 11:58:51 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: "'Chen, Xianwen'" <xianwen.chen@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	=?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>
Subject: RE: Status of Broadcom 4353?
Date: Fri, 11 Mar 2011 16:58:45 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05722753@RockMX01.rock.corp>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
	<4D798863.2060303@lwfinger.net>
	<AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
	<4D7A3EAD.10306@lwfinger.net>
	<AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
 <AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
In-Reply-To: <AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to put firmware in 
/lib/firmware/ instead of /lib/firmware/brcm/ which is the located in the git tree, but NOT necessarily the location the driver is looking for.


-----Original Message-----
From: Chen, Xianwen [mailto:xianwen.chen@gmail.com] 
Sent: Friday, March 11, 2011 11:43 AM
To: linux-wireless@vger.kernel.org
Cc: Larry Finger; Rafa³ Mi³ecki; Chaoxing Lin; Brett Rudley
Subject: Re: Status of Broadcom 4353?

Thanks a lot Chaoxing, Larry and Rafal,

I installed the Linux firmware (20110128), as you can see by 'ls
/lib/firmware/brcm/ -l'

  total 368
  -rw-r--r-- 1 root root 269595 Mar 11 16:57 bcm4329-fullmac-4-218-248-5.bin
  -rw-r--r-- 1 root root   1604 Mar 11 16:57 bcm4329-fullmac-4-218-248-5.txt
  -rw-r--r-- 1 root root  97376 Mar 11 16:57 bcm43xx-0-610-809-0.fw
  -rw-r--r-- 1 root root    180 Mar 11 16:57 bcm43xx_hdr-0-610-809-0.fw

However, after rebooting and even after recompiling and rebooting the
kernel, the wireless adapter doesn't yet show up.

Hence, I decide to give more details on the problem, to see if
something is missing:

(1) The Dell Latitude E5410 is running Gentoo AMD64 with all packages
up to date.

(2) The latest 2.6.38-rc8 kernel is used.

(3) The kernel config can be seen at http://pastebin.com/ExAzLHr8.

(4) The dmesg is uploaded to http://pastebin.com/wV3Wp54r.

(5) The output from lspci is at http://pastebin.com/Giqs7kkA.

Any thoughts, please?

Xianwen


2011/3/11 Rafa³ Mi³ecki <zajec5@gmail.com>:
> 2011/3/11 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 03/11/2011 09:05 AM, Chen, Xianwen wrote:
>>>
>>> Thanks a lot guys!
>>>
>>> I revisited http://linuxwireless.org/en/users/Drivers/brcm80211, but
>>> did not find the firmware. Am I missing something?
>>
>> The firmware is in the linux-firmware tree. You probably need to install the
>> latest package for your distro called "linux firmware" or "kernel firmware".
>> Otherwise
>>
>> git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
>>
>> The files you need will be in linux-firmware/brcm. Copy them to
>> /lib/firmware/brcm.
>
> Or just use web gui :)
>
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=tree;f=brcm;h=883e5732daa040c3c7d39b179c4b4b750db354cd;hb=HEAD
>
> --
> Rafa³
>
