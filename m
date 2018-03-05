Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:35207 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeCEXLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 18:11:52 -0500
Received: by mail-pl0-f66.google.com with SMTP id bb3-v6so10692861plb.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 15:11:52 -0800 (PST)
Date: Mon, 5 Mar 2018 15:11:49 -0800
From: Brian Norris <briannorris@chromium.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] ath10k: fix use-after-free in
 ath10k_wmi_cmd_send_nowait
Message-ID: <20180305231147.GA144261@rodete-desktop-imager.corp.google.com> (sfid-20180306_001207_064258_CEC5444F)
References: <1520232242-24132-1-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520232242-24132-1-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Felix, who had feedback on the last version

On Mon, Mar 05, 2018 at 02:44:02PM +0800, Carl Huang wrote:
> The skb may be freed in tx completion context before
> trace_ath10k_wmi_cmd is called. This can be easily captured when
> KASAN(Kernel Address Sanitizer) is enabled. The fix is to move
> trace_ath10k_wmi_cmd before the send operation. As the ret has no
> meaning in trace_ath10k_wmi_cmd then, so remove this parameter too.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/trace.h | 12 ++++--------
>  drivers/net/wireless/ath/ath10k/wmi.c   |  2 +-
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
> index e40edce..7d2fac3 100644
> --- a/drivers/net/wireless/ath/ath10k/trace.h
> +++ b/drivers/net/wireless/ath/ath10k/trace.h
> @@ -152,10 +152,9 @@ TRACE_EVENT(ath10k_log_dbg_dump,
>  );
>  
>  TRACE_EVENT(ath10k_wmi_cmd,
> -	TP_PROTO(struct ath10k *ar, int id, const void *buf, size_t buf_len,
> -		 int ret),
> +	TP_PROTO(struct ath10k *ar, int id, const void *buf, size_t buf_len),
>  
> -	TP_ARGS(ar, id, buf, buf_len, ret),
> +	TP_ARGS(ar, id, buf, buf_len),
>  
>  	TP_STRUCT__entry(
>  		__string(device, dev_name(ar->dev))
> @@ -163,7 +162,6 @@ TRACE_EVENT(ath10k_wmi_cmd,
>  		__field(unsigned int, id)
>  		__field(size_t, buf_len)
>  		__dynamic_array(u8, buf, buf_len)
> -		__field(int, ret)
>  	),
>  
>  	TP_fast_assign(
> @@ -171,17 +169,15 @@ TRACE_EVENT(ath10k_wmi_cmd,
>  		__assign_str(driver, dev_driver_string(ar->dev));
>  		__entry->id = id;
>  		__entry->buf_len = buf_len;
> -		__entry->ret = ret;
>  		memcpy(__get_dynamic_array(buf), buf, buf_len);
>  	),
>  
>  	TP_printk(
> -		"%s %s id %d len %zu ret %d",
> +		"%s %s id %d len %zu",
>  		__get_str(driver),
>  		__get_str(device),
>  		__entry->id,
> -		__entry->buf_len,
> -		__entry->ret
> +		__entry->buf_len
>  	)
>  );
>  
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 58dc218..fc9f50d 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1742,8 +1742,8 @@ int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
>  	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
>  
>  	memset(skb_cb, 0, sizeof(*skb_cb));
> +	trace_ath10k_wmi_cmd(ar, cmd_id, skb->data, skb->len);
>  	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
> -	trace_ath10k_wmi_cmd(ar, cmd_id, skb->data, skb->len, ret);
>  
>  	if (ret)
>  		goto err_pull;

Tested-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
