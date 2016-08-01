Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14967 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbcHAKtR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 06:49:17 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] mwifiex: remove superfluous condition
Date: Mon, 1 Aug 2016 10:46:12 +0000
Message-ID: <b7cf72a967fe4f58a59a8ba2ce43c299@SC-EXCH04.marvell.com> (sfid-20160801_124926_665826_5686468F)
References: <1469961555-2123-1-git-send-email-xypron.glpk@gmx.de>
In-Reply-To: <1469961555-2123-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Heinrich Schuchardt [mailto:xypron.glpk@gmx.de]
> Sent: Sunday, July 31, 2016 4:09 PM
> To: Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Heinrich Schuchardt
> Subject: [PATCH 1/1] mwifiex: remove superfluous condition
> 
> for_each_property_of_node is only executed if the property prop is not
> NULL.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index 7897037..128add8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -1482,7 +1482,7 @@ int mwifiex_dnld_dt_cfgdata(struct mwifiex_private
> *priv,
>  			continue;
> 
>  		/* property header is 6 bytes, data must fit in cmd buffer
> */
> -		if (prop && prop->value && prop->length > 6 &&
> +		if (prop->value && prop->length > 6 &&
>  		    prop->length <= MWIFIEX_SIZE_OF_CMD_BUFFER - S_DS_GEN) {
>  			ret = mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
>  					       HostCmd_ACT_GEN_SET, 0,

Thanks. The patch looks fine to me.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
