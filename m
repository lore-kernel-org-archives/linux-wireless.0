Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:52711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZBTT7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:59:54 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2072019fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 11:59:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235109874-3966-2-git-send-email-lrodriguez@atheros.com>
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
	 <1235109874-3966-2-git-send-email-lrodriguez@atheros.com>
Date: Fri, 20 Feb 2009 20:59:52 +0100
Message-ID: <69e28c910902201159y1ba18657qdb1517892e6fe352@mail.gmail.com> (sfid-20090220_205959_217896_A239F8CC)
Subject: Re: [PATCH 1/5] cfg80211: enable active-scan / beaconing on Ch 1-11
	for world regdom
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, kalle.valo@nokia.com, kyle@mcmartin.ca,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 7:04 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This enables active scan and beaconing on Channels 1 through 11
> on the static world regulatory domain.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> =A0net/wireless/reg.c | =A0 =A05 ++---
> =A01 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 605299f..8f64575 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -76,9 +76,8 @@ static const struct ieee80211_regdomain world_regdo=
m =3D {
> =A0 =A0 =A0 =A0.n_reg_rules =3D 1,
> =A0 =A0 =A0 =A0.alpha2 =3D =A0"00",
> =A0 =A0 =A0 =A0.reg_rules =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_RULE(2412-10, 2462+10, 40, 6, 20,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NL80211_RRF_PASSIVE_SCA=
N |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NL80211_RRF_NO_IBSS),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* IEEE 802.11b/g, channels 1..11 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_RULE(2412-10, 2462+10, 40, 6, 20, 0=
),
> =A0 =A0 =A0 =A0}
> =A0};
>
> --
> 1.6.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Are you sure there is no area of the world where the allowed range is
stricter than b/g 1-11?
Otherwise I am inclined to NACK this.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
