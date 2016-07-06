Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:43033 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbcGFIcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 04:32:05 -0400
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
Date: Wed, 6 Jul 2016 08:32:00 +0000
Message-ID: <1467793848.3086.37.camel@synopsys.com> (sfid-20160706_103212_110577_F5A51E1C)
References: <1467721137.3144.81.camel@synopsys.com>
	 <577BED2D.7070209@rempel-privat.de> <1467739821.3086.13.camel@synopsys.com>
	 <577C041C.7080905@rempel-privat.de> <1467790987.3086.15.camel@synopsys.com>
	 <577CC035.1000404@de.bosch.com>
In-Reply-To: <577CC035.1000404@de.bosch.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi+AKA-Oleksij,

On Wed, 2016-07-06 at 10:24 +-0200, fixed-term.Oleksij.Rempel wrote:
+AD4AoA-
+AD4- Hm... this Endpoint should be Interrupt, not Bulk. If you search for
+AD4- lsusb of this kind of adapter all of them list EP3 and EP4 as Interrupt.
+AD4- 
+AD4- what did went wrong here? Is it not working in USB High Speed mode?

Unfortunately as of now on that board EHCI doesn't work.

That's not a problem of a particular USB device but something in either
ECHI host controller or its integration. I do hope we will fix it sometime soon
(this is a development board and USB controller is implemented in FPGA so
there's a chance to fix stuff later on).

So given only OHCI works on the board I went forward and attempted to use it
with Wi-Fi USB dongle.

-Alexey