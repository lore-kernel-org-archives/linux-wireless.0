Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63410 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605AbbJ3PEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 11:04:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH V4] ath10k: Debugfs entry to enable/disable WLAN&Blutooth Coexist feature
References: <1445644464-8454-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Fri, 30 Oct 2015 17:04:17 +0200
In-Reply-To: <1445644464-8454-1-git-send-email-yanbol@qca.qualcomm.com> (Yanbo
	Li's message of "Fri, 23 Oct 2015 16:54:24 -0700")
Message-ID: <87h9l8mm8e.fsf@kamboji.qca.qualcomm.com> (sfid-20151030_160444_241316_D3D75879)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> As some radio have no connection with BT modules, enable the WLAN/Bluetooth
> coexist(BTC) feature will has some side effect if the radio's GPIO connect
> with any other HW modules. Add the control switcher "btc_feature" at
> debugfs and set the feature as disable by default to avoid such case.
>
> The FW support this feature since 10.2.4.54 on 2G-only board, dual band
> or 5G boards don't support the feature
>
> To enable this feature, execute:
> echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> To disable:
> echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
>
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

You missed some of my comments from v1, especially about the file name.
Let me send v5.

https://patchwork.kernel.org/patch/6313091/

> +static ssize_t ath10k_write_btc_feature(struct file *file,
> +					const char __user *ubuf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	char buf[32];
> +	size_t buf_size;
> +	bool val;
> +	int ret;
> +
> +	buf_size = min(count, (sizeof(buf) - 1));
> +	if (copy_from_user(buf, ubuf, buf_size))
> +		return -EFAULT;
> +
> +	buf[buf_size] = '\0';
> +	if (strtobool(buf, &val) != 0) {
> +		ath10k_warn(ar, "Wrong BTcoex feature setting\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&ar->conf_mutex);
> +
> +	if (ar->state != ATH10K_STATE_ON) {
> +		ret = -ENETDOWN;
> +		goto err_unlock;
> +	}
> +
> +	if (val != test_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags)) {
> +		if (val)
> +			set_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags);
> +		else
> +			clear_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags);
> +		queue_work(ar->workqueue, &ar->restart_work);
> +	}

I don't think this is a good idea, now you cannot change the value while
interface is down. I think it would be more user friendly to allow
changing the value but obviously not reboot the firmware as it's not
running.

-- 
Kalle Valo
