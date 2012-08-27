Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37648 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2H0R0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 13:26:06 -0400
Received: by wibhq12 with SMTP id hq12so5648405wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 10:26:04 -0700 (PDT)
References: <1364831.ftJE0YjeaD@proton> <2175505.7MyGkZApGB@hermes> <503A6980.6070004@gmail.com> <4808588.cxLuFoSN6l@proton>
In-Reply-To: <4808588.cxLuFoSN6l@proton>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5778DD9C-60D3-440B-A81D-7A82E7D3D254@gmail.com> (sfid-20120827_192610_650205_42BE057E)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: rt73usb not working since linux 3.4
Date: Mon, 27 Aug 2012 19:26:04 +0200
To: Andreas Messer <andi@bastelmap.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

On 27 aug. 2012, at 18:33, Andreas Messer <andi@bastelmap.de> wrote:

> Hey Gertjan,
> 
> Am Sonntag, 26. August 2012, 20:22:56 schrieb Gertjan van Wingerde:
>> Hi Andreas,
>> 
>> On 08/23/12 20:51, Andreas Messer wrote:
>>> Hey there,
>>> 
>>> Am Dienstag, 24. Juli 2012, 19:33:34 schrieb Andreas Messer:
>>>> Hello Again,
>>>> 
>>>> Am Dienstag, 26. Juni 2012, 13:18:35 schrieb John W. Linville:
>>>>> On Tue, Jun 26, 2012 at 06:03:56PM +0200, Andreas Messer wrote:
>>>>>> Dear all,
>>>>>> 
>>>>>> updating my pc from linux kernel 3.3 to linux kernel 3.4 broke my wlan.
>>> 
>>> I have spent some more time on investigating the cause of the bug and
>>> found
>>> the problem. Actually I'm not sure which is the right solution. The
>>> problem is caused by the following points:
>>> 
>>> 1) The rt73 hardware registers are not initialized before bringing the
>>> 
>>>   corresponding network interface up ('ifconfig wlan0 up')
>>> 
>>> 2) Bringing the interface up is not possible because of the kill switch
>>> 
>>> 3) The GPIO input pin for the kill switch is still in 'output mode' (the
>>> 
>>>   default power on value), therefore the register will always read
>>>   'killswitch on'
>>> 
>>> [...] 
>> [...]
>> The reason why we do most of the initialization at interface up is that
>> that is the earliest possible time we can get the firmware image from
>> userspace. A lot of the register programming we have to do for
>> initialization depend on the firmware being uploaded and running, hence
>> we initialize most at interface up time.
>> [...]
> 
> Thanks for that explanation. Didn't know that about the firmware.
> 
>> Find attached a patch that does this for all the rt2x00 devices. I hope
>> you are able to test whether this patch fixes the problem for you.
> 
> Yep, the patch works fine for me. (Tested on latest git snapshot)
> 

Thanks for testing. I'll submit the patch-set upstream later this week.

---
Gertjan