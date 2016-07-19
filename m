Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36366 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcGSK04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:26:56 -0400
Received: by mail-pf0-f170.google.com with SMTP id h186so6144770pfg.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:26:56 -0700 (PDT)
Subject: Re: [PATCH 4/4] brcmsmac: Initialize power in
 brcms_c_stf_ss_algo_channel_get()
To: Florian Fainelli <f.fainelli@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <1468884277-18606-5-git-send-email-f.fainelli@gmail.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <da2c1906-a951-cb7d-98fc-5851393b13b8@broadcom.com> (sfid-20160719_122700_105074_083213D3)
Date: Tue, 19 Jul 2016 12:26:50 +0200
MIME-Version: 1.0
In-Reply-To: <1468884277-18606-5-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-7-2016 1:24, Florian Fainelli wrote:
> wlc_phy_txpower_get_current() does a logical OR of power->flags, which
> presumes that power.flags was initiliazed earlier by the caller,
> unfortunately, this is not the case, so make sure we zero out the struct
> tx_power before calling into wlc_phy_txpower_get_current().
> 
> Reported-by: coverity (CID 146011)
> Fixes: 5b435de0d7868 ("net: wireless: add brcm80211 drivers")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
> index dd9162722495..0ab865de1491 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
> @@ -87,7 +87,7 @@ void
>  brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
>  			    u16 chanspec)
>  {
> -	struct tx_power power;
> +	struct tx_power power = { };
>  	u8 siso_mcs_id, cdd_mcs_id, stbc_mcs_id;
>  
>  	/* Clear previous settings */
> 
