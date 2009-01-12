Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34772 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZALUre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:47:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54: fix "=?utf-8?q?=E2=80=98ret=E2=80=99_may_be_used?= uninitialized" warning
Date: Mon, 12 Jan 2009 21:47:39 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1231789741-13433-4-git-send-email-linville@tuxdriver.com> <1231789741-13433-5-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1231789741-13433-5-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901122147.39055.chunkeey@web.de> (sfid-20090112_214745_209846_B541D918)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 January 2009 20:49:01 John W. Linville wrote:
> drivers/net/wireless/p54/p54common.c: In function =E2=80=98p54_config=
=E2=80=99:
> drivers/net/wireless/p54/p54common.c:1853: warning: =E2=80=98ret=E2=80=
=99 may be used uninitialized in this function
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
ACK

> ---
>  drivers/net/wireless/p54/p54common.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wirel=
ess/p54/p54common.c
> index cba89ed..c6a370f 100644
> --- a/drivers/net/wireless/p54/p54common.c
> +++ b/drivers/net/wireless/p54/p54common.c
> @@ -1850,7 +1850,7 @@ static void p54_remove_interface(struct ieee802=
11_hw *dev,
> =20
>  static int p54_config(struct ieee80211_hw *dev, u32 changed)
>  {
> -	int ret;
> +	int ret =3D 0;
>  	struct p54_common *priv =3D dev->priv;
>  	struct ieee80211_conf *conf =3D &dev->conf;
> =20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
