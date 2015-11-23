Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35013 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbbKWAbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 19:31:42 -0500
Received: by igl9 with SMTP id 9so42192952igl.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 16:31:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448183242-3397-3-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com> <1448183242-3397-3-git-send-email-tvboxspy@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 23 Nov 2015 11:31:22 +1100
Message-ID: <CAGRGNgUpFTG6Gb3SGocZh8W8oE793q8tfLVUNppSt34XNCV_Tg@mail.gmail.com> (sfid-20151123_013215_895751_E6E0FC8C)
Subject: Re: [PATCH 3/8] staging: vt6655: set_channel replace bResult with ret
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Malcolm,

On Sun, Nov 22, 2015 at 8:07 PM, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> Removing camel case.
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6655/channel.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
> index d1c9116..9ac1ef9 100644
> --- a/drivers/staging/vt6655/channel.c
> +++ b/drivers/staging/vt6655/channel.c
> @@ -176,10 +176,10 @@ void vnt_init_bands(struct vnt_private *priv)
>   */
>  bool set_channel(struct vnt_private *priv, struct ieee80211_channel *ch)
>  {
> -       bool bResult = true;
> +       bool ret = true;
>
>         if (priv->byCurrentCh == ch->hw_value)
> -               return bResult;
> +               return ret;

ret is always true here, right?

>
>         /* Set VGA to max sensitivity */
>         if (priv->bUpdateBBVGA &&
> @@ -200,8 +200,8 @@ bool set_channel(struct vnt_private *priv, struct ieee80211_channel *ch)
>                                                   ch->hw_value);
>
>         priv->byCurrentCh = ch->hw_value;
> -       bResult &= RFbSelectChannel(priv, priv->byRFType,
> -                                   ch->hw_value);
> +       ret &= RFbSelectChannel(priv, priv->byRFType,
> +                               ch->hw_value);

Isn't a &= b equivalent to a = a & b which is inappropriate for
boolean variables?

Also, wouldn't ret be true here, so the & is unnecessary?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
