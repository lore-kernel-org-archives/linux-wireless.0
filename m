Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXI3M1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 08:27:18 -0400
Subject: Re: [PATCH 1/1 V2] mac80211: add sta_notify callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1191153157853-git-send-email-tomas.winkler@intel.com>
References: <1191153157853-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y9wvUGuyiL3QCLkn1OZh"
Date: Sun, 30 Sep 2007 14:28:40 +0200
Message-Id: <1191155320.22960.155.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y9wvUGuyiL3QCLkn1OZh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-30 at 13:52 +0200, Tomas Winkler wrote:
> This patch adds sta_notify callback and removes sta_table_notification
> which was not used by any driver.
> sta_notify() is essential for drivers that keeps notion of station
> internally and need to be notified about removal or addition of a station
> to the (I)BSS or assocation to an AP.

Looks good to me.

> This version adds interface id to the parameter list
> as suggested by Johannes Berg

I think I created a problem with this, see below.

> +       if (local->ops->sta_notify)
> +               local->ops->sta_notify(local_to_hw(local), sta->dev->ifin=
dex,
> +                                       STA_NOTIFY_REMOVE, sta->addr);

Never thought about this before, but "dev" could be a VLAN at this point
so the if index will be useless.

However, since we don't have per-IF stations right now this patch is
fine with me, I'll just have to remember to fix this call when I add
per-IF stations and drivers might start to care.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-y9wvUGuyiL3QCLkn1OZh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv+Wd6Vg1VMiehFYAQIPsA//STkQ0xxe8Qtbb4huNmI2LyqQ7qH8/cvk
sjPm5hCwbq5xvS3+Zu4nEK/sX03J2QcZzmjILiGkV861pDnHT6dgZchX+9dFeGTf
SoqF1RuAvsOkUKRG+vILjL/P29rroT1QVaGiqO8pqt/k7h6PyX1i1+udu1GtlftE
Hc1NZmKH/Jw+Xv5G7qer+4HhD/fwBksHUIvfEBBMRaCDOsUiRtpepMl3SLYYHANf
Yuyw6Gw5zYWBmcNeszroxoZkViz+11f/5gElu7CrujjFs1e4ODOxX4InKVzyqLF2
qdc+3Cn6AhNPPe6fvXmuJlutTbEDP6hEdKUAFO0yoggZ1GYL76GgIG/j27kjSX+j
B4igdaKAdU9s5ha4rOGrS2SANgeh3X3u1jORkbVW0l+SFEgtKMrbMrUmVg5V+dxh
4PQUF1AoFsywBGsNThrHW4DQBKdTTjgGfESnuuJasi4E09iPUfVX9KFCcaEz/6OL
BONVIcIjyohSoCHtV/WF2M0LEKQAbr79UEotu7ELJYSMOeZPgfQMNPBW+9fYOlIT
28fpPAmffu2C2ytI0jWbZ8pQVtoIic14ZLdmo3bz6tKxxHf6/ei+IDd0r/d2LJz6
DVP9Uia5uLQy3lwbTVTbKjnpVCFW7AuNRM3OY5fmHmZBmAdxbrDxHH3xZAK4xXGC
qybkSOd1wcM=
=Ab64
-----END PGP SIGNATURE-----

--=-y9wvUGuyiL3QCLkn1OZh--

