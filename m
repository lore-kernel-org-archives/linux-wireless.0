Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbeEQSfq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 14:35:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 17 May 2018 11:35:44 -0700
From: Jeff Johnson <jjohnson@codeaurora.org>
To: Ramon Fried <ramon.fried@linaro.org>
Cc: kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Eyal Ilsar <eilsar@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: Add support for Factory Test Mode (FTM)
In-Reply-To: <20180517113250.16517-1-ramon.fried@linaro.org>
References: <20180517113250.16517-1-ramon.fried@linaro.org>
Message-ID: <b4a96b0e326cd45928f97d6e5796c748@codeaurora.org> (sfid-20180517_203602_640231_27360BEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-17 04:32, Ramon Fried wrote:
> From: Eyal Ilsar <eilsar@codeaurora.org>
...
> +static int wcn36xx_smd_process_ptt_msg_rsp(void *buf, size_t len,
> +					   void **p_ptt_rsp_msg)
> +{
> +	struct wcn36xx_hal_process_ptt_msg_rsp_msg *rsp;
> +	int ret = 0;

why initialize 'ret' when you immediately overwrite?

> +	ret = wcn36xx_smd_rsp_status_check(buf, len);
...
> +	if (rsp->header.len > 0) {
> +		*p_ptt_rsp_msg = kmalloc(rsp->header.len, GFP_ATOMIC);

NULL check required?

> +		memcpy(*p_ptt_rsp_msg, rsp->ptt_msg, rsp->header.len);
> +	}
> +	return ret;
> +}
> +
> +int wcn36xx_smd_process_ptt_msg(struct wcn36xx *wcn,
> +				struct ieee80211_vif *vif, void *ptt_msg, size_t len,
> +		void **ptt_rsp_msg)
> +{
> +	struct wcn36xx_hal_process_ptt_msg_req_msg *p_msg_body;
> +	int ret = 0;

why initialize 'ret' when it is always overwritten before use?

> +	ret = wcn36xx_smd_send_and_wait(wcn, p_msg_body->header.len);
