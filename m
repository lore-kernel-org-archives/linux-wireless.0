Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34300 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbbE0M5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 08:57:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<michal.kazior@tieto.com>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Debugfs entry to enable/disable BTC feature
References: <1430514659-11743-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Wed, 27 May 2015 15:56:57 +0300
In-Reply-To: <1430514659-11743-1-git-send-email-yanbol@qca.qualcomm.com>
	(Yanbo Li's message of "Fri, 1 May 2015 14:10:59 -0700")
Message-ID: <871ti218me.fsf@kamboji.qca.qualcomm.com> (sfid-20150527_145716_565054_5A23DFAE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> As some radio have no connection with BT modules, enable the BTC feature
> will has some side effect if the radio's GPIO connect with any other HW
> modules. Add the control switcher "btc_feature" at debugfs and set the
> feature as disable by default to avoid such case.
>
> To enable this feature, execute:
> echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> To disable:
> echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature

I suspect "BTC" does not really tell much for most of the people and
acronyms should be always spelled out at least once.

> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 8444adf42195..6852e7fc5d5f 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -720,6 +720,8 @@ struct ath10k {
>  		u32 fw_cold_reset_counter;
>  	} stats;
>  
> +	bool btc_feature;

Could we use ar->dev_flags instead?

> +static ssize_t ath10k_write_btc_feature(struct file *file,
> +					const char __user *ubuf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	char buf[32];
> +	size_t buf_size;
> +	bool val;
> +
> +	buf_size = min(count, (sizeof(buf) - 1));
> +	if (copy_from_user(buf, ubuf, buf_size))
> +		return -EFAULT;
> +
> +	buf[buf_size] = '\0';
> +	if (strtobool(buf, &val) != 0) {
> +		ath10k_warn(ar, "Wrong BTC feature setting\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&ar->conf_mutex);
> +	ar->btc_feature = val;
> +	queue_work(ar->workqueue, &ar->restart_work);
> +	mutex_unlock(&ar->conf_mutex);

Shouldn't we test ATH10K_STATE_ON first?

>  int ath10k_debug_create(struct ath10k *ar)
>  {
>  	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
> @@ -2195,6 +2243,8 @@ int ath10k_debug_register(struct ath10k *ar)
>  	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
>  			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
>  
> +	debugfs_create_file("btc_feature", S_IRUGO | S_IWUSR,
> +			    ar->debug.debugfs_phy, ar,
> &fops_btc_feature);

At least some of the other drivers use term btcoex for this, I think we
should be consistent and use the same.

I can do the changes and send v2 for this.

-- 
Kalle Valo
