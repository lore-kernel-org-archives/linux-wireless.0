Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49887 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaIJIuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 04:50:20 -0400
Message-ID: <1410339003.2761.2.camel@jlt4.sipsolutions.net> (sfid-20140910_105026_611263_FA6A22FB)
Subject: Re: 802.11p rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, burak.simsek@volkswagen.de,
	s.sander@nordsys.de, sojkam1@fel.cvut.cz,
	jan-niklas.meier@volkswagen.de, emmanuel.thierry@yogoko.fr,
	thierry.ernst@yogoko.fr, oyunaash@gmail.com,
	laszlo.virag@commsignia.com
Date: Wed, 10 Sep 2014 10:50:03 +0200
In-Reply-To: <1410193824.10388.24.camel@umadbro> (sfid-20140908_183026_729762_39C348F0)
References: <1410193824.10388.24.camel@umadbro>
	 (sfid-20140908_183026_729762_39C348F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-08 at 18:30 +0200, Rostislav Lisovy wrote:

> The possible (first implementation) solution might be either to
> implement some "dummy" rate control algorithm that will set a fixed
> datarate only once (during "ocb join" command) or to use the Minstrel
> while limiting the allowed datarate to be the lowest one; i.e.
>     mand_rates = ieee80211_mandatory_rates(sband, scan_width);
>     sta->sta.supp_rates[band] =
>         find_first_bit(&mand_rates, sizeof(u32));

That's pretty much already done anyway since you'd restrict the
supported rates to the ones that are, well, supported :)

So I don't think you need to do anything here except set up the station
correctly.


> If I am not mistaken, it is not possible to live without an in-kernel
> rate_control algorithm?
> One interesting idea I got from one colleague is to implement the
> algorithm logic in the user-space -- kernel would contain just a thin
> shell controlled from the user-space (via netlink?). This is probably
> not as insane as it may sound since the purpose of the rate-control
> algorithm for 802.11p (at least for ITS-G5) is not to "maximize the
> immediate throughput" but more like "shared medium congestion control",
> which may require much slower frequency of a control loop.

I'm not really convinced this is feasible, but in any case - are you
even communicating long enough with a single peer to make rate control
feasible?


Anyway - it seems to me that you're getting ahead of yourself. Shouldn't
you actually have a functioning datapath before worrying about rate
control? And for that you'll need station handling in mac80211, etc.

johannes

