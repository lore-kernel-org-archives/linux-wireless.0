Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:41651 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbZHNNA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 09:00:28 -0400
Received: by pzk34 with SMTP id 34so1035585pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 06:00:30 -0700 (PDT)
Message-ID: <4A855FEA.7030907@lwfinger.net>
Date: Fri, 14 Aug 2009 08:00:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Add LP-PHY firmware loading support
References: <4A854FDF.5020208@gmail.com>
In-Reply-To: <4A854FDF.5020208@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Add support for loading LP-PHY firmware to b43_try_request_fw.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> For anyone hoping that the channel switch patches will make their LP
> card work - this is also definitely required.
> 
> Mark, this doesn't fix your problem specifically, but it will be needed
> after your problem is fixed.
> 
> drivers/net/wireless/b43/main.c |   24 +++++++++++++++++++++++-
> 1 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index fbcbe4f..1e657fe 100644
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

As shown by http://bcm-v4.sipsolutions.net/802.11/Init/Firmware, one
should also have "ucode16".

>     else
>         goto err_no_ucode;
>     err = b43_do_request_fw(ctx, filename, &fw->ucode);
> @@ -2111,6 +2115,15 @@ static int b43_try_request_fw(struct
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

Same for lp0initvals16.

> +            goto err_no_initvals;
>     default:
>         goto err_no_initvals;
>     }
> @@ -2145,6 +2158,15 @@ static int b43_try_request_fw(struct
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

and lp0bsinitvals16.

> +        else
> +            goto err_no_initvals;
>     default:
>         goto err_no_initvals;
>     }

Larry
