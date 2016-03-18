Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbcCRKvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 06:51:04 -0400
Date: Fri, 18 Mar 2016 11:48:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH MOREWORK 17/19] iwl4965: Fix a memory leak in error
 handling code of __il4965_up
Message-ID: <20160318104846.GD24990@redhat.com> (sfid-20160318_115111_525145_E4A3AD7D)
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <3aaac3629455d27b0e9c56ef1615b89873b1b8cf.1458262312.git.julian.calaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3aaac3629455d27b0e9c56ef1615b89873b1b8cf.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 01:28:33PM +1100, Julian Calaby wrote:
> From: Jia-Ju Bai <baijiaju1990@163.com>
> 
> When il4965_hw_nic_init in __il4965_up fails, the memory allocated by
> iwl4965_sta_alloc_lq in iwl4965_alloc_bcast_station is not freed.
> 
> This patches adds il_dealloc_bcast_stations in the error handling code of
> __il4965_up to fix this problem.
> 
> This patch has been tested in real device, and it actually fixes the bug.

Could the call trace from the bug be provided ?

> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> ---
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> index b75f4ef..30d9dd3 100644
> --- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> @@ -5577,6 +5577,7 @@ __il4965_up(struct il_priv *il)
>  	ret = il4965_hw_nic_init(il);
>  	if (ret) {
>  		IL_ERR("Unable to init nic\n");
> +		il_dealloc_bcast_stations(il);

I missed that before, but now this look suspicious for me.

il_dealloc_bcast_stations() do:

                il->num_stations--;
                BUG_ON(il->num_stations < 0);

But on il4965_alloc_bcast_station() we do not increase il->num_stations
Hence either this BUG_ON should be removed or il->num_stations should be
increased during allocation.

Stanislaw
