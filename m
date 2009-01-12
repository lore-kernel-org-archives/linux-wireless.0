Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34668 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbZALUMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:12:05 -0500
Message-ID: <496BA408.1080005@lwfinger.net> (sfid-20090112_211209_765605_D132404D)
Date: Mon, 12 Jan 2009 14:11:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: fix =?UTF-8?B?IuKAmHVwX2RlduKAmSBtYXkgYmUg?=
 =?UTF-8?B?dXNlZCB1bmluaXRpYWxpemVkIiB3YXJuaW5n?=
References: <> <1231789741-13433-1-git-send-email-linville@tuxdriver.com> <1231789741-13433-2-git-send-email-linville@tuxdriver.com> <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> drivers/net/wireless/b43legacy/main.c: In function =E2=80=98b43legacy=
_op_dev_config=E2=80=99:
> drivers/net/wireless/b43legacy/main.c:2468: warning: =E2=80=98up_dev=E2=
=80=99 may be used uninitialized in this function
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
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

It seems that some versions of gcc don't do the flow analysis
correctly, so

ACK

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
