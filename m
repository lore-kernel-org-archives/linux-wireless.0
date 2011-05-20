Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:39469 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1ETUtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 16:49:41 -0400
Message-ID: <4DD6D3C7.9010401@oracle.com> (sfid-20110520_224945_378291_CFC0F67F)
Date: Fri, 20 May 2011 13:49:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH wireless-2.6.40] iwlagn: dbg_fixed_rate only used when
 CONFIG_MAC80211_DEBUGFS enabled
References: <1305917778-15303-1-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1305917778-15303-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/11 11:56, Wey-Yi Guy wrote:
> Fix compiling error when CONFIG_MAC80211_DEBUGFS is not enabled
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:351: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'
> drivers/net/wireless/iwlwifi/iwl-agn-rs.c:1076: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> these patches are also available from wireless-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> index f95c0a4..2f661df 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> @@ -334,7 +334,7 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
>  	return tid;
>  }
>  
> -#if defined(CONFIG_MAC80211_DEBUGFS) || defined(CONFIG_IWLWIFI_DEVICE_SVTOOL)
> +#ifdef CONFIG_MAC80211_DEBUGFS
>  static void rs_program_fix_rate(struct iwl_priv *priv,
>  				struct iwl_lq_sta *lq_sta)
>  {
> @@ -1071,7 +1071,7 @@ done:
>  	/* See if there's a better rate or modulation mode to try. */
>  	if (sta && sta->supp_rates[sband->band])
>  		rs_rate_scale_perform(priv, skb, sta, lq_sta);
> -#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
> +#ifdef CONFIG_MAC80211_DEBUGFS
>  	if (priv->dbg_fixed_rate != lq_sta->dbg_fixed_rate)
>  		rs_program_fix_rate(priv, lq_sta);
>  #endif


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
