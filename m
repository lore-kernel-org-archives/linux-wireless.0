Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35878 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbbKWAjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 19:39:51 -0500
Received: by igcph11 with SMTP id ph11so42198608igc.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 16:39:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448183242-3397-4-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com> <1448183242-3397-4-git-send-email-tvboxspy@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 23 Nov 2015 11:39:31 +1100
Message-ID: <CAGRGNgUvE0-7RnW-_+QWKky6cwyEEbY8UpYzqJpB0tKHqmsMjg@mail.gmail.com> (sfid-20151123_013955_089883_584295B4)
Subject: Re: [PATCH 4/8] staging: vt6655: rf.c rename bResult ret.
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Malcolm,

A couple of these comments apply to a few of the patches.

On Sun, Nov 22, 2015 at 8:07 PM, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> Removing camel case and reflecting return value.
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6655/rf.c | 138 ++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 69 deletions(-)
>
> diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
> index 4c22bb3..1c0691d 100644
> --- a/drivers/staging/vt6655/rf.c
> +++ b/drivers/staging/vt6655/rf.c
> @@ -420,9 +420,9 @@ static bool s_bAL7230Init(struct vnt_private *priv)
>  {
>         void __iomem *dwIoBase = priv->PortOffset;
>         int     ii;
> -       bool bResult;
> +       bool ret;
>
> -       bResult = true;
> +       ret = true;

These two lines could be combined into one.

>         /* 3-wire control for normal mode */
>         VNSvOutPortB(dwIoBase + MAC_REG_SOFTPWRCTL, 0);
> @@ -432,7 +432,7 @@ static bool s_bAL7230Init(struct vnt_private *priv)
>         BBvPowerSaveModeOFF(priv); /* RobertYu:20050106, have DC value for Calibration */
>
>         for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
> -               bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[ii]);
> +               ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[ii]);

Now that I understand why it's always ret &= ..., I'm truly horrified
by the error handling in this driver. =)

>         /* PLL On */
>         MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);

> @@ -616,26 +616,26 @@ bool RFbInit(
>         struct vnt_private *priv
>  )
>  {
> -       bool bResult = true;
> +       bool ret = true;
>
>         switch (priv->byRFType) {
>         case RF_AIROHA:
>         case RF_AL2230S:
>                 priv->byMaxPwrLevel = AL2230_PWR_IDX_LEN;
> -               bResult = RFbAL2230Init(priv);
> +               ret = RFbAL2230Init(priv);
>                 break;
>         case RF_AIROHA7230:
>                 priv->byMaxPwrLevel = AL7230_PWR_IDX_LEN;
> -               bResult = s_bAL7230Init(priv);
> +               ret = s_bAL7230Init(priv);
>                 break;
>         case RF_NOTHING:
> -               bResult = true;
> +               ret = true;
>                 break;
>         default:
> -               bResult = false;
> +               ret = false;
>                 break;
>         }
> -       return bResult;
> +       return ret;
>  }
>
>  /*
> @@ -654,26 +654,26 @@ bool RFbInit(
>  bool RFbSelectChannel(struct vnt_private *priv, unsigned char byRFType,
>                       u16 byChannel)
>  {
> -       bool bResult = true;
> +       bool ret = true;
>
>         switch (byRFType) {
>         case RF_AIROHA:
>         case RF_AL2230S:
> -               bResult = RFbAL2230SelectChannel(priv, byChannel);
> +               ret = RFbAL2230SelectChannel(priv, byChannel);
>                 break;
>                 /*{{ RobertYu: 20050104 */
>         case RF_AIROHA7230:
> -               bResult = s_bAL7230SelectChannel(priv, byChannel);
> +               ret = s_bAL7230SelectChannel(priv, byChannel);
>                 break;
>                 /*}} RobertYu */
>         case RF_NOTHING:
> -               bResult = true;
> +               ret = true;

Isn't this line unnecessary?

>                 break;
>         default:
> -               bResult = false;
> +               ret = false;
>                 break;
>         }
> -       return bResult;
> +       return ret;
>  }
>
>  /*

> @@ -879,13 +879,13 @@ bool RFbRawSetPower(
>                 dwMax7230Pwr = 0x080C0B00 | ((byPwr) << 12) |
>                         (BY_AL7230_REG_LEN << 3)  | IFREGCTL_REGW;
>
> -               bResult &= IFRFbWriteEmbedded(priv, dwMax7230Pwr);
> +               ret &= IFRFbWriteEmbedded(priv, dwMax7230Pwr);
>                 break;
>
>         default:
>                 break;

You could remove this default case in another round of cleanups.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
