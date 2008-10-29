Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYJ2KTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 06:19:05 -0400
Subject: Re: [PATCH] libertas: remove two libertas sparse warning
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200810291035.02763.hs4233@mail.mn-solutions.de>
References: <200810291035.02763.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 06:17:33 -0400
Message-Id: <1225275453.28968.15.camel@localhost.localdomain> (sfid-20081029_111911_561576_8BC02DB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 10:35 +0100, Holger Schurig wrote:
> Johannes Berg detected this two sparse warnings:
> 
> drivers/net/wireless/libertas/cmd.c:609:16: warning: cast to restricted __le16
> drivers/net/wireless/libertas/cmd.c:611:16: warning: cast to restricted __le16
> 
> ... but cmd.minlevel is "s8", so we can access it directly and hope
> for the sign-extension-code in the compiler to convert that to the
> "s16" type.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> ---
> Sent this to Linville, johill and Dan, but forgot the mailing list ;-/
> 
> Index: linux-wl/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.c	2008-10-29 08:22:28.000000000 +0100
> +++ linux-wl/drivers/net/wireless/libertas/cmd.c	2008-10-29 08:22:36.000000000 +0100
> @@ -606,9 +606,9 @@ int lbs_get_tx_power(struct lbs_private 
>  	if (ret == 0) {
>  		*curlevel = le16_to_cpu(cmd.curlevel);
>  		if (minlevel)
> -			*minlevel = le16_to_cpu(cmd.minlevel);
> +			*minlevel = cmd.minlevel;
>  		if (maxlevel)
> -			*maxlevel = le16_to_cpu(cmd.maxlevel);
> +			*maxlevel = cmd.maxlevel;
>  	}
>  
>  	lbs_deb_leave(LBS_DEB_CMD);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

