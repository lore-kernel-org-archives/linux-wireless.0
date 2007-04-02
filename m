Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672AbXDBSjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 14:39:04 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: mabbas <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4611F47F.2060809@linux.intel.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <4611F47F.2060809@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2igsy9B9zjXRqf99E574"
Date: Mon, 02 Apr 2007 20:38:23 +0200
Message-Id: <1175539103.16379.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2igsy9B9zjXRqf99E574
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-02 at 23:30 -0700, mabbas wrote:

> I am calling ieee80211_rx_h_data_agg after ieee80211_rx_h_remove_qos_cont=
rol which
> clears all QoS data which include QOS_CONTROL_A_MSDU_PRESENT bit. We can =
solve this by
> adding new field is_frame_agg to ieee80211_txrx_data.u.rx.is_frame_agg wh=
ich will be set in
> ieee80211_rx_h_parse_qos or we can add new function to ieee80211_rx_pre_h=
andlers just to do that. the other=20
> option is to shuffle calling sequence here if that possible to call ieee8=
0211_rx_h_data_agg
> before ieee80211_rx_h_remove_qos_control. any opinion?

Since it's part of the QoS stuff that .11n adds I think we should stick
it into the qos parser.

johannes

--=-2igsy9B9zjXRqf99E574
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGEU2f/ETPhpq3jKURAi0nAKClMHIdZP2ViDHY9W2YzULUZjNEggCgiYPT
AeElc5DXULHRCSWG4IQSlLc=
=vGhZ
-----END PGP SIGNATURE-----

--=-2igsy9B9zjXRqf99E574--

