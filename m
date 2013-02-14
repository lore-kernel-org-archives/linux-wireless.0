Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:37878 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3BNEUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 23:20:06 -0500
Received: by mail-vb0-f49.google.com with SMTP id s24so1241464vbi.22
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 20:20:05 -0800 (PST)
Message-ID: <511C65F2.1080201@gnoutcheff.name> (sfid-20130214_052011_061754_9F5D91E2)
Date: Wed, 13 Feb 2013 23:20:02 -0500
From: Daniel Gnoutcheff <daniel@gnoutcheff.name>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [ath5k] [bugreport] BIOS hang if wifi was connected before reboot
References: <5100BEF7.4000107@gnoutcheff.name> <CAGRGNgWg=4CgjXpdceNfsy6X0_q=SFY8CegJsTf60yGd_NBuLQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWg=4CgjXpdceNfsy6X0_q=SFY8CegJsTf60yGd_NBuLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Julian, thanks for your response and advice.  (Sorry for my very
slow reply.)

On 01/24/2013 01:45 AM, Julian Calaby wrote:
> On Thu, Jan 24, 2013 at 3:56 PM, Daniel Gnoutcheff
> <daniel@gnoutcheff.name> wrote:
>> Hello all,
>>
>> I have a Lenovo Thinkpad R61 7733A82 running Ubuntu 12.10 on kernel 3.7.4
>> with an Atheros AR5212 PCI-Express wireless card which is reported in dmesg
>> as:
>>   ath5k: phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
>>
>> If I connect this card to some network and then perform a warm reboot
>> without disconnecting from that network, then the system seems to lock up in
>> the middle of the BIOS self-test.
> 
> My guess is that this is a bug in the BIOS itself, not an issue with
> the Linux drivers, and I'd contact Lenovo support to see if this can
> be fixed.

Yep, this looks like a BIOS bug to me too.  Rebooting with kexec works fine.

About two and a half weeks ago, I gave Lenovo tech support a call, and
the representative I talked to indicated that he didn't have a good way
to contact the firmware/hardware engineers.  He suggested that I report
this to Lenovo's forum, which I did at:


https://forums.lenovo.com/t5/Linux-Discussion/R61-w-Ubuntu-hangs-in-POST-if-rebooting-while-connected-to-wifi/td-p/1011759

I haven't gotten any response so far.

My support options are somewhat limited, as my warranty has long since
expired.  Even if it hadn't, I'm not sure that Lenovo would care, given
that they're apparently neglecting other, much more annoying BIOS bugs
(like [1]).

>> Up until recently, it seems that NetworkManager would always disconnect upon
>> shutdown and thus avoided this bug, but this changed in Ubuntu 12.10.  
<snip>
> 
> Have you raised a bug with Ubuntu's Network Manager maintainers about this?

I have now.  Upon investigation, it appears that this is caused by a
combination of (upstream) bugs in wpa_supplicant and NetworkManager.
Fixing either of these bugs restores the intended behavior (and is an
effective workaround for the BIOS bug).  The NetworkManager bug has
already been fixed in upstream's git.  For the record, the relevant bug
reports are:

For NetworkManager:
  https://bugs.launchpad.net/network-manager/+bug/1124803
  https://bugzilla.gnome.org/show_bug.cgi?id=683932
For wpa_supplicant:
  https://bugs.launchpad.net/ubuntu/+source/wpa/+bug/1124789
  http://w1.fi/bugz/show_bug.cgi?id=474

Thanks!

[1]
https://forums.lenovo.com/t5/Linux-Discussion/BIOS-Bug-Enabling-Fn-Ctrl-swap-breaks-Ctrl-Alt-Up/td-p/430663
