Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55399 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbLKIe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 03:34:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH] mwifiex: parse hscfg_gpio info from device tree
References: <1448618297-19803-1-git-send-email-akarwar@marvell.com>
Date: Fri, 11 Dec 2015 10:34:21 +0200
In-Reply-To: <1448618297-19803-1-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Fri, 27 Nov 2015 01:58:17 -0800")
Message-ID: <87vb855qpe.fsf@kamboji.qca.qualcomm.com> (sfid-20151211_093436_906841_F38ED5C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ devicetree list

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> This patch reads hscfg_gpio from device tree and update
> internal variable
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index e486867..d28a53f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -1459,10 +1459,21 @@ int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
>  #ifdef CONFIG_OF
>  	struct property *prop;
>  	size_t len = strlen(prefix);
> +	u32 data;
>  	int ret;
>  
>  	/* look for all matching property names */
>  	for_each_property_of_node(node, prop) {
> +		if (!strncmp(prop->name, "marvell,hscfg_gpio",
> +			     strlen("marvell,hscfg_gpio"))) {
> +			if (!of_property_read_u32(priv->adapter->dt_node,
> +						  prop->name, &data)) {
> +				dev_dbg(priv->adapter->dev,
> +					"hscfg gpio = 0x%x\n", data);
> +				priv->adapter->hs_cfg.gpio = data;
> +			}
> +		}

I don't see this documented in Documentation/devicetree/bindings. Please
create a binding document and review it with the device tree
maintainers.

Actually when looking mwifiex close I see that it uses more undocumented
device tree interfaces:

marvell_cfgdata
marvell,caldata
marvell,00_txpwrlimit

I think these all should be properly documented and reviewed. But I'll
let the device tree people chime in what's the best way.

-- 
Kalle Valo
