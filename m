Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:42900 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933906AbdKQHiD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 02:38:03 -0500
Received: by mail-wm0-f54.google.com with SMTP id 5so3316872wmk.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Nov 2017 23:38:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1510901207.4011.197.camel@coelho.fi>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi> <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
 <1509952948.4492.360.camel@coelho.fi> <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
 <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
 <1510825750.4011.179.camel@coelho.fi> <CAB4CAwfg73wRoNca2GBaMn4eN04vf+uR3xdzYO0UWG1Nmaqo=w@mail.gmail.com>
 <1510901207.4011.197.camel@coelho.fi>
From: Chris Chiu <chiu@endlessm.com>
Date: Fri, 17 Nov 2017 15:38:01 +0800
Message-ID: <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com> (sfid-20171117_083807_010086_1E56EFD3)
Subject: Re: Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 17, 2017 at 2:46 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2017-11-17 at 14:39 +0800, Chris Chiu wrote:
>> On Thu, Nov 16, 2017 at 5:49 PM, Luca Coelho <luca@coelho.fi> wrote:
>> > Hi Chris,
>> >
>> > On Thu, 2017-11-09 at 11:11 +0800, Chris Chiu wrote:
>> > > Hi Luca,
>> > >     Any suggestion for the "Failed to start INIT ucode: -110"
>> > > issue
>> > > for the firmware?
>> >
>> > There were a few problems which should now be fixed.  We published
>> > new
>> > firmwares in our linux-firmware.git tree[1] and also made some
>> > fixes in
>> > the driver[2].  Please update your system accordingly and let me
>> > know
>> > if it works for you.
>> >
>> > Thanks!
>> >
>> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-f
>> > irmware.git/
>> > [2] https://patchwork.kernel.org/patch/10059871/
>> >     https://patchwork.kernel.org/patch/10059875/
>> >     https://patchwork.kernel.org/patch/10059873/
>> >
>> > --
>> > Cheers,
>> > Luca.
>>
>> Hi Luca,
>
> Hi Chris,
>
>
>>     Thanks for your patch and updated firmware. The driver can
>> initialize w/o error now. However, it always fails on ip-config after
>> 4-way handshake complete. I have to mention that I removed the field
>> ".soc_latency" in all new iwl_cfg you added in
>> https://patchwork.kernel.org/patch/10059875/ to remove compile error
>> based on the linux mainline 4.14.
>>     I don't know whether if this causes the problem. Do you need me
>> to
>> do anything for more information?
>
> That was my fault, I forgot to include one file in my commit.  I have
> sent v2 of the two last patches to solve the problem.  Can you try
> them?
>
> The problem you're seeing could be related to that, because we use a
> bit longer wait period for HW stabilization with integrated devices.
> And if you remove it, you may encounter random problems...
>
> --
> Cheers,
> Luca.

Hi Luca,
    Thanks for your quick response. I  tried your v2 patch but things
remain the same. The signal strength and scan results seems nothing
wrong but still fail to get ip from DHCP server. Please let me know
what I can help here.

Chris
