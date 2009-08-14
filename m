Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coruscant.huijgen.tk ([84.245.31.19]:28336 "EHLO
	coruscant.huijgen.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbZHNMUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:20:45 -0400
Message-ID: <4A855670.1090902@huijgen.tk>
Date: Fri, 14 Aug 2009 14:20:00 +0200
From: Mark Huijgen <mark.sf.net@huijgen.tk>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] b43: Add LP-PHY firmware loading support
References: <4A8555F5.5090603@gmail.com>
In-Reply-To: <4A8555F5.5090603@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still missing a break in the bandswitch initvals.

Mark

Gábor Stefanik wrote:
> Add support for loading LP-PHY firmware to b43_try_request_fw.
>
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> drivers/net/wireless/b43/main.c |   25 ++++++++++++++++++++++++-
> 1 files changed, 24 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index fbcbe4f..51767fa 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -2062,8 +2062,12 @@ static int b43_try_request_fw(struct
> b43_request_fw_context *ctx)
>         filename = "ucode5";
>     else if ((rev >= 11) && (rev <= 12))
>         filename = "ucode11";
> -    else if (rev >= 13)
> +    else if (rev == 13)
>         filename = "ucode13";
> +    else if (rev == 14)
> +        filename = "ucode14";
> +    else if (rev >= 15)
> +        filename = "ucode15";
>     else
>         goto err_no_ucode;
>     err = b43_do_request_fw(ctx, filename, &fw->ucode);
> @@ -2111,6 +2115,16 @@ static int b43_try_request_fw(struct
> b43_request_fw_context *ctx)
>         else
>             goto err_no_initvals;
>         break;
> +    case B43_PHYTYPE_LP:
> +        if (rev == 13)
> +            filename = "lp0initvals13";
> +        else if (rev == 14)
> +            filename = "lp0initvals14";
> +        else if (rev >= 15)
> +            filename = "lp0initvals15";
> +        else
> +            goto err_no_initvals;
> +        break;
>     default:
>         goto err_no_initvals;
>     }
> @@ -2145,6 +2159,15 @@ static int b43_try_request_fw(struct
> b43_request_fw_context *ctx)
>         else
>             goto err_no_initvals;
>         break;
> +    case B43_PHYTYPE_LP:
> +        if (rev == 13)
> +            filename = "lp0bsinitvals13";
> +        else if (rev == 14)
> +            filename = "lp0bsinitvals14";
> +        else if (rev >= 15)
> +            filename = "lp0bsinitvals15";
> +        else
> +            goto err_no_initvals;
>     default:
>         goto err_no_initvals;
>     }

