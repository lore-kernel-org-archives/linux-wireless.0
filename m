Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab2IRLpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 07:45:16 -0400
Message-ID: <1347968754.4283.6.camel@jlt4.sipsolutions.net> (sfid-20120918_134523_241538_805EA5E7)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: artem.bityutskiy@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 13:45:54 +0200
In-Reply-To: <1347957847.6503.6.camel@jlt4.sipsolutions.net> (sfid-20120918_104337_198974_0F170017)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 (sfid-20120917_163617_677167_0B529F43) <1347952199.6503.3.camel@jlt4.sipsolutions.net>
	 <1347957651.7112.38.camel@sauron.fi.intel.com>
	 <1347957847.6503.6.camel@jlt4.sipsolutions.net>
	 (sfid-20120918_104337_198974_0F170017)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 10:44 +0200, Johannes Berg wrote:

> Thanks. I just got that far as well, but I hadn't set up a DHCP
> server ... I'll debug further, I just confirmed that association still
> works.

Ok I can't reproduce the problem. You're going to have to be more
specific about what connman sets up, I think.

Here's what I did:

 * brctl addbr br0
 * ip addr add ... br0
 * ip link set br0 up
 * start dnsmasq on br0
 * start wpa_supplicant on wlan0, with -Dnl80211 -bbr0 -iwlan0 -c../cfg
 * brctl addif br0 wlan0

Maybe this isn't exactly what connman does, but it works for me with
kernel 3.5.4, a 6230 Intel device and 1.0 wpa_supplicant.

Can you capture exactly what connman does?

Also, are you sure that reverting just the carrier state patch isn't
sufficient? It seems to me that the carrier state patch might confuse
the bridge code, but I really see no reason Eric's change should have
any impact at all.

johannes

