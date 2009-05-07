Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZEGLfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 07:35:08 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1241677107.2918.4.camel@localhost.localdomain>
References: <1241677107.2918.4.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RAPKfBW0KFGe4oNFMbUi"
Date: Thu, 07 May 2009 13:35:03 +0200
Message-Id: <1241696104.27208.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RAPKfBW0KFGe4oNFMbUi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Copying Wey-Yi, but I think she's aware of this? It's definitely a
driver issue. I _suspect_, but am not sure, that the driver kills the
aggregation session when we disassoc or something and we only tell it
about the STA removal after that, when it already killed the STA. Thus
it would be a consequence of iwlwifi not implementing a proper
sta_notify() callback.

johannes

On Wed, 2009-05-06 at 23:18 -0700, Marcel Holtmann wrote:
> Hi guys,
>=20
> so I am running the wireless-testing.git tree from today and when
> terminating wpa_supplicant (wext driver), I get this warning in my
> kernel logs:
>=20
> ------------[ cut here ]------------
> WARNING: at net/mac80211/agg-tx.c:142 ___ieee80211_stop_tx_ba_session+0x6=
b/0x7e [mac80211]()
> Hardware name: 7454CTO
> Modules linked in: tun fuse sco bluetooth binfmt_misc uinput iwlagn snd_h=
da_codec_conexant snd_hda_intel iwlcore snd_hda_codec i2400m_usb mbm cdc_et=
her i2400m usbnet uvcvideo snd_pcm mii mac80211 cdc_acm cdc_wdm snd_timer s=
nd cfg80211 wimax soundcore snd_page_alloc uhci_hcd ehci_hcd [last unloaded=
: microcode]
> Pid: 2741, comm: wpa_supplicant Not tainted 2.6.30-rc4-wl #17
> Call Trace:
>  [<ffffffff80234b58>] warn_slowpath+0xb1/0xe5
>  [<ffffffffa014bda4>] ? iwl_tx_agg_stop+0x297/0x2bd [iwlcore]
>  [<ffffffffa018612c>] ? iwl_mac_ampdu_action+0x2ab/0x332 [iwlagn]
>  [<ffffffffa0088b02>] ___ieee80211_stop_tx_ba_session+0x6b/0x7e [mac80211=
]
>  [<ffffffffa0088c80>] __ieee80211_stop_tx_ba_session+0x63/0x7b [mac80211]
>  [<ffffffffa008890c>] ieee80211_sta_tear_down_BA_sessions+0x1b/0x3b [mac8=
0211]
>  [<ffffffffa008f105>] ieee80211_stop+0x9f/0x561 [mac80211]
>  [<ffffffff80548124>] ? _spin_unlock_bh+0x1e/0x20
>  [<ffffffff804b4583>] ? dev_deactivate+0x156/0x186
>  [<ffffffff804a72f3>] dev_close+0x74/0x96
>  [<ffffffff804a6f93>] dev_change_flags+0xba/0x180
>  [<ffffffff804e3008>] devinet_ioctl+0x278/0x604
>  [<ffffffff804e423e>] inet_ioctl+0x92/0xaa
>  [<ffffffff80497b8e>] sock_ioctl+0x1f1/0x21b
>  [<ffffffff802a5970>] vfs_ioctl+0x2a/0x78
>  [<ffffffff802a5dfa>] do_vfs_ioctl+0x43c/0x478
>  [<ffffffff802a5e8b>] sys_ioctl+0x55/0x77
>  [<ffffffff8020af6b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8a26567db4679b5c ]---
>=20
> The hardware is an Intel 5350 card if that actually matters.
>=20
> Regards
>=20
> Marcel
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-RAPKfBW0KFGe4oNFMbUi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKAsdeAAoJEODzc/N7+QmaVhwQAKhirQfX57XUyIIDdIDP4MFW
0thypQyk+hq4KNi2AGDuqSdaVB17m3/T8if9Vz/p1IqvN9ov65XDHvg3eG6paQ8r
7Vk5r/ZVeT7pEm4mPXxI7j1yuTlpwEUCt9L2eAEPAjfL6ZJcpk3RamfyPGRWwVzg
SpBzlWB//7vRy42T9TBsNG3Lry9shOyiKXO70vy8ZgdQWCf0851N2iPAFxQB3It4
7A10l4idsP5WsUMs/wdUFkYybYmeGbWtN2jg1dvEdzpw2VqbbAPf6jxlWtIIwe1p
2wPS+XJJDkLNHwcjd2QIH1Feij+x8O8HkNyj6YSSEJuXGKwZ14ec1PzSuSRV/LGe
h8adDg7UYyYd5XoJJefcPl/SEYQJ1njJSyFbrzBaoPL8wYOTXgRPkZzk7Nug5uLZ
hCwPL6SS683D1sysJ6pta9kORJ9WYKsLyzD+aCgAgEc1I3X0kltc5cE7fhRl9h9P
95FzKQ5MHowivsNXiUNOqgtu0BndjdAUwX8UHcC6XqmdOioS9O/JBBUqMLIJKyhl
vMb1hgUYVoO2V2feiOCXNg+m5OHyvnrdkUzKTH0Iy3cx6z77bw3VjuIG44VQ76sD
tEtLN4x4/eM54b33SkpJBUbGbAy1Q4SYlY95jTwyNnLwfj4XEnY2Dn74Pjg1m5f5
hnRONzOjALQnxgYnNTGp
=HqA+
-----END PGP SIGNATURE-----

--=-RAPKfBW0KFGe4oNFMbUi--

