Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:24951 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYJMWAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:00:53 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1175192wri.5
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 15:00:52 -0700 (PDT)
Message-ID: <43e72e890810131500u289f6e4fwf380966ae8f40b7b@mail.gmail.com> (sfid-20081014_000058_109394_4B226ABE)
Date: Mon, 13 Oct 2008 15:00:52 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Cameron Hutchison" <lists@xdna.net>
Subject: Re: [ath9k-devel] Failed to init on TP-Link TL-WN861N
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <667b.48f192b0.3a106@getafix.xdna.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <667b.48f192b0.3a106@getafix.xdna.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 11, 2008 at 11:01 PM, Cameron Hutchison <lists@xdna.net> wrote:
> I've just loaded linux kernel 2.6.27 onto a box that I have that
> contains a TP-Link TLWN861N atheros minipci card. It identifes as a
> AR5416:
>
> 00:09.0 Network controller: Atheros Communications Inc. AR5416 802.11abgn Wireless PCI Adapter (rev 01)
>        Subsystem: Atheros Communications Inc. Device 2079
>        Flags: 66MHz, medium devsel, IRQ 17
>        Memory at fcfe0000 (32-bit, non-prefetchable) [size=64K]
>        Capabilities: [40] #80 [0000]
>        Kernel modules: ath9k
>
> When I try to load the ath9k module (with all debugging messages
> enabled) I get the following kernel messages:
>
> ath9k: 0.1
> ath9k 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> ath_init: devid 0x23
> ath9k_hw_setpower: AWAKE -> AWAKE (set chip )
> ath9k_hw_do_attach: serialize_regmode is 0
> ath9k_hw_do_attach: This Mac Chip Rev 0x0d.2 is
> ath9k_hw_chip_test: address test failed addr: 0x00008000 - wr:0x00ff00ff != rd:0x00ff00ef

This is during ath9k_hw_chip_test(), which is a simple loop to test
write/read on 2 registers to see if the written values can be read as
the same values. The two registers are:

AR_STA_ID0 which is 0x8000
AR_PHY_BASE + (8 << 2) which is 0x9800 + (8<<2) --> 0x9820

AR_STA_ID0 is used to store part of the MAC address and 0x9820 is just
one of the PHY registers. So we test writing and reading a 256 times
to each register some arbitrary value. We also try writing and reading
some 4 specific patterns just to be sure.

> ath9k_hw_post_attach: hardware self-test failed

This means when it tried to write to a register it then tried reading
the value on the register but didn't get what it was expecting. In
your case we tried writing to register offset 0x8000 the value
0x00ff00ff but read 0x00ff00ef, this test will only continue if the
value read was 0x00ff00ef so for some reason a bit was lost and the
hardware was unable to write the 5th bit on that register.

If we continue this could lead to issues. It seems you may have a
faulty wireless card, specifically bit #5 on register 0x8000. Maybe
the card is loose? Have you seen it working before?

  Luis
