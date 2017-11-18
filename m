Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:33198 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762096AbdKRFhW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 00:37:22 -0500
Received: by mail-wr0-f171.google.com with SMTP id 4so3795686wrt.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Nov 2017 21:37:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK_-F2LuLNCUA9U4AS3A2puLLVWd8Ld66YPAd0NspQUMuUEzGA@mail.gmail.com>
References: <CAK_-F2LuLNCUA9U4AS3A2puLLVWd8Ld66YPAd0NspQUMuUEzGA@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Fri, 17 Nov 2017 21:37:20 -0800
Message-ID: <CALLGbRJXLHeL33UNoNmRdjPJUzoGjajq0hcw2sd=PH4RdWfG7w@mail.gmail.com> (sfid-20171118_063729_185753_EE85F548)
Subject: Re: ath6kl : intermittent Wi-Fi on Fedora 27 (Linux 4.13.12-300)
To: Ken Harris <kjh@hokulea.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ken,

On Fri, Nov 17, 2017 at 11:58 AM, Ken Harris <kjh@hokulea.org> wrote:
> Yesterday, I installed Fedora 27 on a Dell Venue 8 Pro (5830).
>
> I installed the ath6kl firmware from https://github.com/qca/ath6kl-firmware/
>
> The Wi-Fi works for a while, but then stops.  It seems to start up
> again about 30 minutes later.
>
> Is this a known problem ? Is there any to fix it ?

Hard to know. You've not really given us enough information that would
be helpful to help you.  Kernel version? dmesg dump? Backports? Which
chip? SDIO or USB? Network manager or other?  All of this information
is necessary to help.

Usually your distro would come with the right firmware, and if it
doesn't, usually the proper place to get it from is
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/
 Though, if you're needing ar6004/hw3.0 it's missing for some reason
(@Kalle, why isn't that fw in linux-firmware?)

What I can tell you is I have ath6kl on many kernel versions on both
6003 and 6004 connected solid for months at a time with 0 noticeable
drops.

This might help:
https://wireless.wiki.kernel.org/en/users/documentation/reporting_bugs

>
> FYI, I added :
>
> echo options ath6kl_core debug_mask=0x140400 > /etc/modprobe.d/55-ath6k.conf
>
> ... so I'm getting more debug info.  Are the other debug bits I should try ?
>

Not bad, but I'd also suggest adding the recovery bit.  0x940400 would
be a good place to start.

Get us a kernel messages dump and maybe we can help more.

- Steve
