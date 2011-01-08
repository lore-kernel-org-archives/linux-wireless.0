Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1AHGOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 01:14:12 -0500
Received: by wyb28 with SMTP id 28so18051891wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 22:14:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110107202224.GI21588@tux>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com>
	<20110107024432.GC20431@tux>
	<201101071111.17423.helmut.schaa@googlemail.com>
	<AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com>
	<20110107202224.GI21588@tux>
Date: Fri, 7 Jan 2011 22:14:10 -0800
Message-ID: <AANLkTintU_vSt5eWoma4_d9tNCxPpOfpGZMq7XXppjpP@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Luis Correia <buga@loide.net>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 12:22 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> You may want to try checing the 'iw event -t' output while the issue happens.

Running 'iw event -t' shows a lot of disassociation due to inactivity.
 This happens even if there is regular flow of traffic (for example, I
start ping to my AP and leave it running, or I leave Pandora streaming
music in the browser).

Below is example of output of 'iw event -t' (these lines repeat in the
output at irregularl intervals):

1294464037.037450: wlan0 (phy #0): deauth 00:1c:10:ea:2a:cb ->
00:1e:52:79:e9:ff reason 4: Disassociated due to inactivity
1294464037.037538: wlan0 (phy #0): disconnected (local request)
1294464037.051747: phy #0: regulatory domain change: set to world
roaming by the wireless core upon initialization request
1294464037.143040: wlan0 (phy #0): scan started
1294464040.158920: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
2432 2437 2442 2447 2452 2457 2462 2467 2472 2484 5180 5190 5200 5220
5230 5240 5745 5755 5765 5785 5795 5805 5825, ""
1294464041.799682: wlan0 (phy #0): auth 00:1e:52:79:e9:ff ->
00:1c:10:ea:2a:cb status: 0: Successful
1294464041.811304: wlan0: new station 00:1e:52:79:e9:ff
1294464041.841934: wlan0 (phy #0): assoc 00:1e:52:79:e9:ff ->
00:1c:10:ea:2a:cb status: 0: Successful
1294464041.842021: wlan0 (phy #0): connected to 00:1e:52:79:e9:ff
1294464041.877275: phy #0: regulatory domain change: set to US by a
country IE request on phy0

I also noticed that from time to time there would be periods when ping
round trip times would become very irregular, ranging from 3ms to 3-4
seconds (normally, they would be consistently in approximately 3-4ms
range).  These periods of high ping latencies do not seem to coincide
with connection drops between wireless card and AP.  The periods of
high ping latency would sometime last for few seconds, sometimes for
few minutes.  For example (an shorter one):

64 bytes from 192.168.0.1: icmp_req=600 ttl=255 time=3.37 ms
64 bytes from 192.168.0.1: icmp_req=601 ttl=255 time=3.36 ms
64 bytes from 192.168.0.1: icmp_req=602 ttl=255 time=3.37 ms
64 bytes from 192.168.0.1: icmp_req=603 ttl=255 time=7.38 ms
64 bytes from 192.168.0.1: icmp_req=604 ttl=255 time=3.23 ms
64 bytes from 192.168.0.1: icmp_req=605 ttl=255 time=3.73 ms
64 bytes from 192.168.0.1: icmp_req=606 ttl=255 time=3.26 ms
64 bytes from 192.168.0.1: icmp_req=607 ttl=255 time=2665 ms
64 bytes from 192.168.0.1: icmp_req=608 ttl=255 time=1658 ms
64 bytes from 192.168.0.1: icmp_req=609 ttl=255 time=650 ms
64 bytes from 192.168.0.1: icmp_req=610 ttl=255 time=1538 ms
64 bytes from 192.168.0.1: icmp_req=611 ttl=255 time=530 ms
64 bytes from 192.168.0.1: icmp_req=612 ttl=255 time=1417 ms
64 bytes from 192.168.0.1: icmp_req=613 ttl=255 time=409 ms
64 bytes from 192.168.0.1: icmp_req=614 ttl=255 time=1298 ms
64 bytes from 192.168.0.1: icmp_req=615 ttl=255 time=290 ms
64 bytes from 192.168.0.1: icmp_req=616 ttl=255 time=1172 ms
64 bytes from 192.168.0.1: icmp_req=617 ttl=255 time=164 ms
64 bytes from 192.168.0.1: icmp_req=618 ttl=255 time=1046 ms
64 bytes from 192.168.0.1: icmp_req=619 ttl=255 time=41.0 ms
64 bytes from 192.168.0.1: icmp_req=620 ttl=255 time=923 ms
64 bytes from 192.168.0.1: icmp_req=621 ttl=255 time=0.561 ms
64 bytes from 192.168.0.1: icmp_req=622 ttl=255 time=44.8 ms
64 bytes from 192.168.0.1: icmp_req=623 ttl=255 time=26.9 ms
64 bytes from 192.168.0.1: icmp_req=624 ttl=255 time=1609 ms
64 bytes from 192.168.0.1: icmp_req=625 ttl=255 time=610 ms
64 bytes from 192.168.0.1: icmp_req=626 ttl=255 time=1494 ms
64 bytes from 192.168.0.1: icmp_req=627 ttl=255 time=488 ms
64 bytes from 192.168.0.1: icmp_req=628 ttl=255 time=1391 ms
64 bytes from 192.168.0.1: icmp_req=629 ttl=255 time=383 ms
64 bytes from 192.168.0.1: icmp_req=630 ttl=255 time=3.42 ms
64 bytes from 192.168.0.1: icmp_req=631 ttl=255 time=3.43 ms
64 bytes from 192.168.0.1: icmp_req=632 ttl=255 time=3.20 ms
64 bytes from 192.168.0.1: icmp_req=633 ttl=255 time=3.91 ms
64 bytes from 192.168.0.1: icmp_req=634 ttl=255 time=3.24 ms
64 bytes from 192.168.0.1: icmp_req=635 ttl=255 time=3.74 ms
64 bytes from 192.168.0.1: icmp_req=636 ttl=255 time=3.36 ms
64 bytes from 192.168.0.1: icmp_req=637 ttl=255 time=3.39 ms
