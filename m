Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:21710 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751615AbYBLDZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 22:25:38 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Tue, 12 Feb 2008 12:25:01 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
References: <1202209693.4395.29.camel@johannes.berg> <20080206024957.22838.82194.stgit@one> <1202341955.9965.26.camel@johannes.berg>
In-Reply-To: <1202341955.9965.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200802121225.02045.bruno@thinktube.com> (sfid-20080212_032542_688045_E2D16EC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 February 2008 08:52:35 Johannes Berg wrote:
> Looks fine, one last question:
> > +		if (mactime <=3D timestamp) {
> > +			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> > +				printk(KERN_DEBUG "%s: beacon TSF higher than "
> > +				       "local TSF - IBSS merge with BSSID %s\n",
> > +				       dev->name, print_mac(mac, mgmt->bssid));
>
> I'd rewrite that as timestamp >=3D mactime and rename the two variabl=
es
> (maybe beacon_timestamp and phy_timestamp or so?), but that's not too
> important.

i'll do that, sure.

> However, in any case "<=3D" seems wrong, shouldn't we only=20
> merge when it's actually higher? If your hardware/firmware has synced
> properly and the PHY delay is accounted for properly etc. then every
> beacon from the own BSS will fulfil the =3D=3D part of the condition,=
 no?

true. i was not aware that the beacon timestamp is taking PHY delays in=
to=20
account and wrongly asumed that the RX timestamp should always be a bit=
=20
later.
(which is also what i saw on my atheros hardware: we usually get the RX=
=20
timestamp about 60 to 300 usec later than the beacon timestamp, but it'=
s=20
quite likely that we have not calibrated everything 100% correctly.)

> Also, the beacon timestamp is defined as follows:
>
>         A STA sending a beacon shall set the value of the beacon=E2=80=
=99s
>         timestamp so that it equals the value of the STA=E2=80=99s TS=
=46 timer at
>         the time that the data symbol containing the first bit of the
>         timestamp is transmitted to the PHY plus the transmitting STA=
=E2=80=99s
>         delays through its local PHY from the MAC-PHY interface to it=
s
>         interface with the WM [e.g., antenna, light-emitting diode (L=
ED)
>         emission surface].
>
> (IEEE 802.11 11.1.2)
>
> Since we define the RX timestamp to be when the first data symbol of =
the
> frame hits the PHY, we here have to take into account the offset betw=
een
> the two, at 1 MBit that's 192 (=3D24 bytes * 8 usecs/byte) usecs earl=
ier
> than the beacon timestamp.
>
> On the other hand, you're unlikely to hit that window, but I suppose =
it
> warrants at least a comment.

thats a very good point! if everything was calibrated properly and all =
delays=20
taken into account *exactly* that would cause us to go thru a merge all=
 the=20
time, on every received beacon. i think we have to take that into accou=
nt,=20
for different bitrates. what about something like:

timestamp >=3D ( mactime + (24 * 8 / beacon_phy_rate_in_mbps ))

i'll resend my patch adding that and the other proposed changes soon.

bruno
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
