Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZK3REf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:04:35 -0500
Subject: Re: [PATCH 2/2] mac80211: enable spatial multiplexing powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890911300854i69ddb18dxcd34d38f0d610004@mail.gmail.com>
References: <20091130153857.963079149@sipsolutions.net>
	 <20091130154300.647360542@sipsolutions.net>
	 <43e72e890911300854i69ddb18dxcd34d38f0d610004@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jKnbWUij6zn99G1P8JmN"
Date: Mon, 30 Nov 2009 18:04:37 +0100
Message-ID: <1259600677.32171.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jKnbWUij6zn99G1P8JmN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-30 at 08:54 -0800, Luis R. Rodriguez wrote:

> > +static int ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
> > +                                 enum nl80211_smps_mode smps_mode)
> > +{
> > +       const u8 *ap;
> > +       enum nl80211_smps_mode old_req;
> > +       int err =3D 0;
> > +
> > +       mutex_lock(&sdata->u.mgd.mtx);
> > +
> > +       old_req =3D sdata->u.mgd.req_smps;
> > +       sdata->u.mgd.req_smps =3D smps_mode;
>=20
> sdata->u.mgd.mtx seems protected by sdata->u.mgd.mtx.

You mean req_smps, I gather.

> > +
> > +       if (old_req =3D=3D smps_mode &&
> > +           smps_mode !=3D NL80211_SMPS_AUTOMATIC)
> > +               goto out;
> > +
> > +       /*
> > +        * If not associated, or current sasociation is not an HT
> > +        * association, there's no need to send an action frame.
> > +        */
> > +       if (!sdata->u.mgd.associated ||
> > +           sdata->local->oper_channel_type =3D=3D NL80211_CHAN_NO_HT) =
{
> > +               mutex_lock(&sdata->local->iflist_mtx);
> > +               ieee80211_recalc_smps(sdata->local, sdata);
> > +               mutex_unlock(&sdata->local->iflist_mtx);
> > +               goto out;
> > +       }
> > +
> > +       ap =3D sdata->u.mgd.associated->cbss.bssid;
> > +
> > +       if (smps_mode =3D=3D NL80211_SMPS_AUTOMATIC) {
> > +               if (sdata->u.mgd.powersave)
> > +                       smps_mode =3D NL80211_SMPS_DYNAMIC;
> > +               else
> > +                       smps_mode =3D NL80211_SMPS_OFF;
> > +       }
> > +
> > +       /* send SM PS frame to AP */
> > +       err =3D ieee80211_send_smps_action(sdata, smps_mode,
> > +                                        ap, ap);
> > +       if (err)
> > +               sdata->u.mgd.req_smps =3D old_req;
> > + out:
> > +       mutex_unlock(&sdata->u.mgd.mtx);
> > +
> > +       return err;
> > +}
> >  static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_de=
vice *dev,
> >                                    bool enabled, int timeout)
> >  {
> > @@ -1333,6 +1381,9 @@ static int ieee80211_set_power_mgmt(stru
> >        sdata->u.mgd.powersave =3D enabled;
> >        conf->dynamic_ps_timeout =3D timeout;
> >
> > +       /* no change, but if automatic follow powersave */
> > +       ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
>=20
> But yet the caller uses it without any locking. Seems racy between
> here and the respective mutex_lock().

Hmm, good catch. Although I think it doesn't matter since this is the
only code path that touches it apart from set_smps, and they both occur
under rtnl.

> >        mutex_init(&ifmgd->mtx);
> > +
> > +       if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS=
)
> > +               ifmgd->req_smps =3D NL80211_SMPS_AUTOMATIC;
> > +       else
> > +               ifmgd->req_smps =3D NL80211_SMPS_OFF;
>=20
> How about just checking the HT cap as well and if no HT cap has been
> set warn as it would indicate a driver bug actually.

You mean if it sets dynps w/o HT cap? We /could/ do that, but I don't
really see a reason for it. We'd find out soon enough by a non-HT driver
supporting SMPS etc.

> > +               ieee80211_queue_work(&local->hw, &local->recalc_smps);
>=20
> OK from what I gather so far we just queue work if we received an ACK
> from the action frame we sent. Since we tell the device to
> ieee80211_stop_device() the device should have stopped RX'ing and that
> *should* mean preventing processing future tx status reports. We'll
> find out if that assumption is wrong.

It's not about receiving -- only about transmitting. But yeah, we'll
find out. I have a patch pending that'll flush queues etc., that would
make it completely impossible if implemented by the driver, but I don't
think we need to worry about it.

> > @@ -209,6 +243,10 @@ void ieee80211_tx_status(struct ieee8021
> >                rate_control_tx_status(local, sband, sta, skb);
> >                if (ieee80211_vif_is_mesh(&sta->sdata->vif))
> >                        ieee80211s_update_metric(local, sta, skb);
> > +
> > +               if (!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
> > +                   (info->flags & IEEE80211_TX_STAT_ACK))
> > +                       ieee80211_frame_acked(sta, skb);
> >        }
> >
> >        rcu_read_unlock();
>=20
> Nice, should the nullfunc ack check be handled here as well?

Well, it could, in theory. But I've now imposed a requirement that SMPS
capable devices also implement status notifications properly, which may
or may not be possible for all frames. In fact, we may need to change
this in the future but for now I prefer this requirement -- but for HT
only.

> > +       if (!conf_is_ht(&local->hw.conf)) {
> > +               /*
> > +                * mac80211.h documents that this is only valid
> > +                * when the channel is set to an HT type, and
> > +                * that otherwise STATIC is used.
> > +                */
> > +               local->hw.conf.smps_mode =3D NL80211_SMPS_STATIC;
>=20
> Why wouldn't this just be SMPS_OFF ?

Well, it doesn't matter either way. However, it was easier this way for
iwlwifi because ultimately we want to turn off all but one chain if
non-HT and/or static SMPS. So at least there it made sense to use STATIC
here to avoid the extra check. But other drivers may or may not want to
ignore it completely in the HT case. I've documented that it sets it to
STATIC when a non-HT association is used just for more use. It could be
anything really, or even an invalid value. Also remember that SMPS_OFF
means all chains turned on.

> > --- wireless-testing.orig/net/mac80211/util.c   2009-11-29 11:33:00.000=
000000 +0100
> > +++ wireless-testing/net/mac80211/util.c        2009-11-29 11:35:06.000=
000000 +0100
> > @@ -1170,3 +1170,77 @@ int ieee80211_reconfig(struct ieee80211_
> >        return 0;
> >  }
> >
> > +static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
> > +                         enum nl80211_smps_mode *smps_mode)
> > +{
> > +       if (ifmgd->associated) {
> > +               *smps_mode =3D ifmgd->ap_smps;
> > +
> > +               if (smps_mode =3D=3D NL80211_SMPS_AUTOMATIC) {
>=20
> This should be *smps_mode.

Indeed, good catch, thanks!

johannes

--=-jKnbWUij6zn99G1P8JmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLE/shAAoJEODzc/N7+Qmae3sQAJcNHXFhvHz9m1fUnbZGByh1
Ltv7wWZl94jeYbbqu8GyVkqNfd3MNsYbN7XUrKZbNqnQzrxjW5sDAz2ZXm6TaRcM
cenpGLA7uSOrzZCIVuN5WZRXy20CoAA1j+S+7devrD4LUzVG9Un0ZFa1GJtUF24W
7pS6sWYiA1YWJ/8r9q99VSSUkj5H3DrR1xa/dwOrDV/zbLf/xI1QGRIIFAy8HqAn
0Sts66iDADnoNSWTIeWVF9/bzfFA9jShSpo9FikwABZLPIsBrlLPsuxinhR1VpPr
4eBdkdJ7kTbMtMVWKu91zReMf+wtxeiXc7A0QgkBxck/qcNkTHSmaePC4BnbBgTb
UOBjPSiTG+mcWlGJUIkagbfrnMfypH/ElcLYr1iWC2Q6wQR6lWvZAUthADYh6Ema
PtaEfIkxOqCap8x5mUKOH1A1k8+38VtfVmV2lAMzkzjNONG1rjEOwja+Tv0FdleU
ipQLlcN4KChLX+xCBLOTMjIYypkVlzyr0vAoR+glrO66zCrc2qqGnh+T0NDLi7Zu
yG//lMBm8LKTv5SbUupznx2gTGimDgqNGszzJJoXx7THAsvP19AWen8cO7i7CGUj
WK7lc7XnP5KU3x/r36IagjlcCqMQ1i0FJvPFSlalfWmHUpOCq8hw3Ccn3J0Xo8JU
iDpKxaxcRCM41ecRUf2H
=gRlV
-----END PGP SIGNATURE-----

--=-jKnbWUij6zn99G1P8JmN--

