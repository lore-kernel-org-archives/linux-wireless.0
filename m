Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:44207 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163530AbeCAX5D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 18:57:03 -0500
Received: by mail-io0-f195.google.com with SMTP id h23so9018440iob.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 15:57:03 -0800 (PST)
Date: Thu, 1 Mar 2018 15:56:59 -0800
From: Brian Norris <briannorris@chromium.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait
Message-ID: <20180301235655.GA127455@rodete-desktop-imager.corp.google.com> (sfid-20180302_005707_733273_20DDB5C7)
References: <1518317805-5796-1-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518317805-5796-1-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 11, 2018 at 10:56:45AM +0800, Carl Huang wrote:
> The skb may be freed in tx completion context before
> trace_ath10k_wmi_cmd is called. This can be easily captured
> when KASAN(Kernel Address Sanitizer) is enabled. The fix is
> to add a reference count to the skb and release it after
> trace_ath10k_wmi_cmd is called.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 58dc218..e63aedb 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1,6 +1,7 @@
>  /*
>   * Copyright (c) 2005-2011 Atheros Communications Inc.
>   * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
> + * Copyright (c) 2018, The Linux Foundation. All rights reserved.

I agree with Felix that this seems excessive for a 2-line bugfix. But
I'm not a lawyer or a maintainer, and I have no power here :)

(On the practical side: it's annoying that the copyright line has to be
the one to provide conflicts when backporting.)

>   *
>   * Permission to use, copy, modify, and/or distribute this software for any
>   * purpose with or without fee is hereby granted, provided that the above
> @@ -1742,8 +1743,10 @@ int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
>  	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
>  
>  	memset(skb_cb, 0, sizeof(*skb_cb));
> +	skb_get(skb);
>  	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
>  	trace_ath10k_wmi_cmd(ar, cmd_id, skb->data, skb->len, ret);
> +	dev_kfree_skb(skb);

Tested-by: Brian Norris <briannorris@chromium.org>

It does feel like capturing before the command is sent might make more
sense. Otherwise, you may be concurrently dumping the buffer and DMA'ing
to a device. If you really need to trace the return code, you could do
that separately.

Brian

>  
>  	if (ret)
>  		goto err_pull;
