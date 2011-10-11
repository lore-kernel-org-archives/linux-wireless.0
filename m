Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43661 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753424Ab1JKQjc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 12:39:32 -0400
Message-ID: <1318351171.1839.43.camel@Joe-Laptop> (sfid-20111011_183936_113513_EB2146D0)
Subject: Re: [PATCH v2 1/5] ath6kl: Add endpoint_stats debugfs file
From: Joe Perches <joe@perches.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 11 Oct 2011 09:39:31 -0700
In-Reply-To: <1318343517-15292-2-git-send-email-jouni@qca.qualcomm.com>
References: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
	 <1318343517-15292-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 17:31 +0300, Jouni Malinen wrote:
> This file can be used to fetch endpoint statistics counters and
> to clear them by writing 0 to it.

Hi Jouni.

[petty carping follows]

> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/debug.c |  102 +++++++++++++++++++++++++++++++
>  1 files changed, 102 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
> index ba3f23d..b9bf28d 100644
> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -595,6 +595,105 @@ static const struct file_operations fops_credit_dist_stats = {
>  	.llseek = default_llseek,
>  };
>  
> +static unsigned int print_endpoint_stat(struct htc_target *target, char *buf,
> +					unsigned int buf_len, unsigned int len,
> +					int offset, const char *name)

Perhaps the function name is wrong.
This doesn't print, it fills a buffer.
len and offset are to me oddly used variable names.

> +{
> +	int i;
> +	struct htc_endpoint_stats *ep_st;
> +	u32 *counter;
> +
> +	len += scnprintf(buf + len, buf_len - len, "%s:", name);
> +	for (i = 0; i < ENDPOINT_MAX; i++) {
> +		ep_st = &target->endpoint[i].ep_st;
> +		counter = ((u32 *) ep_st) + (offset / 4);
> +		len += scnprintf(buf + len, buf_len - len, " %u", *counter);
> +	}
> +	len += scnprintf(buf + len, buf_len - len, "\n");
> +
> +	return len;
> +

perhaps:

static int endpoint_stats(struct htc_target *target,
			  char *buf, size_t len,
			  size_t pos, int index, const char *name)
{
	int i;

	pos += scnprintf(buf + pos, len - pos, "%s:", name);
	for (i = 0; i < ENDPOINT_MAX; i++) {
		u32 *stats = (u32 *)&target->endpoint[i].ep_st;
		offset += scnprintf(buf + pos, len - pos, " %u", stats[index]);
	}
	pos += scnprintf(buf + pos, len - pos, "\n");

	return pos;
}

> }
> +
> +static ssize_t ath6kl_endpoint_stats_read(struct file *file,
> +					  char __user *user_buf,
> +					  size_t count, loff_t *ppos)
> +{
> +	struct ath6kl *ar = file->private_data;
> +	struct htc_target *target = ar->htc_target;
> +	char *buf;
> +	unsigned int buf_len, len = 0;

size_t len = 0;
(or maybe pos instead)

> +	ssize_t ret_cnt;
> +
> +	buf_len = 1000 + ENDPOINT_MAX * 100;

It seems odd to start with size using 1000

There's ENDPOINT_MAX rows (9)
Each row contains:
	up to 20 byte row name
	20 counters * up to 10 bytes per counter
up to 220 bytes per row

Perhaps this?
	const size_t buf_len = ENDPOINT_MAX * (20 + sizeof(struct htc_endpoint_stats) / sizeof(u32) * 10);

> +	buf = kzalloc(buf_len, GFP_KERNEL);

kzalloc doesn't seem necessary,
everything is overwritten.  just kmalloc?

As is, it's (barely) possible to overflow
the buffer length and end up non-null terminated.
Perhaps that doesn't matter.

> +	if (!buf)
> +		return -ENOMEM;
> +
> +#define EPSTAT(name)							\
> +	len = print_endpoint_stat(target, buf, buf_len, len,		\
> +				  offsetof(struct htc_endpoint_stats, name), \
> +				  #name)

perhaps

#define EPSTAT(name)							\
	len = endpoint_stat(target, buf, buf_len, len,			\
			    offsetof(struct htc_endpoint_stats, name) / sizeof(u32), \
			    #name)

 
> +	EPSTAT(cred_low_indicate);
> +	EPSTAT(tx_issued);
> +	EPSTAT(tx_pkt_bundled);
> +	EPSTAT(tx_bundles);
> +	EPSTAT(tx_dropped);
> +	EPSTAT(tx_cred_rpt);
> +	EPSTAT(cred_rpt_from_rx);
> +	EPSTAT(cred_rpt_ep0);
> +	EPSTAT(cred_from_rx);
> +	EPSTAT(cred_from_other);
> +	EPSTAT(cred_from_ep0);
> +	EPSTAT(cred_cosumd);
> +	EPSTAT(cred_retnd);
> +	EPSTAT(rx_pkts);
> +	EPSTAT(rx_lkahds);
> +	EPSTAT(rx_bundl);
> +	EPSTAT(rx_bundle_lkahd);
> +	EPSTAT(rx_bundle_from_hdr);
> +	EPSTAT(rx_alloc_thresh_hit);
> +	EPSTAT(rxalloc_thresh_byte);
> +#undef EPSTAT
> +
> +	if (len > buf_len)
> +		len = buf_len;

Maybe it's better to ensure 0 termination?
	if (len > buf_len) {
		len = buf_len;
		buf[buf_len - 1] = 0;
	}

> +	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +	kfree(buf);
> +	return ret_cnt;
> +}


