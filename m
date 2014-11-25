Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:60152 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKYIkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:40:19 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: add register access debugfs interface
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
	<20141124164159.29422.98462.stgit@potku.adurom.net>
Date: Tue, 25 Nov 2014 10:39:55 +0200
In-Reply-To: <20141124164159.29422.98462.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 24 Nov 2014 18:41:59 +0200")
Message-ID: <87vbm31xno.fsf@kamboji.qca.qualcomm.com> (sfid-20141125_094022_470378_CAFFC71E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> +static ssize_t ath10k_reg_value_read(struct file *file,
> +				     char __user *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	u8 buf[48];
> +	unsigned int len;
> +	u32 reg_addr, reg_val;
> +
> +	spin_lock_bh(&ar->data_lock);
> +	reg_addr = ar->debug.reg_addr;
> +	spin_unlock_bh(&ar->data_lock);
> +
> +	reg_val = ath10k_hif_read32(ar, reg_addr);
> +	len = scnprintf(buf, sizeof(buf), "0x%08x:0x%08x\n", reg_addr, reg_val);
> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +}

I just realised that we need to check ar->state to make sure that
firmware is running. Because of that I'll need to change the data_lock
to conf_mutex as well.

> +static ssize_t ath10k_reg_value_write(struct file *file,
> +				      const char __user *user_buf,
> +				      size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	u32 reg_addr, reg_val;
> +	int ret;
> +
> +	spin_lock_bh(&ar->data_lock);
> +	reg_addr = ar->debug.reg_addr;
> +	spin_unlock_bh(&ar->data_lock);
> +
> +	ret = kstrtou32_from_user(user_buf, count, 0, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	ath10k_hif_write32(ar, reg_addr, reg_val);
> +
> +	return count;
> +}

And same here as well. I'll send v3.

-- 
Kalle Valo
