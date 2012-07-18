Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:37867 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754152Ab2GRMDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:03:30 -0400
To: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org
Cc: feint@lists.subsignal.org
Message-ID: <1342612598.5006a476022c6@mail.bluebottle.com> (sfid-20120718_140343_258062_EC0792D9)
Date: Wed, 18 Jul 2012 12:56:38 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
Subject: WRT54g / b43 / mac802.11 BREAKTHROUGH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi devs!

yesterday we had a breaktrough debugging b43 in our hackspace maschinenraum/m18[1,2]
at weimar.freifunk.net[3,4] - since a long time our darling wrt54g suffers from a
hanging wifi and bad performance[5], but the workaround is easy: now it's up to
you to fix the rootcause.

our testsetup, where we could _reproduce_ reliably a stopping TX is like this:

laptop ---lan--- "A"-wrt54g/adhoc ~~~   air  ~~~ "B"-anyrouter/adhoc

now make a testdownload with the laptop from B.
wireless will stop working after ~10 seconds.

wifi up will reanimate and our freifunk-cron.minutely-check
will do this automagically. (read further, this is not the solution)

we tried to limit the rateset to e.g. lower rates, but this does NOT change
the behaviour. what works is: define a rateset on BOTH router which makes
it impossible to change the band, e.g.:

iw dev $WIFIDEV set bitrates legacy-2.4 1 2 5.5 11
OR
iw dev $WIFIDEV set bitrates legacy-2.4 6 9 12 18 24 36 48 54

now we had a great performance, 10 Gigabytes of wireless transfer,
no stopping TX anymore and an empty box of beer. three things to do now:

1) why does a band change (can be seen through minstrel) is a problem?

2) we have to make in config-option to force a band, or a rateset:
	e.g. uci set wireless.radio0.hwmode=11g
	e.g. uci set wireless.radio0.bitrates='6 9 12 18 24 36 48 54'

3) spread to word:
   there is a great frustration in the community about b43,
   but the old drivers _have_ to die, it's about time - really.

thanks for your work,
bye storchi, andi, bastian + m18 crew

[1] http://blog.maschinenraum.tk/
[2] http://blog.maschinenraum.tk/2012/07/15/bitcoin-vending-machine-exchange-euro-coins-for-bitcoin-wallets/
[3] http://wireless.subsignal.org
[4] http://wireless.subsignal.org/index.php?title=Main_Page_en
[5] https://dev.openwrt.org/ticket/7552

