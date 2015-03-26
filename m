Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbbCZPWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 11:22:18 -0400
Date: Thu, 26 Mar 2015 15:22:13 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: vnt_rf_setpower: fix missing rate
 RATE_12M
Message-ID: <20150326152213.GA4668@charon.olymp> (sfid-20150326_162222_758481_710A530C)
References: <1425746197-6614-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1425746197-6614-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Malcolm,

On Sat, Mar 07, 2015 at 04:36:37PM +0000, Malcolm Priestley wrote:
> When the driver sets this rate a power of zero value is set causing
> data flow stoppage until another rate is tried.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> Cc: <stable@vger.kernel.org> # v3.17+

Is there a reason for this patch being tagged for stable v3.17+ ?

I'm asking because there's a similar commit for vt6655 (40c8790bcb7a
"vt6655: RFbSetPower fix missing rate RATE_12M") which was tagged for
stable without the "v3.17+", and thus I assume applicable to other
trees as well (e.g. 3.16).

Cheers,
--
Luís

> ---
>  drivers/staging/vt6656/rf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
> index c42cde5..c4286cc 100644
> --- a/drivers/staging/vt6656/rf.c
> +++ b/drivers/staging/vt6656/rf.c
> @@ -640,6 +640,7 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
>  		break;
>  	case RATE_6M:
>  	case RATE_9M:
> +	case RATE_12M:
>  	case RATE_18M:
>  	case RATE_24M:
>  	case RATE_36M:
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
