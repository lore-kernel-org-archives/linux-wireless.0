Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48310 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751530AbYL3QPl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 11:15:41 -0500
Cc: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	berlin@berlin.freifunk.net
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 30 Dec 2008 17:15:39 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20081230113714.GA31451@jm.kir.nu>
Message-ID: <20081230161539.184750@gmx.net> (sfid-20081230_171546_161437_5C87B929)
MIME-Version: 1.0
References: <20081230025651.6500@gmx.net> <20081230113714.GA31451@jm.kir.nu>
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni!

> This is not how IEEE 802.11 IBSS is supposed to work. If there are
> issues in IBSS splits, merges, or timesync, I would consider fixes to
> those to be preferred over hacks that hide the issues and cause
> interoperability issues with standard compliant IBSS implementations.

This breaks nothing. I think if you set your BSSID manually, you really=
 don't want that the driver changed it back. If you want this behavior,=
 you don't set it.
Handle BSSID splits in a mile width city mesh network with 500 or more =
nodes is impossible in a other way, I think. The standard was never wri=
tten for that dimensions.

Besides it fixes a bug that driver want to try to merge with the same B=
SSID, which is unnecessary and causes problems.

See:
http://wiki.villagetelco.org/index.php/Information_about_cell-id_splitt=
ing%2C_stuck_beacons%2C_and_failed_IBSS_merges!#The_phenomenon_of_IBSS-=
ID_cell_splits

> Anyway, since I don't really care that much about IBSS

We need it much here in the "Freifunk" mesh network of Berlin.

> to actually start
> using lots of time to fix problems there, I would not object to this
> type of change as long it does not change the default behavior (i.e.,=
 by
> default, mac80211 should operate in standard compliant manner) and th=
e
> users are not mislead to enable such a hack while still believing tha=
t
> their devices are operating in a standard IBSS.

ACK

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
