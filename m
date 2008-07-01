Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYGAIwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 04:52:55 -0400
Subject: Re: [PATCH 1/2] mac80211: add bar capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240807010130t7641ec90o2ce95ec985b63125@mail.gmail.com> (sfid-20080701_103038_885558_0FB0EC9F)
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
	 <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
	 <1214899385.7763.9.camel@johannes.berg>
	 <1ba2fa240807010130t7641ec90o2ce95ec985b63125@mail.gmail.com>
	 (sfid-20080701_103038_885558_0FB0EC9F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wlBGHAFRK8AB/GvqlPzq"
Date: Tue, 01 Jul 2008 10:52:12 +0200
Message-Id: <1214902332.7763.17.camel@johannes.berg> (sfid-20080701_105305_210936_1EB1F3E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wlBGHAFRK8AB/GvqlPzq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> + * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
> >> + *   so consider using block ack request (BAR).
> >
> > This flag I don't understand. When does the driver set this? And what
> > does mac80211 do to "consider", it seems to always just try to set up a
> > block-ack session.
>=20
> This is required during BA session. BAR solicited Block ACK for the SN
> and on specified in BAR. Driver will send it if it doesn't hear BACK.
> Iwlwifi uses this BAR just says to the recipient that we were not able
> to transmit the frame and we won't retransmit. This immediately shifts
> recipient reordering buffer not waiting for high SN numbers of the
> next traffic otherwise there will be visible deep in the throughput as
> packets are not released to upper layer till all are received.

Hm, ok, I don't think I understand the subtleties of the protocol. So
when you have a BA session you have to send a BAR if you can't transmit
a frame for some reason? When would that happen?

> >> +     bar_control |=3D (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
> >
> > ??
> >
> >> +     bar_control |=3D (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
> >> +     bar_control |=3D (u16)(tid << 12);
> >> +     bar->control =3D cpu_to_le16(bar_control);
> >> +     bar->start_seq_num =3D cpu_to_le16(ssn);
> >> +
> >> +     /* must be sent through voice AC */
> >> +     skb->priority =3D 3;
> >
> > Does that actually work? The current wme.c code will still call
> > classify_1d() and that will use the IP TOS unless you set the priority
> > to 256..263.
>=20
> Good point. Have to look at this again we might missed this point when
> moving this out from the driver to the mac8011.
> Not sure this is classified at all as this is a control frame.

Oh, hmm, yeah those work differently, non-data frames aren't classified
at all and always go out on AC_VO regardless of what you set there so
you can just remove that.

johannes

--=-wlBGHAFRK8AB/GvqlPzq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIafA4AAoJEKVg1VMiehFYFvoQAMUVkT+WfBmppU7JDyZe4TzA
8NIwhbnVVHGAqgvLcewpTybErfzDDvpYifJ1cJDUtFQl3mYm6+T6GzNI0IXGn9ne
TM6xOhuLvITcKjoqtEoraBs/E1SP2v61ZJyQo2IT2/elX/jo6TsfeL8WRoYZt0w/
oTT+nGfwxt2uRQ3hW4LtbXWfsCskRrpqCz3tHpyn+CgtNrPQO668iLS/uTuYEK59
aChxtxxpywQUwIRCFveYbS8zu0jSZu2eytXQb75lj8XmaNgLMlzCDRK5kYdNFFFO
ug9hxHlEXYDQIT6lyQAM7PgmKDGggvrn4EKG+kCpWOYlLTksWj1REKiozeYtLglS
zDmdcmc5ppfb93SdDiAVRI8Hv18noX1PeLzvk/Tv2dc/bx5rpx4L5iOODILlwx1o
FxUpfGbyB2bjExVz1sn/o9OT185qZg2vd1yIu7wsaBgzqi626qkVcI2fOeWo3JgJ
fa2CVh+DT6jCkEaJNqqNl8SMJe1R7mB+EwhgVDRnEn10aHmbJvlqMABEYFgmIfVU
jWga0gcZJaq6W23KGRF9fr+hzRwoWs1Pjp2hD9BSk7+I3fhhg31yzcdDDPxGagDx
9XAYq4i0XVtygcQ2eHCe88TM78eH3D4UZ82OPE1LWHVR7UGAvEsmdZGrAebj87Zg
XhAsvXXstQ/S1Nrkzcaq
=Fdda
-----END PGP SIGNATURE-----

--=-wlBGHAFRK8AB/GvqlPzq--

