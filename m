Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:50427 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751209Ab0JSH2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 03:28:22 -0400
Message-ID: <4CBD52DE.9090804@gmx.net>
Date: Tue, 19 Oct 2010 10:12:14 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net>	 <1287071844.11341.5.camel@gnutoo-laptop>	 <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>	 <4CB74759.3030807@gmx.net>	 <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>	 <4CB7F7C7.7030804@gmx.net>	 <AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>	 <4CBABB84.1090100@gmx.net> <4CBC7725.7050202@gmx.net>	 <AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>	 <4CBC9A51.8030309@gmx.net>  <1287427291.8043.2.camel@powerslave> <1287428554.8043.6.camel@powerslave>
In-Reply-To: <1287428554.8043.6.camel@powerslave>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/10/2010 21:02, Luciano Coelho wrote:
> On Mon, 2010-10-18 at 20:41 +0200, ext Luciano Coelho wrote:
>> On Mon, 2010-10-18 at 21:04 +0200, ext George wrote:
>>> On 18/10/2010 19:21, Luis R. Rodriguez wrote:
>>>>> Any help on that? Sorry but I'm somehow desesperate and don't know what to
>>>>> do. Actually I'm thinking on not using compat-wireless and nl80211 and get
>>>>> back to wireless-extensions.
>>
>> Getting back to wireless-extensions would certainly be a very desperate
>> measure! :P

I guess it is, evenmore when nl80211 is the present ;) But I'm running 
out of time and getting desperate ;)

>>
>>>> Does your device use SDIO or SPI?
>>>>
>>>>     Luis
>>>
>>> I have tried both and none of them have worked.
>>
>> On the N900 the wl1271 chip is connected via SPI.

The chip is a wl1251, isn't it? wl1271 is n capable and n900 is not.

>> I'll re-read this thread more carefully to see if I can spot anything
>> that could help you.
>
> First thing that came to my mind after re-reading the thread... Does the
> wl1251 driver work *without* compat-wireless?

I don't now how to test the driver without compat-wireless. If you can 
explain it I will try. Do I have just to copy driver code on 
compat-wireless directly into my kernel source directory? I don't think 
that would work and probably complain, but I can try if this is the way.

> Where did you get the
> kernel that you have compiled?

The kernel is the official one for n900, kernel-2.6.28 (uname -a returns 
2.6.28-omap1). I got it using scratchbox and downloading it with:

sb# apt-get source kernel

Then I have compiled it using:

sb# make EXTRAVERSION=-mine rx51_defconfig
sb# make EXTRAVERSION=-mine menuconfig
sb# make EXTRAVERSION=-mine bzImage modules
sb# make EXTRAVERSION=-mine modules_install

After that I have compiled on scratchbox compat-wireless package:

sb# cd compat-wireless-2010-10-17
sb# scripts/driver-select wl12xx
sb# make KLIB=/lib/modules/2.6.28-mine 
KMODPATH_ARG=/lib/modules/2.6.28-mine
sb# make KLIB=/lib/modules/2.6.28-mine 
KMODPATH_ARG=/lib/modules/2.6.28-mine install

Then move the new set of modules to my n900

n900# mkdir -p /lib/modules/2.6.28-mine

# cd /lib/modules/2.6.28-mine
# scp -r updates/ kernel/ modules.* 
root@192.168.2.15:/lib/modules/2.6.28-mine

And then boot with the new kernel image

ubuntu$ sudo flasher-3.5 -l -b -k 
PATH_TO_KERNEL/kernel-2.6.28/arch/arm/boot/zImage


> My initial guess is that the SPI is not configured correctly so the
> probe function is never called in the wl1251_spi module and thus the
> interface is never created...

I'm attaching a link to my .config file to check if you consider I have 
to activate any other stuff.

http://pastebin.com/sCnHzp3V

I would like to thank you all for the tremendous effort you are doing 
helping me out on this issue.

BR
Jorge

