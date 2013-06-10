Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51941 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FJPL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 11:11:57 -0400
Date: Mon, 10 Jun 2013 17:11:54 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 0/5] add master channel switch announcement support
Message-ID: <20130610151154.GA1640@pandem0nium> (sfid-20130610_171201_077116_4005D542)
References: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <51B2195C.1010303@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
In-Reply-To: <51B2195C.1010303@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Felix,

On Fri, Jun 07, 2013 at 07:33:16PM +0200, Felix Fietkau wrote:
> On 2013-06-07 7:05 PM, Simon Wunderlich wrote:
> > This is the follow up from the RFC posted a month ago. This patchset ad=
ds generic
> > channel switch support for AP. This is required for DFS operation
> > (e.g. Wi-Fi Alliance requires this for 802.11h certification). This wil=
l also
> > be required for IBSS-DFS later.
> >=20
> > The rough design is:
> >  * userspace asks kernel to switch a channel using the new NL80211_CMD_=
CHANNEL_SWITCH
> >    command. It supplies IE information for the time while staying on th=
e old channel and
> >    announcing the switch, and IE information for after the switch to th=
e new channel.=20
> >  * IE information contains the beacon and optionally probe responses, w=
hich should
> >    include (E)CSA IEs for the CSA case. Furthermore an offset is provid=
ed (for beacon
> >    and probe response) to point to the counter field within the channel=
 switch IEs.
> >  * The driver gets the new beacons passed and must set them, and decrem=
ent the
> >    counter field. When it reaches 0, the channel is changed and userspa=
ce notified.
> >=20
> > Discussion points:
> >  * Assembling all these IE information is a little bit tedious but doab=
le (I've
> >    patched hostapd).
> >  * Other future users like IBSS/MESH will not get the beacon/probe resp=
onse IEs, as they
> >    generate these beacons themselves. Therefore they need the COUNT att=
ribute, which
> >    is kind of duplicate right now.
> >  * Userspace must generate/handle all IEs, which lifts the previous lim=
itations of
> >    the RFC (e.g. no change of band allowed, no operation mode change al=
lowed).
> >  * it currently works for me [TM] on my ath9k based machine
> I think this is a bit racy. Just because the driver gets a beacon from
> mac80211 doesn't mean that the beacon will be sent *immediately*. I'd
> recommend calling back from the driver into mac80211 on beacon tx
> completion. Also, it might make sense to skip CAB queue transmissions in
> this case.

mhm, you're right, changing channel might race with sending the beacon as i=
t's
set right now. I'd change it to:

 * update the counter within get_beacon() (as done now)
 * perform the channel switch after beacon transmission is completed (not s=
ure how to get this
   event practically yet ... :] )

What do you think?

This must probably handle stuck/lost beacons too - is there any completion =
function
called for stuck beacons?

Thanks,
	Simon

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlG17LoACgkQrzg/fFk7axZPUgCfRhL/OUKlrC1sbzc4VgOVddRx
5kEAnRMcgiqW2Axn/0/UNcvpsIPNYZ9H
=oO7Y
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
