Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZKBRfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 12:35:34 -0500
Subject: Re: [PATCH 08/15] iwlwifi: move iwl_[un]init_drv to iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1257182368.21134.13580.camel@rc-desk>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-9-git-send-email-reinette.chatre@intel.com>
	 <1256968603.3555.79.camel@johannes.local>
	 <1257182368.21134.13580.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yasrcVLwaSZiln47IwJ7"
Date: Mon, 02 Nov 2009 18:35:29 +0100
Message-ID: <1257183329.16174.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yasrcVLwaSZiln47IwJ7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> What happened in this patch is that I moved a function from iwlcore to
> iwlagn. This function, while in iwlcore, had access to all the symbols
> in iwlcore. Now that I moved the function to iwlagn I needed to make
> sure all symbols needed by it was available. This resulted in me
> exporting iwl_calib_free_results and iwl_init_scan_params since they are
> in iwlcore and are now called by this function in iwlagn.

Right ... but maybe iwl_uninit_drv and iwl_calib_free_results should
move to iwlagn as well? Maybe the entire iwl-calib.c file should be
linked to the iwlagn module? Anyway, I agree with moving code, but it
seems it could go further.

johannes

--=-yasrcVLwaSZiln47IwJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7xheAAoJEODzc/N7+QmaIk8QAK8Sw+jCiyD1Bm3j5e17W8nF
gXDEkrdk8WUkN7zzD4NAAS54+uwBSsG/aMqEHSiumdPdluDxooFbsPc/h474j6Dx
/hCVCa/ga5h+JK06w84CjNJkDaS7d7khxTT6gthK3ruuwKJk+UuWsg5Z6W0i1anH
jz943bDZ4NaQXFdH644rSPNN/BDn3DgFbcQtgKn/lXsWpC/0OoWMhBddNtWTqhjM
EXEsr78T7mPx8iDEt6xqge5OFWFzwQy+KBSCwOgeynTGyLg5fbKW7sx7cSg4YJQF
/HBX2+Einx7bSTAiNVBgb9fNyDiBwvkGVDc3RI086ZwIiAZIYa5wntSLkjJlGfNA
WpFi5NePc96DbT1y17F3OUVtOatGOU+PKyEgwDU3IKkFCujQ8rZlueEYz29PxtoS
a4sxmDtZk3sdh1Y6YJechXv9bieVYfKTMUFiH6Nqy2FlWfPGm0iZkU3lIhMhVDXB
on8XVJjuWd02V+y5JzzDlR87iZHGaaM7pvJ/bTaLHj8QlRtEyBrP6Z3rfUd2OgA+
0x+OvlXknhp75tZeSf//896g3LhZtV6c02LssKjWUOAYyLwA5z6Qa55VDxL5B21C
mL6dKPuz9BmZKGLvg68+yNbQeF26eON7JtajJStMLQtrrjaUBWPMR6VUdIQ5V7bn
taU/ydTVqU59F/g8X46O
=DjB+
-----END PGP SIGNATURE-----

--=-yasrcVLwaSZiln47IwJ7--

