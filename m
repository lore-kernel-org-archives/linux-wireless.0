Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36603 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdKVNsn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 08:48:43 -0500
Received: by mail-wm0-f50.google.com with SMTP id r68so10406491wmr.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Nov 2017 05:48:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi> <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
 <1509952948.4492.360.camel@coelho.fi> <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
 <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
 <1510825750.4011.179.camel@coelho.fi> <CAB4CAwfg73wRoNca2GBaMn4eN04vf+uR3xdzYO0UWG1Nmaqo=w@mail.gmail.com>
 <1510901207.4011.197.camel@coelho.fi> <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com>
From: Chris Chiu <chiu@endlessm.com>
Date: Wed, 22 Nov 2017 21:48:41 +0800
Message-ID: <CAB4CAwdZHwC0kiaGU5A1u_P8y0anw58o6KiOXAWbjwUtB=uLuQ@mail.gmail.com> (sfid-20171122_144848_015153_478BB8A2)
Subject: Re: Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 17, 2017 at 3:38 PM, Chris Chiu <chiu@endlessm.com> wrote:
> On Fri, Nov 17, 2017 at 2:46 PM, Luca Coelho <luca@coelho.fi> wrote:
>> On Fri, 2017-11-17 at 14:39 +0800, Chris Chiu wrote:
>>> On Thu, Nov 16, 2017 at 5:49 PM, Luca Coelho <luca@coelho.fi> wrote:
>>> > Hi Chris,
>>> >
>>> > On Thu, 2017-11-09 at 11:11 +0800, Chris Chiu wrote:
>>> > > Hi Luca,
>>> > >     Any suggestion for the "Failed to start INIT ucode: -110"
>>> > > issue
>>> > > for the firmware?
>>> >
>>> > There were a few problems which should now be fixed.  We published
>>> > new
>>> > firmwares in our linux-firmware.git tree[1] and also made some
>>> > fixes in
>>> > the driver[2].  Please update your system accordingly and let me
>>> > know
>>> > if it works for you.
>>> >
>>> > Thanks!
>>> >
>>> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-f
>>> > irmware.git/
>>> > [2] https://patchwork.kernel.org/patch/10059871/
>>> >     https://patchwork.kernel.org/patch/10059875/
>>> >     https://patchwork.kernel.org/patch/10059873/
>>> >
>>> > --
>>> > Cheers,
>>> > Luca.
>>>
>>> Hi Luca,
>>
>> Hi Chris,
>>
>>
>>>     Thanks for your patch and updated firmware. The driver can
>>> initialize w/o error now. However, it always fails on ip-config after
>>> 4-way handshake complete. I have to mention that I removed the field
>>> ".soc_latency" in all new iwl_cfg you added in
>>> https://patchwork.kernel.org/patch/10059875/ to remove compile error
>>> based on the linux mainline 4.14.
>>>     I don't know whether if this causes the problem. Do you need me
>>> to
>>> do anything for more information?
>>
>> That was my fault, I forgot to include one file in my commit.  I have
>> sent v2 of the two last patches to solve the problem.  Can you try
>> them?
>>
>> The problem you're seeing could be related to that, because we use a
>> bit longer wait period for HW stabilization with integrated devices.
>> And if you remove it, you may encounter random problems...
>>
>> --
>> Cheers,
>> Luca.
>
> Hi Luca,
>     Thanks for your quick response. I  tried your v2 patch but things
> remain the same. The signal strength and scan results seems nothing
> wrong but still fail to get ip from DHCP server. Please let me know
> what I can help here.
>
> Chris

Hi Luca,
    Some more observation I want to point out and maybe you can suggest.
After your v2 patch and the latest firmware. I'm pretty sure there's no problem
on my 9462NGW module to associate to an AP (4-way handshaking complete)
dmesg in https://gist.github.com/mschiu77/1fe1f5128f1c49a93055ce23976c09b5
here also shows
[   59.338785] wlp0s12f0: associated

Then I do air sniffer with my mac book air and only dump DHCP packets in
https://gist.github.com/mschiu77/677b5fbfdea0fea2eda4a36a84bcac8e

As you see, 4 DHCP Discovery here but no response. I do the same thing on
the other laptop to associate to the same AP SSID, there's no problem.

And yet another interesting thing is, every time I was trying to associate
The ifconfig always give me a totally different ether address. I log 5 times in
https://gist.github.com/mschiu77/54169d52b9fcf205d5c26752988f8a3d

The read HW address should be 34:13:e8:6f:34:25 and it's also true in tcpdump
log.

I think maybe it's related. Can you suggest anything that I can try?

Chris
