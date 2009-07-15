Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbZGOQM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:12:29 -0400
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Ranson <ranson@analager.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1247673740.17896.1983.camel@rc-desk>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
	 <1247673740.17896.1983.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MCgxAfcbMQogEheOqAhi"
Date: Wed, 15 Jul 2009 18:11:50 +0200
Message-Id: <1247674310.10754.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MCgxAfcbMQogEheOqAhi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> On Tue, 2009-07-14 at 21:25 -0700, John Ranson wrote:
> > [    4.252445] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13
> > 802.11a channels
> > [    4.252556] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
> > [    4.252945] iwlagn 0000:03:00.0: Failed to register hw (error -17)
> > [    4.253255] iwlagn 0000:03:00.0: PCI INT A disabled
> > [    4.253263] iwlagn: probe of 0000:03:00.0 failed with error -17
>=20
> This is ieee80211_register_hw() returning error 17 (EEXIST). One spot I
> saw where this can happen is if you are trying to register with the same
> name (wlanX) already used by another netdevice. Does this sound possible
> in your setup?
>=20
> Johannes - do you perhaps have an idea when this can happen?

This is strange -- I've had one report of this with 3945 which went away
and seemed to have been a compat only issue, I suspect this is also just
a compat-wireless issue, but I have no idea.

-EEXIST should only happen if something has already claimed something in
sysfs, but not with netdevs (i.e. wlan0 would just be renamed to wlan1)
and phy0 is numbered all the time so that can't be it either. I don't
know.

John, can you poke around in sysfs, /sys/class/ieee80211/ and see if
there's anything there when loading fails?

johannes

--=-MCgxAfcbMQogEheOqAhi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXf/DAAoJEODzc/N7+Qmarg0QAMaTy172CcLFK7KLhWBkq0kp
dD+iJzYLFpXn7MADUNJZWgXBldfjEaNzPQN0bH8ZB75p1wa7IH+qulc7O+Gy25IE
aLsmzH8oH7RFHdHUBNA7mp1dFDg/unEy7iSDbTWPQ+j9mh1H+9n4IaeK5jj6COux
hJiJOI/fCKP48hhg4H3oe6h33603XkrsLOxFxpd7Es6UlRdfee8YNifO8AIO4zQ3
ax6AhjJFo+MBhenhi2sa9um4jznaxvt2A+pUBa3hvTW1J6UIFqwaAg7Np58tUc0X
47juI2f+c/KpCeX11Bt0seI7W9Vlk6k/zhDp6yjIZqBmKMKVf14pW1C5iAcJUKzO
/QWs63LdvB4MsWi7G3ja4FfSQGVHQOLgLBXQLK3BT+q0g3fMl200wSw5P8oVM7f4
zZGiX59mnG4xbziQPU2glWbyKV7pdL69MTLpwACqekudxSAO8jthCJOMmzBlvYgO
dOvxcBiQGpEkaxXzSzDTc6Rlt3S92sQFk01OVHz8D722KrQQIblcBsetoz+PrzKO
edjmc+p/i2aowH3d+X5+png1szxr6xeWpvQUXlw/7jQcDO4K+UjNG6aRM7cA9ytW
lVcskjr/g2CGb/niilUuRE4Ayr7gPVk8wm1NgDIH16148QTxM9aXzVJAVTSLLYAJ
QmOKHP8IXr7ASOFgNt7c
=cxWH
-----END PGP SIGNATURE-----

--=-MCgxAfcbMQogEheOqAhi--

