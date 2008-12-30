Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52334 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbYL3Q4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 11:56:18 -0500
Date: Tue, 30 Dec 2008 18:56:09 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	berlin@berlin.freifunk.net
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
Message-ID: <20081230165609.GA6324@jm.kir.nu> (sfid-20081230_175621_631185_BB74543C)
References: <20081230025651.6500@gmx.net> <20081230113714.GA31451@jm.kir.nu> <20081230161539.184750@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081230161539.184750@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 05:15:39PM +0100, Alina Friedrichsen wrote:

> This breaks nothing. I think if you set your BSSID manually, you really don't want that the driver changed it back. If you want this behavior, you don't set it.

But it _does_ break interoperability with standard compliant IBSS
implementations if the forced BSSID means that the STA does not merge
with another part of the IBSS when this should happen by the STA
changing its BSSID to match with the other part. If you do not want the
code behave as described for IBSS, use something else than IBSS..

> Handle BSSID splits in a mile width city mesh network with 500 or more nodes is impossible in a other way, I think. The standard was never written for that dimensions.

Agreed, but we should not claim that the behavior with hardcoded BSSID
would be standard IBSS. It is something different and we should not
confuse users by calling it the same. I would have nothing against
this type of optional feature if it were called something else than IBSS
(or "adhoc" which iwconfig uses for IBSS).

> Besides it fixes a bug that driver want to try to merge with the same BSSID, which is unnecessary and causes problems.

If that fix is separate from the change that introduces hardcoding of
the BSSID, it would be better to bring that in as a separate patch.

-- 
Jouni Malinen                                            PGP id EFC895FA
