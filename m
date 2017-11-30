Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36291 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752951AbdK3NSv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 08:18:51 -0500
Received: by mail-wm0-f52.google.com with SMTP id b76so12414699wmg.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Nov 2017 05:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511689749.4011.357.camel@coelho.fi>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi> <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
 <1509952948.4492.360.camel@coelho.fi> <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
 <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
 <1510825750.4011.179.camel@coelho.fi> <CAB4CAwfg73wRoNca2GBaMn4eN04vf+uR3xdzYO0UWG1Nmaqo=w@mail.gmail.com>
 <1510901207.4011.197.camel@coelho.fi> <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com>
 <CAB4CAwdZHwC0kiaGU5A1u_P8y0anw58o6KiOXAWbjwUtB=uLuQ@mail.gmail.com> <1511689749.4011.357.camel@coelho.fi>
From: Chris Chiu <chiu@endlessm.com>
Date: Thu, 30 Nov 2017 21:18:49 +0800
Message-ID: <CAB4CAwf6uBbMgT_=Qb5uo+2g_sNSLdRhnjJt-C9vB6OgSjphyg@mail.gmail.com> (sfid-20171130_141920_725841_BDCFAB74)
Subject: Re: [linuxwifi] Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,
    I got another machine which has Intel 9461NGW (31dc:0264) and
stuck at the same problem. I can't see the DHCP response on the air.
However, the router does respond to the DHCP discover. Please check
the following tcpdump here. The 9461's mac address is
60:f6:77:9a:f4:ed
https://gist.github.com/mschiu77/8f613ba6e3c41a3bd5206f1e903b0bbd

    Then I go to AP and do tcpdump, I can still see the DHCP reply
packet on the corresponding interface. Don't know why can't I see this
packet on the air? maybe wrong channel?

Chris

On Sun, Nov 26, 2017 at 5:49 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2017-11-22 at 21:48 +0800, Chris Chiu wrote:
>> On Fri, Nov 17, 2017 at 3:38 PM, Chris Chiu <chiu@endlessm.com>
>> wrote:
>> > On Fri, Nov 17, 2017 at 2:46 PM, Luca Coelho <luca@coelho.fi>
>> > wrote:
>> > > On Fri, 2017-11-17 at 14:39 +0800, Chris Chiu wrote:
>> > > > On Thu, Nov 16, 2017 at 5:49 PM, Luca Coelho <luca@coelho.fi>
>> > > > wrote:
>> > > > > Hi Chris,
>> > > > >
>> > > > > On Thu, 2017-11-09 at 11:11 +0800, Chris Chiu wrote:
>> > > > > > Hi Luca,
>> > > > > >     Any suggestion for the "Failed to start INIT ucode:
>> > > > > > -110"
>> > > > > > issue
>> > > > > > for the firmware?
>> > > > >
>> > > > > There were a few problems which should now be fixed.  We
>> > > > > published
>> > > > > new
>> > > > > firmwares in our linux-firmware.git tree[1] and also made
>> > > > > some
>> > > > > fixes in
>> > > > > the driver[2].  Please update your system accordingly and let
>> > > > > me
>> > > > > know
>> > > > > if it works for you.
>> > > > >
>> > > > > Thanks!
>> > > > >
>> > > > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/l
>> > > > > inux-f
>> > > > > irmware.git/
>> > > > > [2] https://patchwork.kernel.org/patch/10059871/
>> > > > >     https://patchwork.kernel.org/patch/10059875/
>> > > > >     https://patchwork.kernel.org/patch/10059873/
>> > > > >
>> > > > > --
>> > > > > Cheers,
>> > > > > Luca.
>> > > >
>> > > > Hi Luca,
>> > >
>> > > Hi Chris,
>> > >
>> > >
>> > > >     Thanks for your patch and updated firmware. The driver can
>> > > > initialize w/o error now. However, it always fails on ip-config
>> > > > after
>> > > > 4-way handshake complete. I have to mention that I removed the
>> > > > field
>> > > > ".soc_latency" in all new iwl_cfg you added in
>> > > > https://patchwork.kernel.org/patch/10059875/ to remove compile
>> > > > error
>> > > > based on the linux mainline 4.14.
>> > > >     I don't know whether if this causes the problem. Do you
>> > > > need me
>> > > > to
>> > > > do anything for more information?
>> > >
>> > > That was my fault, I forgot to include one file in my commit.  I
>> > > have
>> > > sent v2 of the two last patches to solve the problem.  Can you
>> > > try
>> > > them?
>> > >
>> > > The problem you're seeing could be related to that, because we
>> > > use a
>> > > bit longer wait period for HW stabilization with integrated
>> > > devices.
>> > > And if you remove it, you may encounter random problems...
>> > >
>> > > --
>> > > Cheers,
>> > > Luca.
>> >
>> > Hi Luca,
>> >     Thanks for your quick response. I  tried your v2 patch but
>> > things
>> > remain the same. The signal strength and scan results seems nothing
>> > wrong but still fail to get ip from DHCP server. Please let me know
>> > what I can help here.
>> >
>> > Chris
>>
>> Hi Luca,
>>     Some more observation I want to point out and maybe you can
>> suggest.
>> After your v2 patch and the latest firmware. I'm pretty sure there's
>> no problem
>> on my 9462NGW module to associate to an AP (4-way handshaking
>> complete)
>> dmesg in https://gist.github.com/mschiu77/1fe1f5128f1c49a93055ce23976
>> c09b5
>> here also shows
>> [   59.338785] wlp0s12f0: associated
>>
>> Then I do air sniffer with my mac book air and only dump DHCP packets
>> in
>> https://gist.github.com/mschiu77/677b5fbfdea0fea2eda4a36a84bcac8e
>>
>> As you see, 4 DHCP Discovery here but no response. I do the same
>> thing on
>> the other laptop to associate to the same AP SSID, there's no
>> problem.
>>
>> And yet another interesting thing is, every time I was trying to
>> associate
>> The ifconfig always give me a totally different ether address. I log
>> 5 times in
>> https://gist.github.com/mschiu77/54169d52b9fcf205d5c26752988f8a3d
>>
>> The read HW address should be 34:13:e8:6f:34:25 and it's also true in
>> tcpdump
>> log.
>>
>> I think maybe it's related. Can you suggest anything that I can try?
>
> Hey Chris,
>
> Thanks for the update and sorry for the delay.  I'll take a look into
> this in the coming week, there's probably something missing in the
> driver that is causing this issue...
>
> --
> Cheers,
> Luca.
