Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23655 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbXFVFHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 01:07:06 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [WIP] mac80211: kill mgmt interface
Date: Thu, 21 Jun 2007 22:05:12 -0700
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1182418939.10821.8.camel@johannes.berg> <20070621133556.GJ5361@jm.kir.nu>
In-Reply-To: <20070621133556.GJ5361@jm.kir.nu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2515396.sW31APrrCi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706212205.16642.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2515396.sW31APrrCi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 21 June 2007 06:35, Jouni Malinen wrote:
> On Thu, Jun 21, 2007 at 11:42:19AM +0200, Johannes Berg wrote:
> > This patch kills the management interface type now that we can
> > see transmitted frames on monitor interfaces.
>
> Has someone tested that this works with programs that use the management
> interface (mainly, hostapd and wpa_supplicant)? Is all the needed
> functionality available with the alternative solution?
>
The management interface shouldn't be killed until hostap and wpa_supplican=
t=20
can work with monitor interfaces.

> > I renamed the req_tx_status to reliable_tx_mntr and the flag
> > constant as well since that's what they now mean. It is always
> > set for injected frames so that hostapd can rely on seeing the
> > frames it sent.
>
> I'm not sure I follow this explanation fully.. How would hostapd learn
> whether the destination address acknowledged a unicast frame?
>
It's the same as the management interface - hostap receives the same frame =
it=20
sent, with a header that says whether or not it was ACKed.

> > The biggest problem, however, and I'm not sure how to solve it, is
> > that hostapd will see either encrypted or unencrypted frames on the
> > monitor interface depending on whether hardware encryption is used
> > or not. However, hostapd really needs to see eapol frames to do
> > whatever it needs to with them. Right now, I don't really have an
> > idea except maybe to send these packets to hostapd via nl80211,
> > or to introduce some sort of "decrypted soft monitor" iface.
>
> If I've understood correctly (please correct me, if not), this patch is
> proposing to remove an interface that works currently and leave the
> stack in state that does not work. I can only strongly recommend this
> patch not to be applied at this point. It is not a good direction to
> start removing working code before there is a good alternative available
> and that alternative has actually been tested to provide the needed
> functionality.
>
Agreed. However, it is marked WIP and has spawned some good discussion. :)

> I don't really see need for getting rid of the management interface, but
> if there is consensus on doing that, we would need to have another way
> of being able to receive and transmit management frames and data frames
> from/to user space in a way that provides at least following
> functionality:
> - transmit management frames at high priority
Should be fine to hardcode this for now since the current mgmt interface=20
doesn't allow control over this.

> - control whether transmitted frames will be encrypted or not
IEEE80211_RADIOTAP_F_WEP should be appropriate, I think. (despite its somew=
hat=20
misleading name)

> - get callback to report TX status for unicast frames (whether the
>   receiver sent control::ack for the frame)
This is provided by [PATCH] mac80211: show transmitted frames on monitor=20
interfaces.

> - receive management frames
Well, it's a monitor interface, so it's more of a challenge to receive just=
=20
the desired frames. Hopefully packet filter works well enough for this..

> - receive data frames EAPOL/etc. ethertypes in decrypted form
We should be able to receive this on the other interface which is handling =
all=20
the data frames, right?

> - delivery of notifications to user space for Michael MIC errors and
>   other similar events
nl80211 should be appropriate for this. nl80211 is probably the biggest=20
blocker before removing the mgmt interface completely.. everything else is=
=20
*almost* there.

=2DMichael Wu

--nextPart2515396.sW31APrrCi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGe1iMT3Oqt9AH4aERAm/LAKDJNGjVfMtcSKj0iYddNUuf9wQuiQCfeyCw
kNceVbxX8P3Q6Rgy+MbZp94=
=Cfy2
-----END PGP SIGNATURE-----

--nextPart2515396.sW31APrrCi--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
