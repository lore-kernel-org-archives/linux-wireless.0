Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXLWR2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 12:28:55 -0500
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712230815u158cd19fjc1ff58a7e2c83fbc@mail.gmail.com> (sfid-20071223_161528_053408_3DC1FC3D)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
	 <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com>
	 <1198154463.16241.46.camel@johannes.berg>
	 <c85cb4470712230815u158cd19fjc1ff58a7e2c83fbc@mail.gmail.com>
	 (sfid-20071223_161528_053408_3DC1FC3D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NCE/X9uDiQrGxoFqrGsN"
Date: Sun, 23 Dec 2007 18:28:40 +0100
Message-Id: <1198430920.4541.11.camel@johannes.berg> (sfid-20071223_172901_920891_E8BBB595)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NCE/X9uDiQrGxoFqrGsN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

> Johannes, i re-inspected the code to implement your solution, and it
> is not straight forward as you have seen it.

Ok.

> what we do now in __ieee80211_rx is:
> - invoke monitor
> - fill in txrx_data
> - invoke michael_mic_report (if needed)
> - call pre-handlers of QoS that change txrx_data as well.
> - call pre-handlers of statistics that change txrx_data
> - call reorder buffer prehandler
>     - saving sk_buff to reordering buffer.
>     - if we can, send sk_buffs back to __ieee80211_rx, that will
> properly fill txrx_data

Yeah, sounds like it. Some things like monitor may discard the frame.

> now, in order to proceed according to your implementation, as i do not
> call again  __ieee80211, and do not get the txrx_data restored,  i
> will either:
> 1 - have to fill in txrx_data inside reordering function, which will
> end in massive code duplication, and i don't like this solution
> 2 - keep the whole txrx_data and not only the sk_buff inside
> reordering buffer, which will end up in allocation of the txrx_data
> struct for every incoming frame, or in a big maximum possible size of
> 64 pre-allocated array of txrx_data per tid - this is either waste of
> cpu or memory

Hmm, good points. Didn't really think about it but yeah, txrx data is on
the stack there.

> so, what do you think about next solution:
>=20
> 1 - move the rxtx_data indifferent functionality out of __ieee80211_rx
> (monitor, load and reordering) to, lets say __ieee80211_rx_pre_handle.

Sounds fine.

> 2 - __ieee80211_rx_pre_handle will be called for each frame. either
> directly or through tasklet.

Hm, ok, we should keep __ieee80211_rx() as the entry point though so we
don't have to change drivers.

> 3 - in regular state, proceed to __ieee80211_rx immediately, in
> reorder state loop over __ieee80211_rx for each already ordered frame.

Ah ok.

> 4 - I thought to eliminate __ieee80211_invoke_rx_handlers(local,
> local->rx_pre_handlers), as QoS will be the only one to inhabit it
> now, so it may move to ieee80211_invoke_rx_handlers(local,
> local->rx_handlers)

I don't think it can move there because the rx handlers can potentially
be invoked multiple times. Will that work? In any case, I'm not against
totally dissolving the pre-handlers into function calls. Makes for
better code generation anyway since gcc will be able to optimise across
the functions when inlining them (since they'll all have only one user)

> sorry for the long mail, but i wanted to write my full opinion about this=
 issue.

Not at all, thanks for doing that.

I think we should probably keep __iee80211_rx() as the entry point for
the tasklet or the drivers.

So I'd see the flow as:

tasklet/driver
__ieee80211_rx()
	__rx_pre_monitor()
	__rx_pre_load()
	__rx_pre_qos()

	if (agg)
		__rx_handle_reorder()
	else
		__rx_handle_packet()

and __rx_handle_reorder() calls __rx_handle_packet() which does all the
rest, I guess.

Does that sound sane to you? You're in a better position to judge. I
think this is basically what you wanted, just keeping __ieee80211_rx()
as the main entry point.

Or maybe I'm totally off. Can you explain again what we need to do for
such a reordered frame?

johannes

--=-NCE/X9uDiQrGxoFqrGsN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR26ax6Vg1VMiehFYAQLLSQ/+L4chWj628hK7yKq2CZ0vL5f9DW9K1Kw6
RFeEWCDPgIEiZ3K+SGQMmsEOowUItp1xkJqqBNGvOaoTM0SEKRpaOzTXbr05Kh49
2n7Vto3wIodkoDW4l3UkPLm0YEXa4vMTPMQ2IeSWxb+ZdfcVZh63z7nJvuveQ/IW
1Kw+WY6nCVabPQHKBWwAIAOWpdiFvG02v1GUJZ7oN616G3J0VFOYH3fTwuFnE4H7
8jFLBBitTgPqp9RjfDe7jAO9cfajGXTj2cHYc8lt+MIMbmdTokEe2jPd02Q8Vaj1
XjxPQw2k2WK4W/Z6eNzAJcmgLPz7AMnhkTvU85RznjBV0CDo1+O8HPUU/3Z0owwh
xWn/Ngffq6ZgDBcGC0aoRKChloNFEOuSMNzSNl95bPDVG1BXsLpXmodJcMaPz5a/
LdMbOwlzQtVc2ksHYhYqG2QYPp8fE9hFF2FOR2cwpdc/17GAH+m9M3L6vrmGMvf8
J/yjzgNrV8jI875dfP0CerWB0FV/JMZTa9d8vofsMZxYDG4nwdsJiGkhqOCM+ae6
sCNMi/mbMXQLlBVvZ7y50A1q4aiK4aiEh/BGnOGsn8lS5OANGKEit6//ugztsyPa
VXPVUhG04vqZVntPUfSZFxvgAbsiOlZWdie3yCfshmXj25OYzunjCJQEimy29G/I
qAE7th6+fUk=
=nBBt
-----END PGP SIGNATURE-----

--=-NCE/X9uDiQrGxoFqrGsN--

