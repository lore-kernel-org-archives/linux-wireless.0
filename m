Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:24799 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754024AbZLAKUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 05:20:33 -0500
Date: Tue, 1 Dec 2009 11:22:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwmc3200wifi: fix NULL pointer dereference in pmkid
 update
Message-ID: <20091201102214.GB6492@sortiz.org>
References: <1259639330-8291-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1259639330-8291-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 01, 2009 at 11:48:50AM +0800, Zhu Yi wrote:
> When handling IWM_CMD_PMKID_FLUSH command, the bssid and
> pmkid in pmksa are all NULL. Check it before memcpy.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Good catch, thanks Yi.

Cheers,
Samuel.

> ---
>  drivers/net/wireless/iwmc3200wifi/commands.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
> index bd06307..89b33fa 100644
> --- a/drivers/net/wireless/iwmc3200wifi/commands.c
> +++ b/drivers/net/wireless/iwmc3200wifi/commands.c
> @@ -970,8 +970,10 @@ int iwm_send_pmkid_update(struct iwm_priv *iwm,
>  	memset(&update, 0, sizeof(struct iwm_umac_pmkid_update));
>  
>  	update.command = cpu_to_le32(command);
> -	memcpy(&update.bssid, pmksa->bssid, ETH_ALEN);
> -	memcpy(&update.pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
> +	if (pmksa->bssid)
> +		memcpy(&update.bssid, pmksa->bssid, ETH_ALEN);
> +	if (pmksa->pmkid)
> +		memcpy(&update.pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
>  
>  	ret = iwm_send_wifi_if_cmd(iwm, &update,
>  				   sizeof(struct iwm_umac_pmkid_update), 0);
> -- 
> 1.6.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
