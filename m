Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:37472 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755753AbXEQBwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 21:52:50 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Date: Wed, 16 May 2007 21:51:28 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <464B7B7C.5080800@linux.intel.com>
In-Reply-To: <464B7B7C.5080800@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15521323.nB5FAGnesC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705162151.32910.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart15521323.nB5FAGnesC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 16 May 2007 17:45, James Ketrenos wrote:
> This patch adds the iwlwifi project directory and sources needed to
> build the mac80211 based wireless drivers for the Intel PRO/Wireless
> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
>
Looks much better than when I last checked. A few comments:

=2D The enter/leave stuff should be removed.
=2D Many of the in_interrupt() checks are unnecessary. Jiri recently docume=
nted=20
which callbacks need to be atomic - the ones that don't need to be atomic=20
definitely won't be called in an interrupt.
=2D Get rid of the stub functions for callbacks, like set_multicast_list an=
d=20
reset. mac80211 checks if those callbacks are defined before calling them.
=2D CONFIG_IWLWIFI_QOS doesn't appear to be defined.
=2D Read and set the MAC address before calling ieee80211_register_hw.
=2D flush_scheduled_work in d_stop can lead to deadlocks since RTNL is held=
=2E It=20
looks like everything is running on a dedicated workqueue so that doesn't=20
really even do anything. priv->workqueue should be flushed instead if neede=
d.
=2D mac80211 (very recently) sets up a workqueue for the driver to use so y=
ou=20
don't need to create your own anymore.
=2D param_auto_create looks very suspicious. mac80211 already creates an ad=
hoc=20
station if it can't join one.. what's this for?
=2D The suspend and resume callback setting in struct pci_driver iwl_driver=
=20
needs to be put on two lines.
=2D Why are probe requests being dropped in adhoc mode? (assuming hardware=
=20
handles it.. but the message output for that doesn't sound like it)
=2D The bitwise ORs shouldn't be getting a line to itself in iwl3945_rx_ini=
t and=20
iwl3945_tx_reset.
=2D Mixed case variable name in iwl_hw_txq_ctx_stop: queueId.
=2D CONFIG_IWLWIFI_MONITOR and CONFIG_IEEE80211_RADIOTAP doesn't look right=
=2E=20
=2D RX_FLAG_RADIOTAP should be set in the ieee80211_rx_status flag when a=20
radiotap header is added to a frame. (otherwise, mac80211 will add its own=
=20
radiotap header)
=2D If you don't want to add a radiotap header all the time, you should che=
ck=20
the IEEE80211_CONF_RADIOTAP flag to see if a radiotap header is desired by=
=20
the stack. (not whether or not we're configured as IEEE80211_IF_TYPE_MNTR)
=2D Splitting rx_start->phy_flags over two lines in iwl4965_rx_reply_rx doe=
sn't=20
look good.
=2D The IEEE80211_FTYPE_MGMT case in the switch statement inside=20
iwl4965_rx_reply_rx doesn't need that extra set of braces. Also, the &&=20
and || don't need their own lines.
=2D param_channel looks suspicious too.
=2D ieee80211chan2mhz is provided by ieee80211_radiotap.h.

Haven't seen anything severe enough to be a blocker for wireless-dev, howev=
er.

=2DMichael Wu

--nextPart15521323.nB5FAGnesC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGS7UkT3Oqt9AH4aERAtflAJ94IbYwPsvTe7Ec80pPAx3S+Kyn9wCgxUwj
nKbt5L7cTD3HGXZl6iq+tiw=
=phR6
-----END PGP SIGNATURE-----

--nextPart15521323.nB5FAGnesC--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
