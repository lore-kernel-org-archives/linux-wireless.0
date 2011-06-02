Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab1FBOzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 10:55:39 -0400
Subject: Re: [PATCH 1/2] iwlagn: fix channel switch locking
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110602144424.GA4580@redhat.com>
References: <20110602144424.GA4580@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 07:27:22 -0700
Message-ID: <1307024842.13397.2.camel@wwguy-huron> (sfid-20110602_165543_601495_B407C8FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2011-06-02 at 07:44 -0700, Stanislaw Gruszka wrote:
> We use priv->mutex to avoid race condtions between iwl_chswitch_done()
> and iwlagn_mac_channel_switch(), when marking channel switch in
> progress. But iwl_chswitch_dane() can be called in atomic context
> from iwl_rx_csa() or with mutex already taken from iwlagn_commit_rxon().
> 
> These bugs were introduced by:
> 
> commit 79d07325502e73508f917475bc1617b60979dd94
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Thu May 6 08:54:11 2010 -0700
> 
>     iwlwifi: support channel switch offload in driver
> 
> To fix remove mutex from iwl_chswitch_done() and use atomic bitops for
> marking channel switch pending.
> 
> Cc: stable@kernel.org # 2.6.36+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-2000.c     |    2 --
>  drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 --
>  drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 --
>  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    6 +++---
>  drivers/net/wireless/iwlwifi/iwl-agn.c      |   19 ++++++++++---------
>  drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +-----
>  drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
>  drivers/net/wireless/iwlwifi/iwl-dev.h      |   13 +------------
>  drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 ++++++++++++------------
>  9 files changed, 28 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
> index a37c41b..33f0ad9 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-2000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
> @@ -244,8 +244,6 @@ static int iwl2030_hw_channel_switch(struct iwl_priv *priv,
>  			ctx->active.channel, ch);
>  		return -EFAULT;
>  	}
> -	priv->switch_rxon.channel = cmd.channel;
> -	priv->switch_rxon.switch_in_progress = true;
>  
>  	return iwl_send_cmd_sync(priv, &hcmd);
>  }
Thank you for fix my mistake.
Could you please remove the channel switch from iwl-2000.c all together.
2000 series are 2.4 GHz only 

Thanks
Wey

