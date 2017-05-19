Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:44152 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdESLp0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 07:45:26 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net
Subject: Re: [PATCH 5/7] mac80211: add wide bandwidth channel switch announcement to CSA action frames and mesh beacons
Date: Fri, 19 May 2017 13:45:19 +0200
Message-ID: <2485332.tTJvvc4NYf@prime> (sfid-20170519_134536_548072_A7CD3A2A)
In-Reply-To: <1495193617.3274.7.camel@sipsolutions.net>
References: <20170516092316.15636-1-sw@simonwunderlich.de> <20170516092316.15636-6-sw@simonwunderlich.de> <1495193617.3274.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3438849.mA4bAlRYcI"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3438849.mA4bAlRYcI
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Johannes,

On Friday, May 19, 2017 1:33:37 PM CEST Johannes Berg wrote:
> I've applied patches 1-4 now.
> 
> The subject is a bit long - I was going to change it to
> 
>     mac80211: mesh: support sending wide bandwidth CSA
>     
>     To support HT and VHT channel switch announcements, both beacons
>     and action frames must include the corresponding IEs.
> 
> but:
> > +		   2 + 2 + sizeof(struct
> > ieee80211_wide_bw_chansw_ie) +
> > +		   2 + sizeof(struct ieee80211_sec_chan_offs_ie) +
> 
> The "2 + 2" should have a comment - no that I'm even really sure that
> you need the wrapper?
> 

right, I'll add a comment. The spec says I need it, and if I understood the 
parsing function correctly it will only search for the wide bw IE when it finds 
the wrapper.

> > -		pos = skb_put(skb, 13);
> > -		memset(pos, 0, 13);
> 
> Removing that is nice - but why do you do this:
> > +		bool have_secondary_chan_offset = false;
> > +		bool have_wide_bandwidth_cs = false;
> > +		int ie_len = 2 + sizeof(struct
> > ieee80211_channel_sw_ie) +
> > +			     2 + sizeof(struct
> > ieee80211_mesh_chansw_params_ie);
> > +
> > +		switch (csa->settings.chandef.width) {
> > +		case NL80211_CHAN_WIDTH_80:
> > +		case NL80211_CHAN_WIDTH_80P80:
> > +		case NL80211_CHAN_WIDTH_160:
> > +			have_wide_bandwidth_cs = true;
> > +			ie_len += 2 + 2 +
> > +				  sizeof(struct
> > ieee80211_wide_bw_chansw_ie);
> > +			break;
> > +		case NL80211_CHAN_WIDTH_40:
> > +			have_secondary_chan_offset = true;
> > +			ie_len += 2 + sizeof(struct
> > ieee80211_sec_chan_offs_ie);
> > +		default:
> > +			break;
> > +		}
> > +		pos = skb_put(skb, ie_len);
> > +		memset(pos, 0, ie_len);
> 
> I think having multiple calls to skb_put() would be better.
> 

OK.

>[...]
> 
> and likewise here.
> 
> That'd also be safer in a way.

Understood, I can change it this way.

Thanks a lot for the feedback!
      Simon

--nextPart3438849.mA4bAlRYcI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlke2s8ACgkQoSvjmEKS
nqFnjhAAr8WKs5bbs25LTJTAhPudDlS7CGL2D41O8k3YpwRqO4NpYueSyoeBpFyq
O3Gcjk+iZ9mzJ+weQ4g4zbf26pNCb/DY8/l0LizPd74o3XpwyZJ2gkxGOwc2QDf1
R5r0xbnBpUZKyVhtPOCZtnRdcU0lc2xsQ4nLkqkEU5FtprIZClwNNdmathe++4PZ
5VgBgqsaROIfQOWM0UkAH+8Je3AZUDmJuWdVsEj0ycazYeTANM0Y2cDLtN2ucqOs
DI9lHjwCJ5Jy/cS7EJD4FNXWGvpjWrP7GwOov2nmtLNA4Mujf77jIMklgIExTMDd
pRYGqXnJPLw/3ZrVVlB3ow27PdcXrXw20k6D3t9MdyrDJX23wsxsxm6oDvvy4YYt
15jUABXyY8nyRRfWAMCKTpi3Zurg9G4abJ5lr+PkpzuByJqzXD3k6vmdwbeGoWHw
UePRkVwiIGqJ/xrTWKzHKwsrskTgBjuHbGTFAYXBOy1Frwo/W776J/6kpWtA9CNB
9GrB1nUmEbNISdx4vPRwR/36iS8R7roMNjpZMpxj7B1UzdJP+KgIFIF8ZNev5zfq
hvJyoaE1GLtrQLQF91YXCdWe4dvCc66ysXbqiv7DznshF/aQwYYSa6dvmfR0plI2
BWyE3rAHMyvLtgNOZSNj/SGJ5vWAe19deqsZMr4Rq0SY5YtibK4=
=4hM3
-----END PGP SIGNATURE-----

--nextPart3438849.mA4bAlRYcI--
