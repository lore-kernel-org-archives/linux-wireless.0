Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18485 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934958AbeEINmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:42:52 -0400
Subject: Re: [PATCH 17/30] staging: wilc1000: fix line over 80 chars in
 wilc_wfi_cfg_tx_vendor_spec()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-18-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <b2dbe1be-c94d-a999-2423-3e8bd4c25130@microchip.com> (sfid-20180509_154255_840875_736D2CF0)
Date: Wed, 9 May 2018 16:42:45 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-18-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Fix line over 80 characters issues reported by checkpatch.pl script in
> wilc_wfi_cfg_tx_vendor_spec() by using temporary variable. Simplified
> 'if else' condition with 'if'.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 4f35178..8dea414 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -1573,14 +1573,14 @@ static void wilc_wfi_cfg_tx_vendor_spec(struct p2p_mgmt_data *mgmt_tx,
>  	for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
>  		if (buf[i] == P2PELEM_ATTR_ID &&
>  		    !memcmp(p2p_oui, &buf[i + 2], 4)) {
> +			bool oper_ch = false;
> +			u8 *tx_buff = &mgmt_tx->buff[i + 6];
> +
>  			if (subtype == P2P_INV_REQ || subtype == P2P_INV_RSP)
> -				wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6],
> -							     len - (i + 6),
> -							     true, iftype);
> -			else
> -				wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6],
> -							     len - (i + 6),
> -							     false, iftype);
> +				oper_ch = true;
> +
> +			wilc_wfi_cfg_parse_tx_action(tx_buff, len - (i + 6),
> +						     oper_ch, iftype);

What about:
			wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6],
						     len - (i + 6),
						     (subtype == P2P_INV_REQ ||
						      subtype == P2P_INV_RSP),
						     iftype);


instead all the temporary variables?

>  
>  			break;
>  		}
> 
