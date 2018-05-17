Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeEQShg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 14:37:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 17 May 2018 11:37:35 -0700
From: Jeff Johnson <jjohnson@codeaurora.org>
To: Ramon Fried <ramon.fried@linaro.org>
Cc: kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Eyal Ilsar <eilsar@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: Add support for Factory Test Mode (FTM)
In-Reply-To: <20180517113250.16517-1-ramon.fried@linaro.org>
References: <20180517113250.16517-1-ramon.fried@linaro.org>
Message-ID: <58c8d2d16995e80f5527370e224045e2@codeaurora.org> (sfid-20180517_203749_842077_25C42129)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-17 04:32, Ramon Fried wrote:
> From: Eyal Ilsar <eilsar@codeaurora.org>
...
> +int wcn36xx_smd_process_ptt_msg(struct wcn36xx *wcn,
> +				struct ieee80211_vif *vif, void *ptt_msg, size_t len,
> +		void **ptt_rsp_msg)
> +{
> +	struct wcn36xx_hal_process_ptt_msg_req_msg *p_msg_body;
> +	int ret = 0;
> +
> +	mutex_lock(&wcn->hal_mutex);
> +	p_msg_body = kmalloc(
> +		sizeof(struct wcn36xx_hal_process_ptt_msg_req_msg) + len,
> +		GFP_ATOMIC);

NULL check required?

> +	INIT_HAL_PTT_MSG(p_msg_body, len);
> +
