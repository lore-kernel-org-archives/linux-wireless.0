Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:60351 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbYLFPD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 10:03:26 -0500
Received: by ug-out-1314.google.com with SMTP id 39so244011ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 07:03:25 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 6 Dec 2008 16:03:16 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812061511.05473.hrogge@googlemail.com> <1228575081.16752.8.camel@johannes.berg>
In-Reply-To: <1228575081.16752.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1991914.5Z45aZpOv7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812061603.21930.hrogge@googlemail.com> (sfid-20081206_160330_379630_B3D29BB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1991914.5Z45aZpOv7
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 December 2008 15:51:20 Johannes Berg wrote:
> > Okay, here is v6 of my patch... feel free to rip it apart. ;)
>
> Heh. Please inline patches, makes it much easier.
Resend it inlined... but you were a little bit too fast... ;)

> I'd drop the _STA_ part from these and do RATE_INFO_... since we may end
> up using these for other things potentially. Not sure we will, but who
> knows. I could imagine using it to fix a transmit rate, for example, and
> then it wouldn't necessarily be per station.
Okay, will be done in v7

> > + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package
> > (u8, dBm)
>
> packet, or, more accurately, PPDU I guess
ok.

> > + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested
> > attribute + *  containing info as possible, see &enum
> > nl80211_sta_info_txrate.
>
> Please indent with a tab here

> > + * @STATION_INFO_RX_BITRATE: @rx_bitrate filled
> > + * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
> > + *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
> >   */
> >  enum station_info_flags {
> >         STATION_INFO_INACTIVE_TIME      =3D 1<<0,
> > @@ -177,6 +181,25 @@ enum station_info_flags {
> >         STATION_INFO_LLID               =3D 1<<3,
> >         STATION_INFO_PLID               =3D 1<<4,
> >         STATION_INFO_PLINK_STATE        =3D 1<<5,
> > +       STATION_INFO_SIGNAL             =3D 1<<6,
> > +       STATION_INFO_RX_BITRATE         =3D 1<<7,
>
> RX bitrate?
Okay, it seems I missed one place to remove the RX one... thought I had got=
=20
all of them.

> > +/**
> > + * enum station_info_rate_flags - station transmission rate flags
> > + *
> > + * Used by the driver to indicate the specific rate transmission
> > + * type for 802.11n transmissions.
> > + *
> > + * @STATION_INFO_BITRATE_MCS: @tx_bitrate_mcs filled
> > + * @STATION_INFO_BITRATE_40_MHZ_WIDTH: 40 Mhz width transmission
> > + * @STATION_INFO_BITRATE_SHORT_GI: 400ns guard interval
> > + */
> > +enum station_info_rate_flags {
> > +       STATION_INFO_BITRATE_MCS                =3D 1<<0,
> > +       STATION_INFO_BITRATE_40_MHZ_WIDTH       =3D 1<<1,
> > +       STATION_INFO_BITRATE_SHORT_GI           =3D 1<<2,
> >  };
>
> Same here as the first comment, this is rate specific, so I'd call these
> BITRATE_* or something like that.
okay.

> >  /**
> > @@ -191,6 +214,11 @@ enum station_info_flags {
> >   * @llid: mesh local link id
> >   * @plid: mesh peer link id
> >   * @plink_state: mesh peer link state
> > + * @signal: signal strength of last received package in dBm
> > + * @txrate_total: current unicast bitrate to this station in 100
> > kbit/sec + * @txrate_flags: bitflag of flags from &enum
> > station_info_bitrate_flags + * @txrate_mcs: MCS index of a 802.11n
> > transmission, see
> > + *  &enum station_info_bitrate_flags
> >   */
> >  struct station_info {
> >         u32 filled;
> > @@ -200,6 +228,10 @@ struct station_info {
> >         u16 llid;
> >         u16 plid;
> >         u8 plink_state;
> > +       u8 signal;
> > +       u16 txrate_total;
> > +       u8 txrate_flags;
> > +       u8 txrate_mcs;
>
> can you please move the rate parts into a new struct, so we can use
> tx.flags, tx.mcs etc. and later just need to add a second instance of
> the struct for rx

struct bitrate_info ?
or maybe
struct cfg80211_bitrate_info ?

> > +static u16 sta_get_80211n_bitrate(struct ieee80211_tx_rate *rate)
> > +{
> > +       int modulation =3D rate->idx & 7;
> > +       int streams =3D rate->idx >> 3;
> > +
> > +       int bitrate =3D (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
> > 13500000 : 6500000; +
> > +       if (modulation < 4)
> > +               bitrate *=3D (modulation + 1);
> > +       else if (modulation =3D=3D 4)
> > +               bitrate *=3D (modulation + 2);
> > +       else
> > +               bitrate *=3D (modulation + 3);
> > +
> > +       bitrate *=3D streams;
> > +
> > +       if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
> > +               bitrate =3D (bitrate * 10) / 9;
> > +
> > +       return (bitrate + 50000) / 100000; // do NOT just round down
> > +}
>
> Don't use // comments please, see Documentation/CodingStyle.
Copypasta error from the "pseudocode", sorry.

> Also, if we really really need this information (I still don't see why
> the kernel has to calculate it) then it should be in cfg80211 not
> mac80211 so other drivers could potentially make use of it. Personally,
> I'd just leave it out though.
Hmm... is "cfg.c" not part of cfg80211 ?

> >         sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
> >                         STATION_INFO_RX_BYTES |
> > -                       STATION_INFO_TX_BYTES;
> > +                       STATION_INFO_TX_BYTES |
> > +                       STATION_INFO_RX_BITRATE |
> > +                       STATION_INFO_TX_BITRATE;
>
> RX?
Another one... I think I will have to post a v7 patch this weekend...

> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -727,8 +727,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data
> > *rx) if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
> >                 u8 *bssid =3D ieee80211_get_bssid(hdr, rx->skb->len,
> >                                                 NL80211_IFTYPE_ADHOC);
> > -               if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =
=3D=3D
> > 0) +               if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid)
> > =3D=3D 0) { sta->last_rx =3D jiffies;
> > +               }
> >         } else
> >         if (!is_multicast_ether_addr(hdr->addr1) ||
> >             rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
>
> That looks unintended
Yes.. I removed the "else" part for the rx_rate, but left the {} there.

> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index 9caee60..197dc4d 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/netlink.h>
> >  #include <net/genetlink.h>
> >  #include <net/cfg80211.h>
> > +#include <net/mac80211.h>
>
> Ahem. Please observe the layering, cfg80211 and nl80211 are strictly
> below mac80211.
>
>
> I'd rename _TOTAL to _LEGACY and remove the calculation for MCS rates,
> that way it's obviously clear what you're getting in userland.
We need the "total bitrate" for 802.11abg rates. They have no mcs rates.
The "legacy index" for non 802.11n bitrates points to a hw specific "band"=
=20
array, so I don't think we can export it to userspace as an index.

Henning

--nextPart1991914.5Z45aZpOv7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk6lDkACgkQcenvcwAcHWeeHACeJEDFMQ17NDaid1eYGLPxuZtj
beYAn3jIt51KyTmFJ1H/E32apBHWtqZ6
=vgps
-----END PGP SIGNATURE-----

--nextPart1991914.5Z45aZpOv7--
