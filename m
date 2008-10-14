Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 121.140.233.220.exetel.com.au ([220.233.140.121]:4017 "EHLO
	getafix.xdna.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbYJNIpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 04:45:33 -0400
From: Cameron Hutchison <lists@xdna.net>
To: mcgrof@gmail.com
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Failed to init on TP-Link TL-WN861N
References: <667b.48f192b0.3a106@getafix.xdna.net> <43e72e890810131500u289f6e4fwf380966ae8f40b7b@mail.gmail.com>
Message-Id: <20081014081232.97106406B@getafix.xdna.net> (sfid-20081014_104538_586192_45AFF777)
Date: Tue, 14 Oct 2008 19:12:32 +1100 (EST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:

>On Sat, Oct 11, 2008 at 11:01 PM, Cameron Hutchison <lists@xdna.net> wrote:
>> [...]
>> ath9k_hw_chip_test: address test failed addr: 0x00008000 - wr:0x00ff00ff != rd:0x00ff00ef

>This is during ath9k_hw_chip_test(), which is a simple loop to test
>write/read on 2 registers to see if the written values can be read as
>the same values. The two registers are:

>AR_STA_ID0 which is 0x8000
>AR_PHY_BASE + (8 << 2) which is 0x9800 + (8<<2) --> 0x9820

>AR_STA_ID0 is used to store part of the MAC address and 0x9820 is just
>one of the PHY registers. So we test writing and reading a 256 times
>to each register some arbitrary value. We also try writing and reading
>some 4 specific patterns just to be sure.

Which part of the MAC address would be at AR_STA_ID0? I'm stretching
here, since the nibbles would be out of order, but could this card be
forcing the multicast bit of the MAC address off?

>If we continue this could lead to issues. It seems you may have a
>faulty wireless card, specifically bit #5 on register 0x8000. Maybe
>the card is loose? Have you seen it working before?

I haven't used the card before - recently purchased for this linux box.
I've tried reseating the card but no luck.

I modified ath9k_hw_chip_test to continue testing on failure and I get
the same problem on the second test:
ath9k_hw_chip_test: address test failed addr: 0x00008000 - wr:0x00ff00ff != rd:0x00ff00ef
ath9k_hw_chip_test: address test failed addr: 0x00009820 - wr:0x00ff00ff != rd:0x00ff00ef

It does not always fail on these two addresses though - sometimes only
on one (either one) and occasionally none. But then it goes on to fail
the EEPROM checksum:

ath9k_hw_fill_eeprom: Reading from EEPROM, not flash
ath9k_hw_check_eeprom: Read Magic = 0xA55A
need_swap = False.
Bad EEPROM checksum 0xff0f or revision 0x000e
Detaching Ani

I guess the MAC multicast is not happening. I'll see if I can rustle up
a windows laptop to try this out in and see if it works there.

