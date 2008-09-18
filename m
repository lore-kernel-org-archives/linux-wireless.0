Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:13543 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbYIRTAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:00:54 -0400
Received: by ug-out-1314.google.com with SMTP id k3so811215ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 12:00:52 -0700 (PDT)
Message-ID: <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com> (sfid-20080918_210100_379578_70EDDA5A)
Date: Thu, 18 Sep 2008 12:00:50 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 11:42 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Sep 18, 2008 at 11:34 AM, Luis R. Rodriguez
>> irqpoll is a monster of evil and that should make your system crawl to
>> its knees. I would advise instead we work with you fixing the the
>> missed interrupts issue upon rmmod.
>
> Also, please provide the output of
>
> cat /proc/interrupts

Note that the problem necessitating use of irqpoll in the first place
seems to only happen under certain conditions. I am unsure what these
conditions are. Before 'ath9k: connectivity is lost after Group
rekeying is done', I had used rmmod/modprobe as my solution to the
issue, which triggered the IRQ issue.

alcarin steven # cat /proc/interrupts
           CPU0       CPU1
0x0:      63227          0   IO-APIC-edge      hpet
0x8:          1          0   IO-APIC-edge      rtc0
0x9:      13080          0   IO-APIC-fasteoi   acpi
0xe:       8195          0   IO-APIC-edge      ide0
0xf:          0          0   IO-APIC-edge      ide1
0x10:         36          0   IO-APIC-fasteoi   uhci_hcd:usb5
0x11:      10645          0   IO-APIC-fasteoi   ath
0x12:         42          0   IO-APIC-fasteoi   uhci_hcd:usb4
0x17:        919          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
0x13:      32885          0   IO-APIC-fasteoi   uhci_hcd:usb3,
ata_piix, ohci1394
0x200100:          1          0   PCI-MSI-edge      eth0
0x16:        223          0   IO-APIC-fasteoi   HDA Intel
NMI:          0          0   Non-maskable interrupts
LOC:      78087      95718   Local timer interrupts
RES:      11576      16384   Rescheduling interrupts
CAL:       6862       8889   Function call interrupts
TLB:         54         41   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0


>
> and also please do not cross post to all these lists, just use
> linux-wireless or ath9k.
>

Sorry, but in the past I've posted to linux-wireless, ath9k-devel, and
all the maintainers of ath9k and didn't get a single response (except
a 'me too' from a fellow ath9k user). I didn't just want to hear
crickets this time.

- Steven
