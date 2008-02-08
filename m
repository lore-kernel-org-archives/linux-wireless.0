Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:8531 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbYBHJZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 04:25:40 -0500
Received: by py-out-1112.google.com with SMTP id u52so5391480pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 01:25:38 -0800 (PST)
Message-ID: <43e72e890802080125k684e0196oc975232035ef85e5@mail.gmail.com> (sfid-20080208_092547_039833_F94F6D10)
Date: Fri, 8 Feb 2008 04:25:37 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "Bruno Randolf" <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <1202341955.9965.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1202209693.4395.29.camel@johannes.berg>
	 <20080206024957.22838.82194.stgit@one>
	 <1202341955.9965.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 6, 2008 6:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Looks fine, one last question:
>
> > +             if (mactime <= timestamp) {
> > +                     if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> > +                             printk(KERN_DEBUG "%s: beacon TSF higher than "
> > +                                    "local TSF - IBSS merge with BSSID %s\n",
> > +                                    dev->name, print_mac(mac, mgmt->bssid));
>
> I'd rewrite that as timestamp >= mactime and rename the two variables
> (maybe beacon_timestamp and phy_timestamp or so?), but that's not too
> important. However, in any case "<=" seems wrong, shouldn't we only
> merge when it's actually higher? If your hardware/firmware has synced
> properly and the PHY delay is accounted for properly etc. then every
> beacon from the own BSS will fulfil the == part of the condition, no?
>
> Also, the beacon timestamp is defined as follows:
>
>         A STA sending a beacon shall set the value of the beacon's
>         timestamp so that it equals the value of the STA's TSF timer at
>         the time that the data symbol containing the first bit of the
>         timestamp is transmitted to the PHY plus the transmitting STA's
>         delays through its local PHY from the MAC-PHY interface to its
>         interface with the WM [e.g., antenna, light-emitting diode (LED)
>         emission surface].
>
> (IEEE 802.11 11.1.2)
>
> Since we define the RX timestamp to be when the first data symbol of the
> frame hits the PHY, we here have to take into account the offset between
> the two, at 1 MBit that's 192 (=24 bytes * 8 usecs/byte) usecs earlier
> than the beacon timestamp.
>
> On the other hand, you're unlikely to hit that window, but I suppose it
> warrants at least a comment.

Agreed, "mactime" is pretty vague, if we can add some of the above to
the documentation it would probably help other driver developers.

  Luis
