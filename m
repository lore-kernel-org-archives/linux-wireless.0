Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbYAWR2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 12:28:04 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <bruno@thinktube.com>, mcgrof@gmail.com,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1201099729.3454.17.camel@johannes.berg>
References: <20080118125252.6455.41047.stgit@one>
	 (sfid-20080118_125251_383020_9A9C2A8A)  <1201099729.3454.17.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Wed, 23 Jan 2008 12:22:26 -0500
Message-Id: <1201108946.4929.49.camel@localhost.localdomain> (sfid-20080123_172814_637684_BDD8228A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-01-23 at 15:48 +0100, Johannes Berg wrote:
> > enable IBSS cell merging. if an IBSS beacon with the same ESSID and=
 a TSF
> > higher than the local TSF (mactime) is received, we have to join it=
s BSSID.
>=20
> Can you back that up with standard references? I see no such requirem=
ent
> in the standard text. I can see that under some circumstances this ma=
y
> be desirable, but maybe not.
>=20
> In fact, this seems to *break* standard behaviour, as per 11.1.3.1:
> (emphasis mine)

The way I understood Ad-Hoc to work was that if you weren't using the
SSID + BSSID as somebody else, you weren't part of that adhoc network.
Ad-Hoc + roaming isn't supported and is even less defined, which is wha=
t
this patch would enable IIUC.  When joining an adhoc network, your
card/driver must scan around to find the SSID + (optionally) BSSID of
that adhoc network.  If it finds one that matches criteria, it joins
that adhoc network, which means using the same BSSID.  If it doesn't, i=
t
creates a new adhoc network with a generated BSSID and the specified
SSID.

If this patch were applied, then you'd pretty quickly get split adhoc
networks where some people were automatically moved to a different BSSI=
D
and the rest are left on the old BSSID (maybe missed a beacon, or
whatever), and therefore can't talk to each other.  If only because
mac80211 would jump adhoc BSSIDs, while all other drivers (including
fullmac parts) would not.

A cell is identified uniquely by the combination of BSSID + SSID,
nothing less.  You don't combine infrastructure networks of the same
SSID and a different BSSID, nor does this happen for adhoc.

Dan

>         When a STA starts a BSS, that STA shall determine the BSSID o=
f
>         the BSS. If the BSSType indicates an infrastructure BSS, then
>         the STA shall start an infrastructure BSS and the BSSID shall=
 be
>         equal to the STA=E2=80=99s dot11StationID. ***The value of th=
e BSSID
>         shall remain unchanged***, even if the value of dot11StationI=
D
>         is changed after the completion of the MLME-START.request. If
>         the BSSType indicates an IBSS, the STA shall start an IBSS, a=
nd
>         the BSSID shall be an individual locally administered IEEE MA=
C
>         address as defined in 5.2 of IEEE Std 802-1990. The remaining=
 46
>         bits of that MAC address shall be a number selected in a mann=
er
>         that minimizes the probability of STAs generating the same
>         number, even when those STAs are subjected to the same initia=
l
>         conditions.
>=20
> Remember that BSSIDs, *not* SSIDs are used to identify BSSes uniquely=
=2E
>=20
> Of course you could argue that "merging" is simply tearing down the o=
wn
> and then joining the other IBSS.
>=20
> Comments on the code now.
>=20
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -80,6 +80,9 @@ static void ieee80211_rx_bss_put(struct net_devic=
e *dev,
> >                                  struct ieee80211_sta_bss *bss);
> >  static int ieee80211_sta_find_ibss(struct net_device *dev,
> >                                    struct ieee80211_if_sta *ifsta);
> > +static int ieee80211_sta_join_ibss(struct net_device *dev,
> > +                                  struct ieee80211_if_sta *ifsta,
> > +                                  struct ieee80211_sta_bss *bss);
>=20
> No way, order the code properly, this mess needs to be cleaned up not
> added to.
> =20
> > -	if (bss->probe_resp && beacon) {
> > +	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
> > +	    bss->probe_resp && beacon) {
> >  		/* Do not allow beacon to override data from Probe Response. */
>=20
> Ahem. Comment update required.
>=20
> > +	/* check if we need to merge IBSS */
>=20
> Could use a plural, but whatever.
>=20
> > +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && beacon &&
> > +	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
> > +	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> > +	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) =
=3D=3D 0) {
>=20
> I think that needs a check "&& ssid_len" or something. Someone's boun=
d
> to try making an IBSS with a hidden SSID and we really don't want tha=
t
> to work.
>=20
> > +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> > +		static unsigned long last_tsf_debug;
> > +#endif
>=20
> Let's just get rid of that, it's not usable with multiple devices.
>=20
> > +		if (rx_status->flag & RX_FLAG_TSFT)
> > +			mactime =3D rx_status->mactime;
> > +		else {
> > +			mactime =3D -1LLU;
> > +			printk(KERN_WARNING "%s: IBSS mode needs mactime for "
> > +				"beacons\n", dev->name);
>=20
> Very bad, you'll be flooded by this when others send beacons. Also, I
> doubt its truthfulness.
>=20
> > +			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
> > +				" -> IBSS merge with BSSID %s\n",
> > +				dev->name, print_mac(mac, mgmt->bssid));
>=20
> No way. At the very least you need to ratelimit this.
>=20
> johannes

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
