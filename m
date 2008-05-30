Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:14183 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYE3LrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 07:47:14 -0400
Received: by rn-out-0910.google.com with SMTP id k40so2045902rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 04:47:13 -0700 (PDT)
Message-ID: <1ba2fa240805300447t1eb22a80v7a0623efe0b07b17@mail.gmail.com> (sfid-20080530_134733_037568_55485861)
Date: Fri, 30 May 2008 14:47:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 40/43] iwlwifi: fix a memory leak in scan
Cc: linux-wireless@vger.kernel.org, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1212050128-17132-41-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-40-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-41-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 11:35 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> This patch fixes a memory leak that the scan buffer isn't released
> on exit.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index c9bbfbb..61716ba 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -911,6 +911,7 @@ void iwl_uninit_drv(struct iwl_priv *priv)
>        iwl_free_calib_results(priv);
>        iwlcore_free_geos(priv);
>        iwl_free_channel_map(priv);
> +       kfree(priv->scan);
>  }
>  EXPORT_SYMBOL(iwl_uninit_drv);
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 244bfe5..72279e0 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -8257,7 +8257,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
>
>        iwl3945_free_channel_map(priv);
>        iwl3945_free_geos(priv);
> -
> +       kfree(priv->scan);
>        if (priv->ibss_beacon)
>                dev_kfree_skb(priv->ibss_beacon);
>
> --
> 1.5.3.6
>

This one is also for 2.6.26
