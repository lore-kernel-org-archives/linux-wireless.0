Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31486 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYJNQrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:47:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 09:47:42 -0700
Date: Tue, 14 Oct 2008 02:47:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Cameron Hutchison <lists@xdna.net>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Failed to init on TP-Link TL-WN861N
Message-ID: <20081014094734.GB6086@tesla> (sfid-20081014_184745_205195_F8B7148C)
References: <667b.48f192b0.3a106@getafix.xdna.net> <43e72e890810131500u289f6e4fwf380966ae8f40b7b@mail.gmail.com> <20081014081232.97106406B@getafix.xdna.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081014081232.97106406B@getafix.xdna.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 01:12:32AM -0700, Cameron Hutchison wrote:
> Luis R. Rodriguez wrote:
> 
> >On Sat, Oct 11, 2008 at 11:01 PM, Cameron Hutchison <lists@xdna.net> wrote:
> >> [...]
> >> ath9k_hw_chip_test: address test failed addr: 0x00008000 - wr:0x00ff00ff != rd:0x00ff00ef
> 
> >This is during ath9k_hw_chip_test(), which is a simple loop to test
> >write/read on 2 registers to see if the written values can be read as
> >the same values. The two registers are:
> 
> >AR_STA_ID0 which is 0x8000
> >AR_PHY_BASE + (8 << 2) which is 0x9800 + (8<<2) --> 0x9820
> 
> >AR_STA_ID0 is used to store part of the MAC address and 0x9820 is just
> >one of the PHY registers. So we test writing and reading a 256 times
> >to each register some arbitrary value. We also try writing and reading
> >some 4 specific patterns just to be sure.
> 
> Which part of the MAC address would be at AR_STA_ID0? I'm stretching
> here, since the nibbles would be out of order, but could this card be
> forcing the multicast bit of the MAC address off?

Please check the usage of the AR_STA_ID0 register as that is what I'd
look to answer to you.

> >If we continue this could lead to issues. It seems you may have a
> >faulty wireless card, specifically bit #5 on register 0x8000. Maybe
> >the card is loose? Have you seen it working before?
> 
> I haven't used the card before - recently purchased for this linux box.
> I've tried reseating the card but no luck.
> 
> I modified ath9k_hw_chip_test to continue testing on failure and I get
> the same problem on the second test:
> ath9k_hw_chip_test: address test failed addr: 0x00008000 - wr:0x00ff00ff != rd:0x00ff00ef
> ath9k_hw_chip_test: address test failed addr: 0x00009820 - wr:0x00ff00ff != rd:0x00ff00ef
> 
> It does not always fail on these two addresses though - sometimes only
> on one (either one) and occasionally none. But then it goes on to fail
> the EEPROM checksum:
> 
> ath9k_hw_fill_eeprom: Reading from EEPROM, not flash
> ath9k_hw_check_eeprom: Read Magic = 0xA55A
> need_swap = False.
> Bad EEPROM checksum 0xff0f or revision 0x000e
> Detaching Ani

Ouch, this is pretty negative.

> I guess the MAC multicast is not happening. I'll see if I can rustle up
> a windows laptop to try this out in and see if it works there.

Let us know how it goes.

  Luis
