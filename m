Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2263 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYE1U6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 16:58:12 -0400
Date: Wed, 28 May 2008 16:22:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2.6.26 1/3] iwlwifi: fix in-column rate scaling
Message-ID: <20080528202201.GC25770@tuxdriver.com> (sfid-20080528_225817_625784_12E67600)
References: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 11:29:33AM +0800, Zhu Yi wrote:
> From: Guy Cohen <guy.cohen@intel.com>
> 
> This patch fixes cases that the code raised or didn't decrease
> the rate although the success ratio was not good.
> 
> Signed-off-by: Guy Cohen <guy.cohen@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   45 ++++++++++++++-------------
>  1 files changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> index 2adc228..fa41ed1 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> @@ -1339,7 +1339,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
>  				lq_sta->search_better_tbl = 1;
>  				goto out;
>  			}
> -
> +			break;
>  		case IWL_LEGACY_SWITCH_SISO:
>  			IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
>  
> @@ -1425,9 +1425,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
>  				lq_sta->search_better_tbl = 1;
>  				goto out;
>  			}
> -
> +			break;
>  		case IWL_SISO_SWITCH_MIMO2:
> -			IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
> +			IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
>  			memcpy(search_tbl, tbl, sz);
>  			search_tbl->is_SGI = 0;
>  			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/

These hunks don't apply to wireless-2.6.

-- 
John W. Linville
linville@tuxdriver.com
