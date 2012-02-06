Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6017 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab2BFJHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 04:07:04 -0500
Date: Mon, 6 Feb 2012 14:36:56 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: add blocking debugfs file for retrieving
 firmware logs
Message-ID: <20120206090654.GA3260@chvasanth-lnx> (sfid-20120206_100711_127325_D5655689)
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
 <20120206062340.20231.55630.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120206062340.20231.55630.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 08:23:40AM +0200, Kalle Valo wrote:
> When debugging firmware issues it's not always enough to get
> the latest firmware logs, sometimes we need to get logs from a longer
> period. To make this possible, add a debugfs file named fwlog_block. When
> reading from this file ath6kl will send firmware logs whenever available
> and otherwise it will block and wait for new logs.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
> +static ssize_t ath6kl_fwlog_block_read(struct file *file,
> +				       char __user *user_buf,
> +				       size_t count,
> +				       loff_t *ppos)
> +{
> +	struct ath6kl *ar = file->private_data;
> +	struct sk_buff *skb;
> +	ssize_t ret_cnt;
> +	size_t len = 0, not_copied;
> +	char *buf;
> +	int ret;
> +
> +	buf = vmalloc(count);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	spin_lock(&ar->debug.fwlog_queue.lock);
> +
> +	if (skb_queue_len(&ar->debug.fwlog_queue) == 0) {
> +		/* we must init under queue lock */
> +		init_completion(&ar->debug.fwlog_completion);
> +
> +		spin_unlock(&ar->debug.fwlog_queue.lock);
> +
> +		ret = wait_for_completion_interruptible(
> +			&ar->debug.fwlog_completion);
> +		if (ret == -ERESTARTSYS)
> +			return ret;
> +
> +		spin_lock(&ar->debug.fwlog_queue.lock);
> +	}
> +
> +	while ((skb = __skb_dequeue(&ar->debug.fwlog_queue))) {
> +		if (skb->len > count - len) {
> +			/* not enough space, put skb back and leave */
> +			__skb_queue_head(&ar->debug.fwlog_queue, skb);
> +			break;
> +		}
> +
> +
> +		memcpy(buf + len, skb->data, skb->len);
> +		len += skb->len;
> +
> +		kfree_skb(skb);
> +	}
> +
> +	spin_unlock(&ar->debug.fwlog_queue.lock);
> +
> +	/* FIXME: what to do if len == 0? */
> +
> +	not_copied = copy_to_user(user_buf, buf, len);
> +	if (not_copied != 0) {
> +		ret_cnt = -EFAULT;
> +		goto out;
> +	}
> +
> +	*ppos = *ppos + len;

Why not to use simple_read_from_buffer()?, looks like it can also
takes care of len == 0 case in the following check.

if (pos >= available || !count)
        return 0;

when available (len) is 0, pos = available with
ath6kl_fwlog_block_read().

Vasanth
