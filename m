Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbcCQMpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 08:45:09 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eva Rachel Retuya <eraretuya@gmail.com>,
	"outreachy-kernel@googlegroups.com"
	<outreachy-kernel@googlegroups.com>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tj@kernel.org" <tj@kernel.org>
Subject: RE: [PATCH] iwlwifi: dvm: convert create_singlethread_workqueue()
 to alloc_workqueue()
Date: Thu, 17 Mar 2016 12:43:35 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA7C435@hasmsx107.ger.corp.intel.com> (sfid-20160317_134533_814532_668438DA)
References: <1458218246-18807-1-git-send-email-eraretuya@gmail.com>
In-Reply-To: <1458218246-18807-1-git-send-email-eraretuya@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Use alloc_workqueue() to allocate the workqueue instead of
> create_singlethread_workqueue() since the latter is deprecated and is
> scheduled
> for removal.

I can't see any indication of that in the code of workqueue.
Can you share details about that?


> 
> There are work items doing related operations that shouldn't be swapped
> when
> queued in a certain order hence preserve the strict execution ordering of a
> single threaded (ST) workqueue by setting max_active to 1 and adding the
> WQ_UNBOUND flag.
> 
> In addition, there are work items dealing with temperature throttling
> (tt_work,
> ct_enter, ct_exit). Adding the WQ_HIGHPRI flag would place the work items
> in a
> high priority workqueue.
> 
> Lastly, guarantee forward progress for work items depended upon during
> memory
> reclaim by the addition of the WQ_MEM_RECLAIM flag.
> 
> Signed-off-by: Eva Rachel Retuya <eraretuya@gmail.com>
> ---
> To the maintainers:
> Just to confirm, are work items depended upon during memory reclaim? If
> not, the WQ_MEM_RECLAIM flag will be dropped. I added it just in case since
> create_singlethread_workqueue() also sets this flag.
> 
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
> b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
> index f62c2d7..37fa11c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
> +++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
> @@ -1071,7 +1071,8 @@ static void iwl_bg_restart(struct work_struct *data)
> 
>  static void iwl_setup_deferred_work(struct iwl_priv *priv)
>  {
> -	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
> +	priv->workqueue = alloc_workqueue(DRV_NAME, WQ_HIGHPRI |
> WQ_UNBOUND |
> +					  WQ_MEM_RECLAIM, 1);
> 
>  	INIT_WORK(&priv->restart, iwl_bg_restart);
>  	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
> --
> 1.9.1

