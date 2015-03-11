Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:43069 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751585AbbCKUTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 16:19:47 -0400
Message-ID: <1426105182.32696.57.camel@perches.com> (sfid-20150311_211954_737201_775468C8)
Subject: Re: [PATCH 1/6] rtlwifi: Use common rtl_query_rxpwrpercentage
 function
From: Joe Perches <joe@perches.com>
To: Priit Laes <plaes@plaes.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Date: Wed, 11 Mar 2015 13:19:42 -0700
In-Reply-To: <1426104209-6913-2-git-send-email-plaes@plaes.org>
References: <1426104209-6913-1-git-send-email-plaes@plaes.org>
	 <1426104209-6913-2-git-send-email-plaes@plaes.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 22:03 +0200, Priit Laes wrote:
> diff --git a/drivers/net/wireless/rtlwifi/stats.c b/drivers/net/wireless/rtlwifi/stats.c
[]
> @@ -26,14 +26,14 @@
>  #include "stats.h"
>  #include <linux/export.h>
>  
> +/* TODO: Figure out a better name */
>  u8 rtl_query_rxpwrpercentage(char antpower)
>  {
>  	if ((antpower <= -100) || (antpower >= 20))
>  		return 0;
>  	else if (antpower >= 0)
>  		return 100;
> -	else
> -		return 100 + antpower;
> +	return 100 + antpower;
> }

This is a superfluous change.

If it was changed because checkpatch emitted a warning,
there's a newer version of checkpatch that doesn't emit
a warning for this line.

If any change was to be made, I suggest reordering so
that the return values are written low to high like:

u8 rtl_query_rxpwrpercentage(char antpower)
{
	if ((antpower <= -100) || (antpower >= 20))
		return 0;
	else if (antpower < 0)
		return antpower + 100;
	else
		return 100;
}


