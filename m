Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37066 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbcC3UCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 16:02:15 -0400
Received: by mail-ig0-f176.google.com with SMTP id l20so51786328igf.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 13:02:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1186227012.1763514.1459302043299.JavaMail.yahoo@mail.yahoo.com>
References: <CAJ-VmomakNNn2oUQ+HfPrA=d5QXkAfnLixOBF5twX9yL3bRetA@mail.gmail.com>
	<1186227012.1763514.1459302043299.JavaMail.yahoo@mail.yahoo.com>
Date: Wed, 30 Mar 2016 13:02:14 -0700
Message-ID: <CAJ-Vmomxbp4j3kmHOwf8AXB+s7jEDZGSR0j2Da=TjU324eHvNg@mail.gmail.com> (sfid-20160330_220217_836728_FD46EEAD)
Subject: Re: Bonjour mDNS broacast can be lost during BT-WLAN coexistence schemes?
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I don't know if you can do simulaneous wlan and BT RX - especially
since WLAN RX sometimes requires ACKs to be sent. :) But for
multicast, sure. You'd have to check the NIC schematic and antenna
switch programming to see if you can do simultaneous wlan RX (with no
TXing, eg RTS/CTS, ACK, etc) whilst also doing BT RX.

As for BT_ACTIVE -> powersave; I don't think you can get interrupts
based on that, but you can poll the gpio pin yourself and then tell
the driver to not transmit and/or enter sleep state. Entering sleep
state requires that you send some frame anyway to tell the AP you're
going to sleep.


-a
