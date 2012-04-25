Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45937 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964Ab2DYCOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 22:14:55 -0400
Received: by qatm19 with SMTP id m19so3255840qat.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 19:14:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Apr 2012 19:14:54 -0700
Message-ID: <CAJe-LUjzftkutfu8RZ7GbzH7nKv14Sg5orepAXnWdejwhsjwLg@mail.gmail.com> (sfid-20120425_041459_182468_D4F171BC)
Subject: no 5ghz channels available for hostapd?
From: Mike Mohr <akihana@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good evening;

I've run into a problem with a wireless card (hardware ids: 168c:0029,
ath9k) whose regdomain is programmed in the eeprom to 0x00.  'iw list'
shows all channels in the 5GHz range as either "(passive scanning, no
IBSS)" or "(disabled)".  I'd used madwifi in the past successfully and
only started seeing this problem after upgrading to kernel 3.2.5 and
ath9k.  After some digging I think I've found the culprit:

$ iw reg get
country 00:
        (2402 - 2472 @ 40), (6, 20)
        (2457 - 2482 @ 20), (6, 20), PASSIVE-SCAN, NO-IBSS
        (2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
        (5170 - 5250 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
        (5735 - 5835 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS

trying to fix this situation with 'iw reg set' does nothing,
apparently by design of the driver.  I'm in the US and clearly should
be able to use at least 1 5GHz channel at some power level.  The
output of regdbdump tells the sorry tale: country '00' has a heavily
restricted, 2.4-GHz-only policy.  My guess as to how to proceed is
twofold:

1) Find a way to modify the card's EEPROM and set the regdomain to
whatever value corresponds to the USA.  The probability of success on
this seems to be low, as I have no idea what tools are capable of
doing such modifications.
2) Modify the regulatory.bin file, copying the US values into the '00'
country and replacing the original regulatory.bin with my modified
one.

Can someone provide an alternate solution?

Thanks,
Michael Mohr
