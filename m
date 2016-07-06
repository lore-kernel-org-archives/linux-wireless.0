Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:43293 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbcGFIqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 04:46:00 -0400
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
Date: Wed, 6 Jul 2016 08:45:50 +0000
Message-ID: <1467794679.3086.42.camel@synopsys.com> (sfid-20160706_104607_730407_1AA61064)
References: <1467721137.3144.81.camel@synopsys.com>
	 <577BED2D.7070209@rempel-privat.de> <1467739821.3086.13.camel@synopsys.com>
	 <577C041C.7080905@rempel-privat.de> <1467790987.3086.15.camel@synopsys.com>
	 <577CC035.1000404@de.bosch.com> <1467793848.3086.37.camel@synopsys.com>
	 <577CC3A2.5070607@de.bosch.com>
In-Reply-To: <577CC3A2.5070607@de.bosch.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi+AKA-Oleksij,

On Wed, 2016-07-06 at 10:38 +-0200, fixed-term.Oleksij.Rempel wrote:
+AD4- 
+AD4- On 06.07.2016 10:32, Alexey Brodkin wrote:
+AD4- +AD4- 
+AD4- +AD4- Hi Oleksij,
+AD4- +AD4- 
+AD4- +AD4- On Wed, 2016-07-06 at 10:24 +-0200, fixed-term.Oleksij.Rempel wrote:
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AKA-
+AD4- +AD4- +AD4- Hm... this Endpoint should be Interrupt, not Bulk. If you search for
+AD4- +AD4- +AD4- lsusb of this kind of adapter all of them list EP3 and EP4 as Interrupt.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- what did went wrong here? Is it not working in USB High Speed mode?
+AD4- +AD4- Unfortunately as of now on that board EHCI doesn't work.
+AD4- +AD4- 
+AD4- +AD4- That's not a problem of a particular USB device but something in either
+AD4- +AD4- ECHI host controller or its integration. I do hope we will fix it sometime soon
+AD4- +AD4- (this is a development board and USB controller is implemented in FPGA so
+AD4- +AD4- there's a chance to fix stuff later on).
+AD4- +AD4- 
+AD4- +AD4- So given only OHCI works on the board I went forward and attempted to use it
+AD4- +AD4- with Wi-Fi USB dongle.
+AD4-
+AD4- I did some tests for 2 years on OHCI controller on x86. There was no
+AD4- noticable issues. It was even a bit faster then Intels EHCI. I don't
+AD4- think OHCI alone is the source of this problem.

Well I was also surprised how well that dongle works with that board in
OHCI mode. I saw quite consistent +AH4-4-5 Mbit/second rates when doing Speedtest
from my smartphone. So IMHO it's completely usable. Especially on that kind of
HW which has main CPU running at just 100MHz.

+AD4- On other side, so far i know, this adapter claims to provide usb full
+AD4- speed support, (Not only high speed) and may use different usb
+AD4- descriptor for this. May be this is the problem.

So is there something we may do with all that?

-Alexey
