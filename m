Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108Ab0EKBTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 21:19:30 -0400
Subject: Re: [patch 1/9] iwlwifi: remove stray mutex_unlock()
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100508162101.GM27064@bicker>
References: <20100508162101.GM27064@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 09:12:53 +0800
Message-ID: <1273540373.27831.40.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-05-09 at 00:21 +0800, Dan Carpenter wrote:
> This mutex_unlock() has been here from the initial commit, but as nearly
> as I can tell, there isn't a reason for it.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 9dad867..3faa78c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -2482,7 +2482,6 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
>  				   &priv->_3945.shared_phys, GFP_KERNEL);
>  	if (!priv->_3945.shared_virt) {
>  		IWL_ERR(priv, "failed to allocate pci memory\n");
> -		mutex_unlock(&priv->mutex);
>  		return -ENOMEM;
>  	}

Yeah, a mistake, definitely.

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

