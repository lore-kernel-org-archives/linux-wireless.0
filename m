Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbZHDPxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:53:38 -0400
Subject: Re: [PATCH] libertas: Fix WEP association failure with open source
 wpa_supplicant 0.5.10
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Maithili Hinge <maithili@marvell.com>
In-Reply-To: <1249095739-7908-1-git-send-email-bzhao@marvell.com>
References: <1249095739-7908-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:54:11 -0400
Message-Id: <1249397651.21155.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 20:02 -0700, Bing Zhao wrote:
> From: Maithili Hinge <maithili@marvell.com>
> 
> From: Maithili Hinge <maithili@marvell.com>
> 
> Add code to handle IW_AUTH_PRIVACY_INVOKED and IW_AUTH_RX_UNENCRYPTED_EAPOL
> cases in lbs_set_auth() function in libertas code.
> 
> Signed-off-by: Maithili Hinge <maithili@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/wext.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index e96451c..be837a0 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1728,6 +1728,8 @@ static int lbs_set_auth(struct net_device *dev,
>  	}
>  
>  	switch (dwrq->flags & IW_AUTH_INDEX) {
> +	case IW_AUTH_PRIVACY_INVOKED:
> +	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
>  	case IW_AUTH_TKIP_COUNTERMEASURES:
>  	case IW_AUTH_CIPHER_PAIRWISE:
>  	case IW_AUTH_CIPHER_GROUP:

