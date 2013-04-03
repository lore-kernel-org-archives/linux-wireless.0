Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39124 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491Ab3DCSAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 14:00:54 -0400
Date: Wed, 3 Apr 2013 13:46:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix DFS detector called in softirq context
Message-ID: <20130403174606.GA31358@tuxdriver.com> (sfid-20130403_200059_488391_3AB2B046)
References: <1364899908-7433-1-git-send-email-zefir.kurtisi@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364899908-7433-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like this could apply to 3.9 -- should it be applied there?

On Tue, Apr 02, 2013 at 12:51:48PM +0200, Zefir Kurtisi wrote:
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    4 ++--
>  drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
> index 467b600..73fe8d6 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
> @@ -143,14 +143,14 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
>  	u32 sz, i;
>  	struct channel_detector *cd;
>  
> -	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
> +	cd = kmalloc(sizeof(*cd), GFP_ATOMIC);
>  	if (cd == NULL)
>  		goto fail;
>  
>  	INIT_LIST_HEAD(&cd->head);
>  	cd->freq = freq;
>  	sz = sizeof(cd->detectors) * dpd->num_radar_types;
> -	cd->detectors = kzalloc(sz, GFP_KERNEL);
> +	cd->detectors = kzalloc(sz, GFP_ATOMIC);
>  	if (cd->detectors == NULL)
>  		goto fail;
>  
> diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
> index 91b8dce..5e48c55 100644
> --- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
> +++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
> @@ -218,7 +218,7 @@ static bool pulse_queue_enqueue(struct pri_detector *pde, u64 ts)
>  {
>  	struct pulse_elem *p = pool_get_pulse_elem();
>  	if (p == NULL) {
> -		p = kmalloc(sizeof(*p), GFP_KERNEL);
> +		p = kmalloc(sizeof(*p), GFP_ATOMIC);
>  		if (p == NULL) {
>  			DFS_POOL_STAT_INC(pulse_alloc_error);
>  			return false;
> @@ -299,7 +299,7 @@ static bool pseq_handler_create_sequences(struct pri_detector *pde,
>  		ps.deadline_ts = ps.first_ts + ps.dur;
>  		new_ps = pool_get_pseq_elem();
>  		if (new_ps == NULL) {
> -			new_ps = kmalloc(sizeof(*new_ps), GFP_KERNEL);
> +			new_ps = kmalloc(sizeof(*new_ps), GFP_ATOMIC);
>  			if (new_ps == NULL) {
>  				DFS_POOL_STAT_INC(pseq_alloc_error);
>  				return false;
> -- 
> 1.7.4.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
