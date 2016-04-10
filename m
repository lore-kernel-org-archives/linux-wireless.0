Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34777 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbcDJKJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 06:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com>
References: <E1akxli-00030z-BC@bombadil.infradead.org>
	<CA+Y=x3=cLDHc7PK5h9n=ixdgVKWdVSu_v+-7jHJ-vBnDrv4sgg@mail.gmail.com>
	<20160403114912.GA11540@wunner.de>
	<CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com>
Date: Sun, 10 Apr 2016 20:09:29 +1000
Message-ID: <CA+Y=x3mVrSKMgzy74xtO5ZOc5kYLYU=iKZgqyjn0j94bXoebjg@mail.gmail.com> (sfid-20160410_120934_953531_8851FA22)
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
From: Andrew Worsley <amworsley@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: b43-dev@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Further testing Broadcom 4331 reset quirk to prevent IRQ storm patch
testing reveals that:
  1. quirk is run on initial boot up and this time appears to have
vastly reduced the interrupts (only 81 this time):
cat /proc/interrupts| grep 17
 17:         81          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel

 2. But it is apparently *NOT* run after a suspend/resume and we get
the problem:
 17:     100084          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel

Rebooting a further nine times shows the low number (below 100) only
happens around 1/3 of the times:
boot #2
 17:      38706          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot #3
 17:         87          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
LOC:       2494       2031       2094       1831       1157       1171
      1573       1271   Local timer interrupts
boot #4
 17:      50616          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot#5
 17:      26454          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot#6
 17:      34440          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot#7
 17:         79          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot#8
 17:         84          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot#9
 17:      37054          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
boot#10
 17:      24648          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel

 Is there an easy setpci command to stop this we can add to grub?

Presently I have a grub work around for black screen as described here:
  http://askubuntu.com/questions/264247/proprietary-nvidia-drivers-with-efi-on-mac-to-prevent-overheating/613573#613573

which basically involves adding a grub scriptlet to enable PCI-E bus
mastering on graphics cards:

In /etc/grub.d/01_enable_vga.conf:

setpci -s "00:01.0" 3e.b=8
setpci -s "01:00.0" 04.b=7

Can we do some similar magic setpci commands to disable 04:00.0
which is my BCM4331

  lspci | grep 4331
04:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)



On 7 April 2016 at 22:04, Andrew Worsley <amworsley@gmail.com> wrote:
> Sorry but testing the patch shows no difference.
>
> I have just compiled debian jessie kernel 3.16.7-ckt25 and booted it
> and hibernated it twice, then did the same with your patch applied.
> There appeared to be no difference
>
....

Thanks for any suggestions

Andrew
