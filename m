Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:36902 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898Ab1HYI0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 04:26:40 -0400
Subject: Re: [PATCH V2 3/3] ath6kl: Add debugfs file entry to dump credit
 distribution stats
From: Joe Perches <joe@perches.com>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	kvalo@adurom.com
In-Reply-To: <1314257441-8092-3-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314257441-8092-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1314257441-8092-3-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 01:26:37 -0700
Message-ID: <1314260797.15882.63.camel@Joe-Laptop> (sfid-20110825_102645_161043_426755B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 13:00 +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
[]
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
[]
> +static ssize_t read_file_credit_dist_stats(struct file *file,
> +					   char __user *user_buf,
> +					   size_t count, loff_t *ppos)
> +{
> +	struct ath6kl *ar = file->private_data;
> +	struct htc_target *target = ar->htc_target;
> +	struct htc_endpoint_credit_dist *ep_list;
> +	char *buf;
> +	unsigned int buf_len = 128, len = 0;
> +	ssize_t ret_cnt;
> +
> +	buf_len += get_queue_depth(&target->cred_dist_list) * 128;

Doesn't look like 128 is the right size.

> +	buf = kzalloc(buf_len, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;

kmalloc can run out of space pretty quickly if cred_dist_list
is large.  Maybe vmalloc?

> +
> +	len += scnprintf(buf + len, buf_len - len,
> +			 " Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd"
> +			 "  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist"
> +			 "  qdepth\n");
> +
> +	list_for_each_entry(ep_list, &target->cred_dist_list, list) {
> +		len += scnprintf(buf + len, buf_len - len, "  %2d",
> +				 ep_list->endpoint);
> +		len += scnprintf(buf + len, buf_len - len, "%10x",
> +				 ep_list->dist_flags);

I think this is nearly unreadable.
It doesn't line up well with your header.

Why not align them correctly or otherwise make no
attempt to align them at all?

Your current header and field widths:

          1         2         3         4         5         6         7         8         9        10        11        12 
 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	len += scnprintf(buf + len, buf_len - len,
" Epid  Flags    Cred_norm  Cred_min  Credits  Cred_assngd  Seek_cred  Cred_sz  Cred_per_msg  Cred_to_dist  qdepth\n");
   12          12345678         123456789          1234567890123            123456789              123456789012
     1234567890        123456789         1234567890             123456789012         12345678901234

> +	list_for_each_entry(ep_list, &target->cred_dist_list, list) {
> +		len += scnprintf(buf + len, buf_len - len, "  %2d",
> +				 ep_list->endpoint);
> +		len += scnprintf(buf + len, buf_len - len, "%10x",
> +				 ep_list->dist_flags);

maybe use a macro:
#define ep_list_field(fmt, field)	\ 
	len += scnprint(buf + len, buf_len - len, fmt, ep_list->field)

		ep_list_field("  %2d", endpoint);
		ep_list_field("%9d", cred_min);
		ep_list_field("%9d", credits);
etc

> +		len += scnprintf(buf + len, buf_len - len, "%12d\n",
> +				 get_queue_depth(&((struct htc_endpoint *)
> +						 ep_list->htc_rsvd)->txq));
> +	}


