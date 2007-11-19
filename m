Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42381 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXKSIQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 03:16:14 -0500
Subject: Re: [PATCH] iwlwifi: fix possible NULL dereference in
	iwl_set_rate()
From: Zhu Yi <yi.zhu@intel.com>
To: Saleem Abdulrasool <compnerd@compnerd.org>,
	"John W.Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, greg@kroah.com,
	chrisw@sous-sol.org, stable@kernel.org
In-Reply-To: <20071119075908.GA958@compnerd.org>
References: <20071119075908.GA958@compnerd.org>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 16:14:06 +0800
Message-Id: <1195460046.3250.380.camel@debian.sh.intel.com> (sfid-20071119_081626_284451_2C2CC700)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-11-18 at 23:59 -0800, Saleem Abdulrasool wrote:
> As per Zhu Yi's request, Im forwarding along a patch for CVE-2007-5938, a NULL
> dereference vulnerability in the iwlwifi driver.  All current versions are
> effected by this.

ACK.

Thanks,
-yi

> Thanks.
> 
> -- 
> Saleem Abdulrasool
> compnerd (at) compnerd (dot) org
> 
> >From 25db44d4cdfe31d59223d74cb577f4a71aff1a40 Mon Sep 17 00:00:00 2001
> From: Saleem Abdulrasool <compnerd@compnerd.org>
> Date: Mon, 19 Nov 2007 15:28:58 +0800
> Subject: [PATCH] iwlwifi: fix possible NULL dereference in iwl_set_rate()
> 
> Signed-off-by: Saleem Abdulrasool <compnerd@compnerd.org>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  origin/iwl3945-base.c |    4 ++++
>  origin/iwl4965-base.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/origin/iwl3945-base.c b/origin/iwl3945-base.c
> index 5d3e5fe..0885b56 100644
> --- a/origin/iwl3945-base.c
> +++ b/origin/iwl3945-base.c
> @@ -2984,6 +2984,10 @@ static void iwl3945_set_rate(struct iwl3945_priv *priv)
>  	int i;
>  
>  	hw = iwl3945_get_hw_mode(priv, priv->phymode);
> +	if (!hw) {
> +		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
> +		return;
> +	}
>  
>  	priv->active_rate = 0;
>  	priv->active_rate_basic = 0;
> diff --git a/origin/iwl4965-base.c b/origin/iwl4965-base.c
> index abb8016..c57ec27 100644
> --- a/origin/iwl4965-base.c
> +++ b/origin/iwl4965-base.c
> @@ -3093,6 +3093,10 @@ static void iwl4965_set_rate(struct iwl4965_priv *priv)
>  	int i;
>  
>  	hw = iwl4965_get_hw_mode(priv, priv->phymode);
> +	if (!hw) {
> +		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
> +		return;
> +	}
>  
>  	priv->active_rate = 0;
>  	priv->active_rate_basic = 0;
