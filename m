Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63132 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbZCLExL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 00:53:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 21:53:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18872.37947.937169.925446@gargle.gargle.HOWL> (sfid-20090312_055312_896106_57D55DF0)
Date: Thu, 12 Mar 2009 10:18:59 +0530
To: Vladimir Senkov <hangup@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k panic when connecting to 802.11n-enabled AP
In-Reply-To: <18872.37875.417055.649869@gargle.gargle.HOWL>
References: <14df1c3e0903112141w645c716bu47e2309353527535@mail.gmail.com>
	<18872.37875.417055.649869@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith wrote:
> Vladimir Senkov wrote:
> > My client machine (running wireless-testing kernel updated with git
> > today) panics when connecting to a hostapd access point (also running
> > ath9k) only when 802.11n is enabled on the access point.
> > More specifically, here is the hostapd configuration that causes the
> > client to crash:
> > ieee80211n=0
> > ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]
> 
> ieee80211n should be 1 to enable 11n.
> 
> > If I disable 802.11n on the access point everything works ok.
> > Interesting enough, access point machine never crashes. At one point
> > both access point and client machine ran identical code and client
> > would always crash while the access point box would stay up. So
> > upgraded client to the latest and greatest and tried a few versions in
> > between, this panic has been very consistent. It always panics right
> > after 1st attempt to associate.
> > 
> > I was able to narrow down the panic to this assert ath_rc_ratefind_ht() in rc.c:
> >         ASSERT((rate_table->info[rate].valid && !ath_rc_priv->single_stream) ||
> >                (rate_table->info[rate].valid_single_stream &&
> >                 ath_rc_priv->single_stream));
> > When I ifdef'ed this assert panic went away and everything sort of
> > worked (haven't tested it heavily), but the performance dropped to
> > about 700Kbps. I usually get 10x when 802.11n is off and there is no
> > panic.
> > 
> > Has anyone else seen this?
> 
> A couple of bugs were fixed dealing with this issue, but looks like more
> lurk around. Can you attach the hostapd.conf, hostapd logs (hostapd -d),
> client side kernel logs [1] ?, from loading the driver to the point when you associate
> and get the panic.
> 
> [1]: See http://wireless.kernel.org/en/users/Drivers/ath9k on how to enable debug.
> 

Oh, and using debug=0x2000 would be sufficient.

Sujith
