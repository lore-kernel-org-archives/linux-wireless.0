Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXJ2QIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:08:45 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <20071028184959.GN4936@jm.kir.nu>
References: <1193148453.8648.20.camel@localhost.localdomain>
	 <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>
	 <1193320140.5542.11.camel@localhost.localdomain>
	 <1193320661.14136.10.camel@johannes.berg>
	 <1193548708.7779.10.camel@localhost.localdomain>
	 <1193567294.3966.6.camel@johannes.berg> <20071028173610.GM4936@jm.kir.nu>
	 <1193594085.5197.20.camel@johannes.berg>  <20071028184959.GN4936@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7/SPIQdXmNv63Xpsh/6X"
Date: Mon, 29 Oct 2007 15:42:11 +0100
Message-Id: <1193668931.5197.65.camel@johannes.berg> (sfid-20071029_160847_460752_B9FB9E97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7/SPIQdXmNv63Xpsh/6X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jouni,

Thanks for the detailed explanations. Mind if I wrap these up in some
comments and post a patch to add them to header file?

> The only documentation for these that I'm aware of is linux/wireless.h.
> The original code was not doing this right either (it was implemented
> before WE-18, if I remember correctly). The odd part is that I'm sure
> this used to work long time ago..

Whether it ever worked 'correctly' I cannot tell you. All I know it
behaves this way currently.

> IW_AUTH_* values were designed to provide mechanism for notifying the
> driver on number of parameters related to authentication (and
> association, in practice).=20

Right.

> WPA_VERSION, CIPHER_PAIRWISE, CIPHER_GROUP,
> KEY_MGMT, 80211_AUTH_ALG, WPA_ENABLED, PRIVACY_INVOKED are parameters
> describing the enabled security configuration for associations. Number
> of these parameters are bitfields and can include multiple enabled modes
> (e.g., both TKIP and CCMP could be allowed as the group cipher). I would
> assume most of these parameters be obvious from the field and bitfield
> value names.

Yeah, the actual values I have no problem with; I was rather unclear on
the semantics of some of the parameters. The one thing I don't like
about the API is that we have to accept all of these silently. Why is
that required?

> PRIVACY_INVOKED is describing whether any sort of encryption is to be
> used (boolean). If mixed-cell mode (for which there does not seem to be
> configuration options in WE) is enabled, any privacy flag combination is
> allowed. If mixed-cell is disabled, the PRIVACY_INVOKED has to match
> with the Privacy flag advertized in the Beacon/ProbeRsp frames.

Should we add a mixed-mode flag to wext? I realise that I've been the
biggest proponent of not posting any further changes for wext but as it
turns out the nl80211 interface for this hasn't progressed any further,
nobody else is helping out and this seems to be something we definitely
need right now. On the other hand, iwconfig(1) cannot set the auth
parameters at all, as far as I can tell.

In essence, however, you're saying that we should ignore
IW_AUTH_KEY_MGMT in favour of IW_AUTH_PRIVACY_INVOKED; I'll post a
patch.

> TKIP_COUNTERMEASURES is used to notify the driver of a two Michael MIC
> failures within 60 seconds to trigger TKIP countermeasures (i.e.,
> disable all TKIP encryption/decryption and prevent new associations that
> would use TKIP). For client mode, it is also possible that this is
> implemented in the driver, so some drivers do not need this. Anyway, for
> AP mode, the notification is needed since the driver would not get
> notifications of MIC errors detected at clients (which are reported to
> the AP in EAPOL-Key frames).

It doesn't seem like mac80211 would care about this at all since hostapd
handles all these things.

> DROP_UNENCRYPTED is a flag for configuring whether any unencrypted
> non-EAPOL data frames are allowed through. There is a MIB variable for
> this for WEP, but this is of limited use nowadays. I would expect all
> WPA configuration to prevent unencrypted data frames (apart from initial
> EAPOL frames) anyway.

We still haven't quite decided what to do with EAPOL frames though.
Should this influence the mac80211 variable sdata->drop_unencrypted? It
is also set by the in-kernel IBSS code though so that's a bit confusing.
It seems that currently drop_unencrypted defaults to off?!

> RX_UNENCRYPTED_EAPOL is used to configure whether unencrypted EAPOL
> frames are to be received when pairwise keys are set. This is needed for
> IEEE 802.1X (i.e., non-WPA) which never encrypted EAPOL frames. With
> WPA, EAPOL frames are encrypted when pairwise keys are set and as such,
> unencrypted EAPOL frames should be dropped after the pairwise keys are
> configured.

Can you explain how this differs from PRISM2_PARAM_IEEE_802_1X?

> ROAMING_CONTROL can be used to enable/disable roaming decision in the
> driver/firmware. The original need for this came from the Prism2
> firmware design that has a configuration option for indicating which
> component is responsible for roaming (selecting a new BSS if the current
> one is likely to end up getting out of range).

Why would this be necessary? Or rephrasing, why does it matter (to
userspace) whether the driver or the firmware is doing roaming?

Thanks,
johannes

--=-7/SPIQdXmNv63Xpsh/6X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyXxQqVg1VMiehFYAQKXsBAAgZ6x5RcCsN8acDKblhg+ZybZV/vPLoag
DMPKYQKTipMpK41/EgzXob1mERFSt2qAQa0PEXpPKnd9WFRK1eeO85miKzVcy8r9
3UN2XWPSIicaj01/TqzobKP7LRUIyx7ptoteucRNgbqs1mBg924YJPDHGSBDobh2
v4UzqAJqu8wGCFY2cAN/QXNTKxrT3Pblan7H2s/jAqgS3Zozqwog/6bplOk0/AV4
sm/zOS04sJtEZTP6aoiEzBh6eIzpDl4UiaGsqRAEspgMjMEab4zOdmDdN2lHOcTQ
hv13cgH41uuS0lxkEjV6SIca6PYA6VdBzd0o3T7+RvZUqnpWo5GHFaCbV43jL8EW
9das/3jMIrJZcYnwtVCGZSvmqJ+eeawod19h2vt5kRXDCDpsQeqhyaxNKjsOHWb0
uuynvzR+HTsP6U5m+3t/hPDLYj7KtBSgDXXIpk7T8WW4GVf23SOtRf837bUGh6pY
YnIErhvOeVenZGgcxgmrWbbVsuGFjNwKbATL/PjCoGiAUJs8cxKr+cqsYp/fqgTv
YblFvPQGqykToCUzWbbKhsAMWnIuf9/wzxKe3u/6if6Nbcp2qyiGAX483isdoCTw
60htPoeVktioKZttf9FDZ1QO3OW3VZVg7Va36D9/NcH3SvU4xUsoKkDsuvZjJ9Qf
figo95Hc3fw=
=J3GK
-----END PGP SIGNATURE-----

--=-7/SPIQdXmNv63Xpsh/6X--

