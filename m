Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:43995 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbcGFJad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 05:30:33 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "fixed-term.Oleksij.Rempel@de.bosch.com"
	<fixed-term.Oleksij.Rempel@de.bosch.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"anders.darander@gmail.com" <anders.darander@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux@rempel-privat.de" <linux@rempel-privat.de>,
	"linux-snps-arc@lists.infradead.org"
	<linux-snps-arc@lists.infradead.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
Date: Wed, 6 Jul 2016 09:30:28 +0000
Message-ID: <1467797356.3086.48.camel@synopsys.com> (sfid-20160706_113037_770483_0597C1E0)
References: <1467721137.3144.81.camel@synopsys.com>
	 <577BED2D.7070209@rempel-privat.de> <1467739821.3086.13.camel@synopsys.com>
	 <577C041C.7080905@rempel-privat.de> <1467790987.3086.15.camel@synopsys.com>
	 <577CC035.1000404@de.bosch.com> <1467793848.3086.37.camel@synopsys.com>
	 <577CC3A2.5070607@de.bosch.com> <1467794679.3086.42.camel@synopsys.com>
	 <577CCAB8.90003@de.bosch.com>
In-Reply-To: <577CCAB8.90003@de.bosch.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi+AKA-Oleksij,

On Wed, 2016-07-06 at 11:09 +-0200, fixed-term.Oleksij.Rempel wrote:
+AD4- 
+AD4- On 06.07.2016 10:45, Alexey Brodkin wrote:
+AD4- +AD4- 
+AD4- +AD4- Hi Oleksij,
+AD4- +AD4- 
+AD4- +AD4- On Wed, 2016-07-06 at 10:38 +-0200, fixed-term.Oleksij.Rempel wrote:
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- On 06.07.2016 10:32, Alexey Brodkin wrote:
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Hi Oleksij,
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- On Wed, 2016-07-06 at 10:24 +-0200, fixed-term.Oleksij.Rempel wrote:
+AD4- +AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- +AD4- +AKA-
+AD4- +AD4- +AD4- +AD4- +AD4- Hm... this Endpoint should be Interrupt, not Bulk. If you search for
+AD4- +AD4- +AD4- +AD4- +AD4- lsusb of this kind of adapter all of them list EP3 and EP4 as Interrupt.
+AD4- +AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- +AD4- what did went wrong here? Is it not working in USB High Speed mode?
+AD4- +AD4- +AD4- +AD4- Unfortunately as of now on that board EHCI doesn't work.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- That's not a problem of a particular USB device but something in either
+AD4- +AD4- +AD4- +AD4- ECHI host controller or its integration. I do hope we will fix it sometime soon
+AD4- +AD4- +AD4- +AD4- (this is a development board and USB controller is implemented in FPGA so
+AD4- +AD4- +AD4- +AD4- there's a chance to fix stuff later on).
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- So given only OHCI works on the board I went forward and attempted to use it
+AD4- +AD4- +AD4- +AD4- with Wi-Fi USB dongle.
+AD4- +AD4- +AD4- I did some tests for 2 years on OHCI controller on x86. There was no
+AD4- +AD4- +AD4- noticable issues. It was even a bit faster then Intels EHCI. I don't
+AD4- +AD4- +AD4- think OHCI alone is the source of this problem.
+AD4- +AD4- Well I was also surprised how well that dongle works with that board in
+AD4- +AD4- OHCI mode. I saw quite consistent +AH4-4-5 Mbit/second rates when doing Speedtest
+AD4- +AD4- from my smartphone. So IMHO it's completely usable. Especially on that kind of
+AD4- +AD4- HW which has main CPU running at just 100MHz.
+AD4- +AD4- 
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- On other side, so far i know, this adapter claims to provide usb full
+AD4- +AD4- +AD4- speed support, (Not only high speed) and may use different usb
+AD4- +AD4- +AD4- descriptor for this. May be this is the problem.
+AD4- +AD4- So is there something we may do with all that?
+AD4- Sure...
+AD4- 
+AD4- This shows that EP4 is Bluk in full speed mode. And it is defined by a
+AD4- boot loader of this chip:
+AD4- grep -R USB+AF8-FS+AF8-EP4+AF8-ATTRIBUTE +ACo-
+AD4- sboot/magpie+AF8-1+AF8-1/sboot/hif/usb/src/usb+AF8-table.c:
+AD4- m2BYTE(USB+AF8-FS+AF8-EP4+AF8-ATTRIBUTE, USB+AF8-FS+AF8-EP4+AF8-MAX+AF8-PACKET+AF8-SIZE),
+AD4- sboot/magpie+AF8-1+AF8-1/sboot/hif/usb/src/usb+AF8-table.h:+ACM-define
+AD4- USB+AF8-FS+AF8-EP4+AF8-ATTRIBUTE+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-bUSB+AF8-EP+AF8-TYPE+AF8-BULK
+AD4- sboot/magpie+AF8-1+AF8-1/inc/usb+AF8-table.h:+ACM-define USB+AF8-FS+AF8-EP4+AF8-ATTRIBUTE
+AD4- +AKA-bUSB+AF8-EP+AF8-TYPE+AF8-BULK
+AD4- target+AF8-firmware/magpie+AF8-fw+AF8-dev/target/inc/k2/usb+AF8-table.h:+ACM-define
+AD4- USB+AF8-FS+AF8-EP4+AF8-ATTRIBUTE+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-bUSB+AF8-EP+AF8-TYPE+AF8-BULK
+AD4- target+AF8-firmware/magpie+AF8-fw+AF8-dev/target/inc/magpie/usb+AF8-table.h:+ACM-define
+AD4- USB+AF8-FS+AF8-EP4+AF8-ATTRIBUTE+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-bUSB+AF8-EP+AF8-TYPE+AF8-BULK
+AD4- 
+AD4- 
+AD4- So, there are fallowing variants to fix it:
+AD4- a) patch full speed usb descriptor in firmware and add usb reinit
+AD4- support to the driver.
+AD4- b) add support of different EP4 types.
+AD4- 
+AD4- In any case, some one need to implement it... right now i have time only
+AD4- for mentoring.

That's understood.

+AD4- It is hard to say, which solution is better. It will affect performance
+AD4- and stability. We will need lots of testing on different HW variants to
+AD4- know it.
+AD4- May be usb maeling list can give some input here?

Let's hope so :)

+AD4- Currently we have fallowing issues:
+AD4- - if EP4 and EP3 are Interrupt, it works slower on High Speed controller.
+AD4- - if EP4 and EP3 are Bulk, the work better on High Speed and brake on
+AD4- Super Speed controllers. This adapter support my 64B packets and if we
+AD4- have more, fifo of this adapter will overrun.
+AD4- - Full Speed is currently unknown field for me, and it looks like it was
+AD4- never actually working properly.

But given that dongle seem to work fine with muted warning do you think it's
fine to continue that way or not?

I mean if there's a chance this +ACI-bogus usb xfer+ACI- might affect something during
execution? Otherwise if that's just not a crucial problem or not a problem at all
may be we may just think how to make this warning not so annoying (in my case
I saw never ending flood of those warnings so that basically stopped me from using
the board after that warning started to appear.

-Alexey