Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:41310 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753236Ab2LKQyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 11:54:24 -0500
Date: Tue, 11 Dec 2012 17:53:24 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 1/2] cfg80211: add the new IBSS_STA event
Message-ID: <20121211165324.GA14557@open-mesh.com> (sfid-20121211_175427_641104_0F07DD49)
References: <1355138182-11825-1-git-send-email-antonio@open-mesh.com>
 <50C76158.1010005@opentechinstitute.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <50C76158.1010005@opentechinstitute.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Tue, Dec 11, 2012 at 11:37:44AM -0500, Will Hawkins wrote:
> Will this give IBSS something equivalent to the 802.11s
> NL80211_CMD_NEW_PEER_CANDIDATE?
>=20

I'm not very familiar with the 802.11s code, but after having given a look,
they seem to be similar. The difference is that the IBSS_STA event is trigg=
ered
only after the new station has been AUTHENTICATED, while NNEW_PEER_CANDIDATE
seems to be triggered right after having "intercepted" a new peer.

So in IBSS, with this patchset, you will have these sequence:

0) detection of a new node
1) sta_info creation and NEW_STA is triggered (this event has not been remo=
ved)
2) sta gets authenticated
3) IBSS_STA triggered =3D> sta is ready to be handled by userspace (e.g. wp=
a_s)

> That's how I am reading it, but I just wanted to get some more context.
> If this is what you are adding, it's great! Just exactly what I need.

I hope the explanation above is enough, otherwise feel free to ask more :-)

>=20
> Thanks for your work Antonio.
>=20


np, thank Open-Mesh for having given me the chance to work on this ;)

Cheers,

> Will
>=20
> On 12/10/2012 06:16 AM, Antonio Quartulli wrote:
> > In IBSS mode it could be the case that a station being added
> > is not ready for starting higher level routines (e.g. key
> > exchange when IBSS/RSN is enabled). In particular, this can
> > happen when we are waiting for the AUTH response message.
> >=20
> > This IBSS_STA event is triggered after the NEW_STA one and
> > only when the upper layer is allowed to assume that the new
> > peer is ready
> >=20
> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> > ---
> >=20
> > 1/2 v2:
> >  * untouched
> > 2/2 v2:
> >  * if userspace registered for auth frames, the new station is immediat=
ely
> >    authenticated and the new IBSS_STA event is triggered.
> >=20
> >  include/net/cfg80211.h       |  8 ++++++++
> >  include/uapi/linux/nl80211.h |  2 ++
> >  net/wireless/mlme.c          |  9 +++++++++
> >  net/wireless/nl80211.c       | 33 +++++++++++++++++++++++++++++++++
> >  net/wireless/nl80211.h       |  3 +++
> >  5 files changed, 55 insertions(+)
> >=20
> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > index 8e6a6b7..3266c03 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -3497,6 +3497,14 @@ void cfg80211_new_sta(struct net_device *dev, co=
nst u8 *mac_addr,
> >  		      struct station_info *sinfo, gfp_t gfp);
> > =20
> >  /**
> > + * cfg80211_ibss_sta - notify userspace that the ibss station is ready
> > + * @dev: the netdev
> > + * @mac_addr: the station's address
> > + * @gfp: allocation flags
> > + */
> > +void cfg80211_ibss_sta(struct net_device *dev, const u8 *mac_addr, gfp=
_t gfp);
> > +
> > +/**
> >   * cfg80211_del_sta - notify userspace about deletion of a station
> >   *
> >   * @dev: the netdev
> > diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> > index e3e19f8..7e0911e 100644
> > --- a/include/uapi/linux/nl80211.h
> > +++ b/include/uapi/linux/nl80211.h
> > @@ -736,6 +736,8 @@ enum nl80211_commands {
> > =20
> >  	NL80211_CMD_SET_MCAST_RATE,
> > =20
> > +	NL80211_CMD_IBSS_STATION,
> > +
> >  	/* add new commands above here */
> > =20
> >  	/* used to define NL80211_CMD_MAX below */
> > diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> > index 5e8123e..f9493fc 100644
> > --- a/net/wireless/mlme.c
> > +++ b/net/wireless/mlme.c
> > @@ -612,6 +612,15 @@ void cfg80211_new_sta(struct net_device *dev, cons=
t u8 *mac_addr,
> >  }
> >  EXPORT_SYMBOL(cfg80211_new_sta);
> > =20
> > +void cfg80211_ibss_sta(struct net_device *dev, const u8 *mac_addr, gfp=
_t gfp)
> > +{
> > +	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> > +	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> > +
> > +	nl80211_send_ibss_sta_event(rdev, dev, mac_addr, gfp);
> > +}
> > +EXPORT_SYMBOL(cfg80211_ibss_sta);
> > +
> >  void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_=
t gfp)
> >  {
> >  	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index f45706a..2d27911 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -8564,6 +8564,39 @@ void nl80211_send_sta_event(struct cfg80211_regi=
stered_device *rdev,
> >  				nl80211_mlme_mcgrp.id, gfp);
> >  }
> > =20
> > +void nl80211_send_ibss_sta_event(struct cfg80211_registered_device *rd=
ev,
> > +				 struct net_device *dev, const u8 *mac_addr,
> > +				 gfp_t gfp)
> > +{
> > +	struct sk_buff *msg;
> > +	void *hdr;
> > +
> > +	msg =3D nlmsg_new(NLMSG_GOODSIZE, gfp);
> > +	if (!msg)
> > +		return;
> > +
> > +	hdr =3D nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_IBSS_STATION);
> > +	if (!hdr) {
> > +		nlmsg_free(msg);
> > +		return;
> > +	}
> > +
> > +	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
> > +	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
> > +		goto nla_put_failure;
> > +
> > +	genlmsg_end(msg, hdr);
> > +
> > +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> > +				nl80211_mlme_mcgrp.id, gfp);
> > +	return;
> > +
> > + nla_put_failure:
> > +	genlmsg_cancel(msg, hdr);
> > +	nlmsg_free(msg);
> > +}
> > +
> > +
> >  void nl80211_send_sta_del_event(struct cfg80211_registered_device *rde=
v,
> >  				struct net_device *dev, const u8 *mac_addr,
> >  				gfp_t gfp)
> > diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
> > index 2acba84..429f5d6 100644
> > --- a/net/wireless/nl80211.h
> > +++ b/net/wireless/nl80211.h
> > @@ -85,6 +85,9 @@ void nl80211_send_remain_on_channel_cancel(
> >  void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
> >  			    struct net_device *dev, const u8 *mac_addr,
> >  			    struct station_info *sinfo, gfp_t gfp);
> > +void nl80211_send_ibss_sta_event(struct cfg80211_registered_device *rd=
ev,
> > +				 struct net_device *dev, const u8 *mac_addr,
> > +				 gfp_t gfp);
> >  void nl80211_send_sta_del_event(struct cfg80211_registered_device *rde=
v,
> >  				struct net_device *dev, const u8 *mac_addr,
> >  				gfp_t gfp);
> >=20

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQx2UEAAoJEADl0hg6qKeOw1gQAKS2MU3OM44OC1yjDAMNYQAs
3aKQpwA+SdTCpQX9s8+JaPeM+MdOMZr1zhOhYz/f4mWUmUMmF4cHV3VmqFsbu3zn
KyU2j+P8wsYT/eJt/0xCcBq4G5KYuXwdxuQjgnHHKeJTEc/xSBpCOPVrRpORCarL
005xMJFq/Qx8FoMGdNvPZh4shB8/eCw3q2vMf5mXiV/4TOBxGNxY8r9RF1BXLMz7
/cfRPDRXHHU9agNZrSyDaUek2PD9LYYp9Gxlq/OSphRj0KPVOvFhx5Mj0gIl4k6L
mro2X5w5WzxyLJUCHY4BiidNObUBa/WjNWmgMvw6PSXf41O//eHwwNAujiTDysi2
mGpI8yt5Yo5ft+pYs+qfEXkYiUWvf3XVYjjtrlB5Mdvd66926OkR3Fg5ke24NWfE
RcSGPhqQeB5YuSpueNkJ7LAhHBysu7eD5XWn0YZiLpFexXK46gFz/fDiSAmX+tV0
teJV5xYyuIcIunUV6FmUfEc5V9ygFCKl+ZCNNCE/P4vQaxZEYdMuVyklmciApd8Z
d7NTMImT+ZyxvHNB2qtqj54MhoyIUDe85a58520sOaB6XGr1C+5t49LnIgVo9DBv
9Riyy0qnOqMlWF5SyYs1U4qHm5Qe8LS4jU6GsQg+bq3iOuoG/8NaWlHPNEEOqRPR
ThSH4z1YprJF7AScObjU
=8GOH
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
