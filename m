Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45612 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaIHQ4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:48 -0400
Message-ID: <540DDFC8.5050000@openwrt.org> (sfid-20140908_185652_972938_A9380D50)
Date: Mon, 08 Sep 2014 18:56:40 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
CC: burak.simsek@volkswagen.de, s.sander@nordsys.de,
	sojkam1@fel.cvut.cz, jan-niklas.meier@volkswagen.de,
	emmanuel.thierry@yogoko.fr, thierry.ernst@yogoko.fr,
	oyunaash@gmail.com, laszlo.virag@commsignia.com
Subject: Re: 802.11p rate control
References: <1410193824.10388.24.camel@umadbro>
In-Reply-To: <1410193824.10388.24.camel@umadbro>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-09-08 18:30, Rostislav Lisovy wrote:
> The possible obstacles are:
> * 802.11p will be used mainly for two independent C2X protocol stacks --
> one is the European ETSI ITS-G5, the other one is the US WAVE (IEEE
> 1609). I assume that these two protocol stack implementations will
> differ mainly in the user-space while the kernel part will be the same.
> * ITS-G5 already speaks about the "default datarate" for different
> channels ([1] 4.3, Table 2) -- i.e. 6 Mbit/s for channel no. 180; 12
> Mbit/s for channel no. 178. This should be probably defined when
> "joining the network" on a fixed channel.
> 
> The possible (first implementation) solution might be either to
> implement some "dummy" rate control algorithm that will set a fixed
> datarate only once (during "ocb join" command) or to use the Minstrel
> while limiting the allowed datarate to be the lowest one; i.e.
>     mand_rates = ieee80211_mandatory_rates(sband, scan_width);
>     sta->sta.supp_rates[band] =
>         find_first_bit(&mand_rates, sizeof(u32));
> 
> If I am not mistaken, it is not possible to live without an in-kernel
> rate_control algorithm?
> One interesting idea I got from one colleague is to implement the
> algorithm logic in the user-space -- kernel would contain just a thin
> shell controlled from the user-space (via netlink?). This is probably
> not as insane as it may sound since the purpose of the rate-control
> algorithm for 802.11p (at least for ITS-G5) is not to "maximize the
> immediate throughput" but more like "shared medium congestion control",
> which may require much slower frequency of a control loop.
I think doing this in userspace is overkill. minstrel should be able to
handle rate control for 802.11p just fine if you set up the supported
rates properly.

By the way, minstrel does not try to "maximize the immediate
throughput", it tries to maximize the ratio of throughput vs used
airtime, which should be good for 802.11p as well.

- Felix
