Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31301 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKYIlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:41:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add memory dump debugfs interface
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
	<20141124164208.29422.76134.stgit@potku.adurom.net>
Date: Tue, 25 Nov 2014 10:41:25 +0200
In-Reply-To: <20141124164208.29422.76134.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 24 Nov 2014 18:42:08 +0200")
Message-ID: <87r3wr1xl6.fsf@kamboji.qca.qualcomm.com> (sfid-20141125_094139_615259_AF645BC2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> +static ssize_t ath10k_mem_value_read(struct file *file,
> +				     char __user *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	u8 *buf;
> +	int ret;
> +
> +	if (*ppos < 0)
> +		return -EINVAL;
> +
> +	if (!count)
> +		return 0;
> +
> +	buf = vmalloc(count);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = ath10k_hif_diag_read(ar, *ppos, buf, count);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to read address 0x%08x via diagnose window from debugfs: %d\n",
> +			    (u32)(*ppos), ret);
> +		goto read_err;
> +	}
> +

[...]

> +static ssize_t ath10k_mem_value_write(struct file *file,
> +				      const char __user *user_buf,
> +				      size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	u8 *buf;
> +	int ret;
> +
> +	if (*ppos < 0)
> +		return -EINVAL;
> +
> +	if (!count)
> +		return 0;
> +
> +	buf = vmalloc(count);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = copy_from_user(buf, user_buf, count);
> +	if (ret)
> +		goto err_free_copy;
> +
> +	ret = ath10k_hif_diag_write(ar, *ppos, buf, count);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to write address 0x%08x via diagnose window from debugfs: %d\n",
> +			    (u32)(*ppos), ret);
> +		goto err_free_copy;
> +	}

In these two functions we also need to check ar->state.

-- 
Kalle Valo
