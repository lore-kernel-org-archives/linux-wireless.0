Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZKIDdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 22:33:32 -0500
Subject: Re: [PATCH 47/75] ipw2100: declare MODULE_FIRMWARE
From: Zhu Yi <yi.zhu@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: John Linville <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1257631127.15927.455.camel@localhost>
References: <1257631127.15927.455.camel@localhost>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 11:33:35 +0800
Message-Id: <1257737615.5538.996.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-11-08 at 05:58 +0800, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/ipw2x00/ipw2100.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
> index a741d37..8dfdbd3 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> @@ -8465,6 +8465,12 @@ static int ipw2100_get_firmware(struct ipw2100_priv *priv,
>  	return 0;
>  }
>  
> +MODULE_FIRMWARE(IPW2100_FW_NAME("-i"));
> +#ifdef CONFIG_IPW2100_MONITOR
> +MODULE_FIRMWARE(IPW2100_FW_NAME("-p"));
> +#endif
> +MODULE_FIRMWARE(IPW2100_FW_NAME(""));
> +
>  static void ipw2100_release_firmware(struct ipw2100_priv *priv,
>  				     struct ipw2100_fw *fw)
>  {

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

