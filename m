Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34222 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752880AbdK0TTs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 14:19:48 -0500
Received: by mail-lf0-f67.google.com with SMTP id i14so34093822lfc.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Nov 2017 11:19:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171126053818.GA6602@blackstone>
References: <20171126053818.GA6602@blackstone>
From: Steve deRosier <derosier@gmail.com>
Date: Mon, 27 Nov 2017 11:19:46 -0800
Message-ID: <CALupW3At1oZ0AeXkhZEvY1dCcXMzocsthRJwKQq16XBTatv6Gw@mail.gmail.com> (sfid-20171127_201951_845174_70F27D50)
Subject: Re: [PATCH] ath6kl: remove redundant variable ies_len
To: Kenneth Lu <kuohsianglu@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 25, 2017 at 9:38 PM, Kenneth Lu <kuohsianglu@gmail.com> wrote:
> To get rid of W=3D1 warning: variable =E2=80=98ies_len=E2=80=99 set but n=
ot used.
> Variable ies_len is being assigned but never read.
>
> Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wir=
eless/ath/ath6kl/cfg80211.c
> index b53eb2b..2ba8cf3 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -2766,7 +2766,6 @@ static int ath6kl_start_ap(struct wiphy *wiphy, str=
uct net_device *dev,
>         struct ieee80211_mgmt *mgmt;
>         bool hidden =3D false;
>         u8 *ies;
> -       int ies_len;
>         struct wmi_connect_cmd p;
>         int res;
>         int i, ret;
> @@ -2804,7 +2803,6 @@ static int ath6kl_start_ap(struct wiphy *wiphy, str=
uct net_device *dev,
>         ies =3D mgmt->u.beacon.variable;
>         if (ies > info->beacon.head + info->beacon.head_len)
>                 return -EINVAL;
> -       ies_len =3D info->beacon.head + info->beacon.head_len - ies;
>
>         if (info->ssid =3D=3D NULL)
>                 return -EINVAL;

Oddly, ies_len was never even used in the original patch that added
it. Probably used in some debugging code that was stripped before
submitting. Seems safe to kill it.

Reviewed-by: Steve deRosier <derosier@gmail.com>

- Steve
