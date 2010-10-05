Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:57434 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab0JEGnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 02:43:09 -0400
Date: Tue, 5 Oct 2010 08:43:05 +0200
From: Florian Mickler <florian@mickler.org>
To: stable@kernel.org
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Fw: [PATCH] iwl3945: queue the right work if the scan needs to be
 aborted
Message-ID: <20101005084305.52a31ed4@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit e7ee762cf074b0fd8eec483d0cef8fdbf0d04b81


Begin forwarded message:

Date: Mon, 27 Sep 2010 13:11:54 -0700
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Florian Mickler <florian@mickler.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
"Chatre, Reinette" <reinette.chatre@intel.com>, Intel Linux Wireless
<ilw@linux.intel.com>, "John W. Linville" <linville@tuxdriver.com>,
"Berg, Johannes" <johannes.berg@intel.com>, Zhu Yi <yi.zhu@intel.com>,
"Cahill, Ben M" <ben.m.cahill@intel.com>,  "netdev@vger.kernel.org"
<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
<linux-kernel@vger.kernel.org> Subject: Re: [PATCH] iwl3945: queue the
right work if the scan needs to be aborted


On Fri, 2010-09-24 at 09:22 -0700, Florian Mickler wrote:
> iwl3945's scan_completed calls into the mac80211 stack which triggers a
> warn on if there is no scan outstanding.
> 
> This can be avoided by not calling scan_completed but abort_scan in
> iwl3945_request_scan  in the done: branch of the function which is used
> as an error out.
> 
> The done: branch seems to be an error-out branch, as, for example, if
> iwl_is_ready(priv) returns false  the done: branch is executed.
> 
> NOTE:
> I'm not familiar with the driver at all.
> I just quickly scanned as a reaction to
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=17722
> 
> the users of scan_completed in the  iwl3945 driver and noted the odd
> discrepancy between the comment above this instance and the comment in
> mac80211 scan_completed function.
> Signed-off-by: Florian Mickler <florian@mickler.org>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
go into wireless-2.6 and stable only, scan fix already in
wireless-next-2.6

Thanks
Wey

>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index 9dd9e64..8fd00a6 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1411,7 +1411,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  	clear_bit(STATUS_SCAN_HW, &priv->status);
>  	clear_bit(STATUS_SCANNING, &priv->status);
>  	/* inform mac80211 scan aborted */
> -	queue_work(priv->workqueue, &priv->scan_completed);
> +	queue_work(priv->workqueue, &priv->abort_scan);
>  }
>  
>  int iwlagn_manage_ibss_station(struct iwl_priv *priv,
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 59a308b..d31661c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -3018,7 +3018,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  	clear_bit(STATUS_SCANNING, &priv->status);
>  
>  	/* inform mac80211 scan aborted */
> -	queue_work(priv->workqueue, &priv->scan_completed);
> +	queue_work(priv->workqueue, &priv->abort_scan);
>  }
>  
>  static void iwl3945_bg_restart(struct work_struct *data)

