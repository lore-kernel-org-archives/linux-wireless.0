Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33391 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752027Ab3BPI2i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 03:28:38 -0500
Message-ID: <1361003317.3444.4.camel@joe-AO722> (sfid-20130216_092844_356468_08673947)
Subject: Re: [PATCH 1/2] mwifiex: coding style cleanup in bss parameter
 update
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Sat, 16 Feb 2013 00:28:37 -0800
In-Reply-To: <1360993470-4828-2-git-send-email-bzhao@marvell.com>
References: <1360993470-4828-1-git-send-email-bzhao@marvell.com>
	 <1360993470-4828-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 21:44 -0800, Bing Zhao wrote:
> From: Yogesh Ashok Powar <yogeshp@marvell.com>
> They all can make one line.
[]
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
[]
> @@ -1485,20 +1485,15 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
>  	priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
>  	priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
>  	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
> -	priv->curr_bss_params.bss_descriptor.ht_cap_offset =
> -		0;
> +	priv->curr_bss_params.bss_descriptor.ht_cap_offset = 0;

Another way to do this to reduce the visual noise it to
create a temporary
	struct mwifiex_bssdescriptor *t = &priv->curr_bss_params.bss_descriptor;
and use
	s/priv->curr_bss_params.bss_descriptor./t->/


