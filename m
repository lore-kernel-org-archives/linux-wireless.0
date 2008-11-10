Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57583 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbYKJB0E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 20:26:04 -0500
Subject: Re: [PATCH 2/2] iwlwifi: fix suspend to RAM in iwlwifi
From: Zhu Yi <yi.zhu@intel.com>
To: Tomas Winkler <tomas.winkler@intel.com>, greg@kroah.com
Cc: "stable@kernel.org" <stable@kernel.org>,
	"rjw@sisk.pl" <rjw@sisk.pl>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1226191867-22324-3-git-send-email-tomas.winkler@intel.com>
References: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com>
	 <1226191867-22324-2-git-send-email-tomas.winkler@intel.com>
	 <1226191867-22324-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 09:26:16 +0800
Message-Id: <1226280376.2604.280.camel@debian.sh.intel.com> (sfid-20081110_022621_068066_E5D6F53C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-11-09 at 08:51 +0800, Tomas Winkler wrote:
> This patch fixes suspend to RAM after by moving
> notify_mac out of iwlwifi mutex
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11845

Greg, please also merge the iwl3945 counterpart for this problem.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d54bc4e3fc5c56600a13c9ebc0a7e1077ac05d59

Thanks,
-yi


> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Tested-by: Carlos R. Mafra <crmafra2@gmail.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index e01f048..edab202 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
>  		iwl4965_error_recovery(priv);
>  
>  	iwl_power_update_mode(priv, 1);
> -	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>  
>  	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
>  		iwl4965_set_mode(priv, priv->iw_mode);
> @@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
>  	mutex_lock(&priv->mutex);
>  	iwl_alive_start(priv);
>  	mutex_unlock(&priv->mutex);
> +	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
>  }
>  
>  static void iwl4965_bg_rf_kill(struct work_struct *work)

