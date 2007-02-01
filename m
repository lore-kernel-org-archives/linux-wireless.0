Return-path: <wireless-bounces@tuxdriver.com>
Received: from sipsolutions.net (Debian-exim@crystal.sipsolutions.net
	[195.210.38.204])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l11Dka3J013973
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Thu, 1 Feb 2007 08:47:05 -0500
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <200701302146.05289.flamingice@sourmilk.net>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131013840.GB28076@tuxdriver.com>
	<200701302146.05289.flamingice@sourmilk.net>
Date: Thu, 01 Feb 2007 11:18:12 +0100
Message-Id: <1170325092.2236.17.camel@johannes.berg>
Mime-Version: 1.0
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1517826874=="
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com


--===============1517826874==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-/g9qHFqag9EiZjLfhLFA"


--=-/g9qHFqag9EiZjLfhLFA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-01-30 at 21:46 -0500, Michael Wu wrote:

> I think drivers that currently support frame injection do it by allowing =
TX on=20
> a monitor interface w/ AVS or radiotap header. I would rather have this t=
han=20
> requiring the use of NL80211 to inject frames since userspace won't have =
to=20
> do as much to continue supporting frame injection. It also makes more sen=
se=20
> to me. Status notification can be done by a 802.11 ACK frame. Radiotap mi=
ght=20
> need to be extended to support toggling the ACK frame reporting for TX an=
d=20
> whatever else userspace wants to set.

I disagree. Generic netlink is trivially extensible while radiotap
isn't, and I really don't want a radiotap parser in the kernel.
Secondly, a lot of notification items will only be given via netlink
anyway, like failed decryption or whatever, and we don't want to keep
all this in fake management frames.

> > +	/* configuration sent from kernel */
> > +	NL80211_CMD_NEW_CONFIG,
> > +
> Why NEW?

I think Thomas suggested the scheme GET/SET/NEW but I don't really care.

> [snip]
> > +	/* currently set roaming BSSID */
> > +	NL80211_CMD_FIXED_BSSID,
> > +
> Wasn't immediately obvious to me that this is from GET_FIXED_BSSID.

should get a NEW prefix as well then? :)

> > +	/* get current association information, if not associated then
> > +	 * the BSSID attribute is not present in response */
> > +	NL80211_CMD_GET_ASSOCIATION,
> > +
> > +	/* association notification and response to GET_BSSID */
> > +	NL80211_CMD_ASSOCIATION_CHANGED,
> > +
> I don't see a GET_BSSID. Did you mean GET_ASSOCIATION?

Yeah, I suppose I do.

> [snip]
> > +	/* attributes used for configuration */
> > +	/* network ID (pre 802.11 HW) */
> > +	NL80211_ATTR_NETWORK_ID,
> > +
> We really want to support (and port) pre 802.11 drivers?

Not really sure. Do we? This is probably the only thing required for
that... We can leave it out and if someone wants to port them later add
it in.

> [snip]
> > +	/* SSID of ESS to associate to */
> BSS?

Well, I think that comes down to what happens if we don't set a BSSID
but do set an SSID and then tell it to associate. In that case, it
should chose a BSS from the ESS with that SSID.

> > + * @list_interfaces: for each interfaces belonging to the wiphy identi=
fied
> > + *		     by the priv pointer, call the one() function with the
> > + *		     given data and the ifindex. This callback is required.
> > + *
> Do we really have to have this?

We can only not have this if we mandate that all add/remove interface
operations go through cfg80211. I was afraid that wouldn't be too
popular. If we do mandate that then we can keep the list in cfg80211
instead of having to query the driver/stack.
However, d80211 at least will need access to the list. So then we have
to add API for that. And all the legacy non-d80211 drivers (except for
ipw2200) will ever only return a single interface so it's trivial to
implement there. Hence, I stuck with this. I'm open for changes, of
course.

If I now misunderstood the question... Yes, we do need to know the list
of devices associated to a certain wiphy, if only to be able to have
userspace print it out :)

johannes

--=-/g9qHFqag9EiZjLfhLFA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFwb5k/ETPhpq3jKURAoKFAJ9uxohSnyQaQyZhTKlRm3L4iw+53wCffxus
gqxcjFaPiIEQO82ODmEvENI=
=W0Jq
-----END PGP SIGNATURE-----

--=-/g9qHFqag9EiZjLfhLFA--


--===============1517826874==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1517826874==--
