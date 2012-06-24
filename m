Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37375 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2FXTLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 15:11:51 -0400
Received: by weyu7 with SMTP id u7so2328415wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2012 12:11:50 -0700 (PDT)
MIME-Version: 1.0
From: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
Date: Sun, 24 Jun 2012 16:11:27 -0300
Message-ID: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com> (sfid-20120624_211155_217283_DE3783DC)
Subject: Regression on ath9k_htc managed mode
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello nice people,
we've recently found a bug when using infrastructure mode with tplink
wn722n usb dongles (ath9k_htc driver)

on the latest compat mac80211 we could find (2012-06-14) compiled
against a 3.3.8 kernel, it has a problem with receiving broadcast
while in client mode.
That is, if the card is in Managed mode, it associates correctly,
sends and receives unicast packets perfectly, and can send broadcast
packets too. But no packets sent to broadcast from the AP will be
understood.
This has been observed with a simple arping
[x.x.x.x being the ap, and y.y.y.y being the dongle in client mode.]
sta# arping -b -I wlan1 x.x.x.x
ARPING to x.x.x.x from y.y.y.y via wlan1
Unicast reply from x.x.x.x [f8:d1:11:c0:ef:72] 108.579ms
Unicast reply from x.x.x.x [f8:d1:11:c0:ef:72] 108.157ms

ap# arping -b -I wlan1 y.y.y.y
ARPING to y.y.y.y from x.x.x.x via wlan1
[no replies]

wireshark running on a separate laptop confirmed that the ap is indeed
transmitting the broadcast, but a tcpdump running on client station
shows no trace of the packet.
unicasts, on the other hand, are received perfectly (both seen by
wireshark on the air, and tcpdump in the station)

This behaviour does not happen with mac80211 2012-02-27 compiled against 3.2.14
I've recompiled many different versions of openwrt in a "bisecting"
manner and managed to narrow it down to commit r31322 of openwrt,
"mac80211: update to wireless-testing 2012-04-13"
so the regression has been introduced somewhere between 2012-02-27
(ok) and 2012-04-13 (bug)

I *could* try to narrow it further, by cherrypicking revisions of
wireless-testing between those dates, and try to compile a custom
openwrt (i'm not sure how would that work) but I have already spent a
lot more time than i was expecting to get to this point :(

So maybe some developer, or someone more familiar with the changelog,
might have an idea when /where (commit) could this bug have crept in,
and have a kind soul as to find a fix, or revert it?

We would be most grateful, we are building wifi community networks in
Argentina, with very low cost mesh nodes, based on tplink mr3220 and
these wn722n dongles, and the model we are using is being adopted by
many local WCN, so a fix would be of great help!

Guido

ps. I'm crossposting to compat-wireless since i don't entirely
understand where the problem lies. Sorry for the noise!
