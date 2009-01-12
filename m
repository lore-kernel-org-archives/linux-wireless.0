Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43287 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZALUJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:09:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: fix "=?utf-8?q?=E2=80=98gmode=E2=80=99_may_be_used?= uninitialized" warning
Date: Mon, 12 Jan 2009 21:09:29 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1231789741-13433-1-git-send-email-linville@tuxdriver.com> <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901122109.30246.mb@bu3sch.de> (sfid-20090112_210943_405590_F6056EBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 January 2009 20:48:58 John W. Linville wrote:
> drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_config=E2=
=80=99:
> drivers/net/wireless/b43/main.c:3264: warning: =E2=80=98gmode=E2=80=99=
 may be used uninitialized

Stupid gcc :P

> Signed-off-by: John W. Linville <linville@tuxdriver.com>

ACK

> ---
>  drivers/net/wireless/b43/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b=
43/main.c
> index 7b31a32..c788bad 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -3261,7 +3261,7 @@ static int b43_switch_band(struct b43_wl *wl, s=
truct ieee80211_channel *chan)
>  	struct b43_wldev *down_dev;
>  	struct b43_wldev *d;
>  	int err;
> -	bool gmode;
> +	bool uninitialized_var(gmode);
>  	int prev_status;
> =20
>  	/* Find a device and PHY which supports the band. */



--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
