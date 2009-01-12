Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43728 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZALULe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:11:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43legacy: fix "=?utf-8?q?=E2=80=98up=5Fdev=E2=80=99_may_be_used?= uninitialized" warning
Date: Mon, 12 Jan 2009 21:11:25 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1231789741-13433-2-git-send-email-linville@tuxdriver.com> <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901122111.26012.mb@bu3sch.de> (sfid-20090112_211138_263893_A757812E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 January 2009 20:48:59 John W. Linville wrote:
> drivers/net/wireless/b43legacy/main.c: In function =E2=80=98b43legacy=
_op_dev_config=E2=80=99:
> drivers/net/wireless/b43legacy/main.c:2468: warning: =E2=80=98up_dev=E2=
=80=99 may be used uninitialized in this function
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

ACK

> ---
>  drivers/net/wireless/b43legacy/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wire=
less/b43legacy/main.c
> index c1324e3..fb996c2 100644
> --- a/drivers/net/wireless/b43legacy/main.c
> +++ b/drivers/net/wireless/b43legacy/main.c
> @@ -2465,7 +2465,7 @@ static void b43legacy_put_phy_into_reset(struct=
 b43legacy_wldev *dev)
>  static int b43legacy_switch_phymode(struct b43legacy_wl *wl,
>  				      unsigned int new_mode)
>  {
> -	struct b43legacy_wldev *up_dev;
> +	struct b43legacy_wldev *uninitialized_var(up_dev);
>  	struct b43legacy_wldev *down_dev;
>  	int err;
>  	bool gmode =3D 0;



--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
