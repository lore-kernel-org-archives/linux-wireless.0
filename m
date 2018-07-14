Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:43500 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731583AbeGNX6S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Jul 2018 19:58:18 -0400
Received: by mail-io0-f178.google.com with SMTP id y10-v6so19654448ioa.10
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jul 2018 16:37:33 -0700 (PDT)
MIME-Version: 1.0
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 15 Jul 2018 01:37:21 +0200
Message-ID: <CACRpkdbdt5Jxa+=4kBGEjRdiVwv9Py3Lo5ngxB-sZO-Xgzb09g@mail.gmail.com> (sfid-20180715_013748_960399_C42423C2)
Subject: RT2880F based iNIC mini-PCI network card
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm curious to hear if you have hints of this beast:

lspci:
00:0c.0 Class 0200: 1814:0801

AFAICT this is a ralink Mini PCI using the RT2880F dubbed
"iNIC" (intelligent NIC).

It is found sometimes soldered (!) onto the mini PCI sockets
in a few select routers.

I am trying to us it with D-Link DIR-685, the same mini PCI is
found in Asus DSL-N13, Asus WL-127n, Alcatel Lucent Cellpipe
7130, Pegatron WL227N-5G Wireless Card, and the Billion BiPAC
7800N.

I would try to hack on rt2xxx but I simply have no source code
for this, there are GPL drops for some of the above routers but
they just contain binaries, often in a path like this:
ralink_RT2880_iNIC/v1.1.8.3/build/module-v1.1.8.3

A DD-WRT source tree contained this:
#obj-$(CONFIG_RT2880v2_INIC_MII) += iNIC/mii/
#obj-$(CONFIG_RT2880v2_INIC_PCI) += iNIC/pci/

So there is apparently even a v2 version.

The board photos shows a RT2880F and a RT2850L antenna
driver on the board (the latter in a shield box).

Has someone seen a vendor tree where this leaked out by
mistake or so?

Any other hints to get it going?

I tried just adding the PCI IDs of course. The card reports back
as type "0000" making me suspect it does not behave like all the
others :(

Yours,
Linus Walleij
