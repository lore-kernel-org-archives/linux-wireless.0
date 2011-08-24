Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39410 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1HXSAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 14:00:23 -0400
Date: Wed, 24 Aug 2011 13:48:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rodrigue@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, rmanohar@qca.qualcomm.com,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH] ath9k_htc: Fix few possible memory leaks
Message-ID: <20110824174835.GH9770@tuxdriver.com> (sfid-20110824_200026_467789_6BAD34D4)
References: <1313942085-6238-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313942085-6238-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this intended for 3.1?  Should it be Cc: stable@kernel.org as well?

On Sun, Aug 21, 2011 at 09:24:45PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> still there are few other memory leaks which will be fixed
> very soon
> 
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/ath/ath9k/htc_hst.c |   13 ++++++++-----
>  drivers/net/wireless/ath/ath9k/wmi.c     |    3 ++-
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index 1b90ed8..e435c9b 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -169,13 +169,14 @@ static int htc_config_pipe_credits(struct htc_target *target)
>  	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
>  	if (!time_left) {
>  		dev_err(target->dev, "HTC credit config timeout\n");
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto err;
>  	}
>  
>  	return 0;
>  err:
>  	kfree_skb(skb);
> -	return -EINVAL;
> +	return ret;
>  }
>  
>  static int htc_setup_complete(struct htc_target *target)
> @@ -204,14 +205,15 @@ static int htc_setup_complete(struct htc_target *target)
>  	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
>  	if (!time_left) {
>  		dev_err(target->dev, "HTC start timeout\n");
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto err;
>  	}
>  
>  	return 0;
>  
>  err:
>  	kfree_skb(skb);
> -	return -EINVAL;
> +	return ret;
>  }
>  
>  /* HTC APIs */
> @@ -276,7 +278,8 @@ int htc_connect_service(struct htc_target *target,
>  	if (!time_left) {
>  		dev_err(target->dev, "Service connection timeout for: %d\n",
>  			service_connreq->service_id);
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto err;
>  	}
>  
>  	*conn_rsp_epid = target->conn_rsp_epid;
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
> index 35422fc..50d901d 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -334,7 +334,8 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
>  			"Timeout waiting for WMI command: %s\n",
>  			wmi_cmd_to_name(cmd_id));
>  		mutex_unlock(&wmi->op_mutex);
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto out;
>  	}
>  
>  	mutex_unlock(&wmi->op_mutex);
> -- 
> 1.7.0.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
