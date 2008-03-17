Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699AbYCQUFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 16:05:45 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com> (sfid-20080317_193958_082685_4299559A)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com>
	 <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com>
	 (sfid-20080317_193958_082685_4299559A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JBu6FXExDy/jKnSDU6Qe"
Date: Mon, 17 Mar 2008 21:04:15 +0100
Message-Id: <1205784255.16475.33.camel@johannes.berg> (sfid-20080317_201023_075471_6DA28F00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JBu6FXExDy/jKnSDU6Qe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >
> >  > BSS defines security setting which  defined by key management for
> >  > pairwise and group key + cipher method for both .
> >  > You can run multiple SSIDs over single single BSSID. This is done
> >  > using VLANs
> >
> >  Actually, we don't support that in mac80211.
> Last time I worked on AP project it worked. It was older mac hopefully
> it's not totally broken
>=20
>  And the way I understand
> >  VLANs they are simply done by negotiating different group keys with
> >  different groups of stations each forming a VLAN.
>=20
> We are saying the same. That's okay.

Well, you were suggesting the use of multiple SSIDs, which we don't
support, we only support VLANs within a BSS/single SSID. Not that I've
been able to test it, hostapd needs radius stuff set up for VLANs...

> >  > So you can maintain multiple security settings in for one
> >  > AP.  However this is not possible when using static WEP since the ke=
y
> >  > is global and the key is not attached to any address.
> >  >
> >  > There are more details into it I'm sorry if I'm not 100 clear here.
> >  > The bottom line is that you don't need more 4 WEP keys both in AP an=
d
> >  > station mod. Same you need to maintain only one pairwise key for
> >  > station both in AP and STA mode. In AP mode you need to maintain als=
o
> >  > one group key for each station because of the case of multiple SSIDs=
.
> >
> >  Except the group keys don't really matter for an AP since they're TX
> >  only, which is why we add them with a zeroed MAC address and can only
> >  select them for TX
> .
> Zero address again :)
>=20
> >
> >
> >  > Nop. Still you  can have <WEP, WEP>  for <pairwise,group key> valid
> >  > setting - This is not static key. The two keys may differ. Under you=
r
> >  > assumption the group key will override pairwise key
> >
> >  Hm, ok. So I suppose the only way to determine "static" right now woul=
d
> >  be to check that no pairwise keys are configured at all.
>=20
> I'm not sure if I follow here but I think the simples way to determine
> if static key is set is to set static_key flag to 1. I don't see any
> reason this can be directly detected from the configuration.

Right. I was just saying that the way it currently is I think you could
detect it that way. b43 simply assumes WEP keys are always 'static'
which seems to mostly work well in practice.

I suppose then set_key needs a new argument key_type:

enum ieee80211_key_type {
	KEY_TYPE_PAIRWISE,
	KEY_TYPE_GROUP,
	KEY_TYPE_TXONLY,	/* group key in an AP */
	KEY_TYPE_STATIC,
}

where the MAC address pointer would only be non-NULL when the key type
is PAIRWISE, and STATIC can only be used for WEP keys.

johannes

--=-JBu6FXExDy/jKnSDU6Qe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR97OvqVg1VMiehFYAQL8fw//Sj2aKnFTJcoDPoiuvyRWFdZkbjnIsed2
/3dGQD//ezuM/x7XePQ+LYt9W8HnfY7aKFWDPrlNjluMTL9qZpGz03aLCAbGOKJL
ZlKmkW29C8nJqUvrF3HzpwU8KMPUQTs1cQxixANC8gSCNMVAKgJrUoAasWjQuH9H
p/z8z91dTkrfgHFPujBXfSlLjg+VUEZo++YevxjdEu4n1NGRUA4VUsBTVEddQ3iN
CThNdOtoZ+xn/VAtPs/mM7LJF9MTWys9YCUpB42KcwjY0tzI5yyE11+U7rQ2t7pB
+ZZhOpTD6MpWGmysPlZ7TNR9Tgn9KOVG4sXAUTQWl5z7+2WkLIGad84vl7UIWpLM
pvQ5+bCij7OJrhxAbIq3bQYqu7lWYsWGtmHlrv1KAmvbScl/a6rmVZRozixUODXG
5srDAqMdcPcXEQLBUFlIGkeu5OHiJuv3ulo+YJ0elqLWDdPtNZgZWGOEWPl0eCyY
Ppw3bd3/NN1Wj85rPKYOHtEunk80TM6m9RxG6H5Fh0sxcrbTt0JQO08zmM2st1Hx
ejvk0tGCM8fUwGa4nr71Ge8JT14YKyOUqQeiwBf2afCz0B21aOQj/k0SbyRCpmKY
j+Vyqe6wOvdcZ23s+WmCI0D4ITVEXwMJ+ij6S+cMbFhZO0ogWdAb6MpDSz5tbDmp
oXQ4ajgEtjI=
=khTQ
-----END PGP SIGNATURE-----

--=-JBu6FXExDy/jKnSDU6Qe--

