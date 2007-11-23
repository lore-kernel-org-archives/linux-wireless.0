Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5301 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXKWIFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 03:05:41 -0500
Received: from lin01.mn-solutions.de (pD95F8443.dip0.t-ipconnect.de [217.95.132.67])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id A21815E5822
	for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 09:05:39 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id C94701E00FD
	for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 09:02:44 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Fri, 23 Nov 2007 09:06:10 +0100
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <20071122132635.GA3372@tuxdriver.com> <1195777405.11966.12.camel@dv>
In-Reply-To: <1195777405.11966.12.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711230906.10441.hs4233@mail.mn-solutions.de> (sfid-20071123_080548_253543_461FC266)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think setting the key should not cause reassociation if
> there is an association.

That seems sensible.


I actually think that while it's not associated, it should 
periodically try to associcate with what's currently defined 
(e.g. ESSID, fixed AP mac, key settings etc).

Currently, if I do the following with mac80211/b43:

$ # turn AP off or move into an area where you can't
  receive the AP
$ pccardctl insert
$ ifconfig eth1 up
$ iwconfig eth1 key s:11111
$ iwconfig eth1 essid MUMBLFUTZ
$ # turn AP on or move with the laptop/device into the
  vincinity of an AP

... then I won't get an association at all.

Other drivers that I used in production during the last 5 years 
didn't show that behavior (orinoco_cs, wlags_h1_cs, wlags_h2_cs, 
madwifi). They associated on their own.

However, as mac80211 is currently implemented, it assumes 
a "stationary" WLAN setup and doesn't cope well with scenarios 
where devices move. If it would cope better with such 
situations, then it would also cope with the first problem I 
reported. Because if it would periodically re-scan and try to 
associate, a later submitted or changed WEP key would be taken 
into account and association would have succeeded.
