Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1127 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaE0OVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:21:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add implementation for configure max amsdu, ampdu
References: <1400245332-6974-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 27 May 2014 17:20:55 +0300
In-Reply-To: <1400245332-6974-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 16 May 2014 15:02:12 +0200")
Message-ID: <87zji39ubc.fsf@kamboji.qca.qualcomm.com> (sfid-20140527_162208_422823_265B3C8D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Allow to setup maximum subframes for AMSDU and AMPDU aggregation,
> using debugfs htt_max_amsdu_ampdu file.
>
> Eg.
> echo "2 64" > htt_max_amsdu_ampdu
> will setup maximum amsdu subframes equal 2 and
> maximum ampdu subframes equal to 64.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

I saw two new warnings:

drivers/net/wireless/ath/ath10k/debug.c:683: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/debug.c:685: WARNING: line over 80 characters

> I wasn't sure we have to protect
> debug.htt_max_amsdu, debug.htt_max_ampdu using conf_mutex.
> Anyway I can add such protection if required.

Yeah, we need to protect those variables.

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -671,6 +671,61 @@ static const struct file_operations fops_htt_stats_mask = {
>  	.llseek = default_llseek,
>  };
>  
> +static ssize_t ath10k_read_htt_max_amsdu_ampdu(struct file *file,
> +					       char __user *user_buf,
> +					       size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	char buf[64];
> +	unsigned int len;
> +
> +	if (!ar->debug.htt_max_amsdu || !ar->debug.htt_max_ampdu)
> +		len = scnprintf(buf, sizeof(buf), "using FW default max subframes configuration: amsdu 3, ampdu 64\n");
> +	else
> +		len = scnprintf(buf, sizeof(buf), "max subframes amsdu %u, ampdu %d\n",
> +				ar->debug.htt_max_amsdu,
> +				ar->debug.htt_max_ampdu);
> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +}

I would prefer to have something more machine readable, for example
something like this:

if (ar->debug.htt_max_amsdu != 0) {
        amsdu = ar->debug.htt_max_amsdu;
} else {
        amsdu = 3;
        amsdu_default = " (default)";
}

len += scnprintf(buf + len, sizeof(buf) - len, 
                "max subframes amsdu %u%s\n", amsdu, amsdu_default);

And the same for ampdu. But I'm not actually sure if it makes any sense
to print the default at all?

Now I think more maybe we should just use the same format as we use as
input ("%u %u"). That would follow the KISS principle.

> @@ -757,6 +812,9 @@ void ath10k_debug_stop(struct ath10k *ar)
>  	 * warning from del_timer(). */
>  	if (ar->debug.htt_stats_mask != 0)
>  		cancel_delayed_work(&ar->debug.htt_stats_dwork);
> +
> +	ar->debug.htt_max_amsdu = 0;
> +	ar->debug.htt_max_ampdu = 0;
>  }

This is correct. But the problem now is that the value only is valid
until the interface is put down or firmware crashes. That's a bit
confusing for the user, but I guess we can fix that later if that will
become a problem. Users should not use this command normally.

> +int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
> +				u8 max_subfrms_ampdu,
> +				u8 max_subfrms_amsdu)
> +{
> +	struct htt_aggr_conf *aggr_conf;
> +	struct sk_buff *skb;
> +	struct htt_cmd *cmd;
> +	int len;
> +	int ret;
> +
> +	/* By default FW setup amsdu = 3 and ampdu = 64 */
> +	if (max_subfrms_ampdu == 0 || max_subfrms_ampdu > 64)
> +		return -EINVAL;

I didn't immediately understand the comment above. Is it just to
document what are the firmware defaults? In that case please add an
empty line after the comment and clear up the wording. For example,
"Firmware defaults are: amsdu = 3 and ampdu = 64 */".

> +
> +	if (max_subfrms_amsdu == 0 || max_subfrms_amsdu > 31)
> +		return -EINVAL;
> +
> +	len = sizeof(cmd->hdr);
> +	len += sizeof(cmd->aggr_conf);
> +
> +	skb = ath10k_htc_alloc_skb(len);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_put(skb, len);
> +	cmd = (struct htt_cmd *)skb->data;
> +	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_AGGR_CFG;
> +
> +	aggr_conf = &cmd->aggr_conf;
> +	aggr_conf->max_num_ampdu_subframes = max_subfrms_ampdu;
> +	aggr_conf->max_num_amsdu_subframes = max_subfrms_amsdu;
> +
> +	ath10k_dbg(ATH10K_DBG_HTT, "htt h2t aggr cfg msg amsdu %d, ampdu %d",
> +		   aggr_conf->max_num_amsdu_subframes,
> +		   aggr_conf->max_num_ampdu_subframes);

No comma in the debug message, please.

-- 
Kalle Valo
