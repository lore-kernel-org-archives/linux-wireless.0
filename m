Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36226 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbbL1XG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 18:06:27 -0500
Received: by mail-pa0-f41.google.com with SMTP id yy13so23256672pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2015 15:06:26 -0800 (PST)
Date: Mon, 28 Dec 2015 15:06:35 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>, fengwei.yin@linaro.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	wcn36xx@lists.infradead.org
Subject: Re: [PATCH 2/4] wcn36xx: Change indication list lock to spinlock
Message-ID: <20151228150635.79181f6e@xeon-e3> (sfid-20151229_000645_751746_8E2BD2C5)
In-Reply-To: <1451266467-15377-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1451266467-15377-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1451266467-15377-3-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Dec 2015 17:34:25 -0800
Bjorn Andersson <bjorn@kryo.se> wrote:

> In preparation for handling incoming messages from IRQ context, change
> the indication list lock to a spinlock
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c     | 12 ++++++------
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 6b5dbe6f0d0a..4307429740a9 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2165,10 +2165,10 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
>  		msg_ind->msg_len = len;
>  		memcpy(msg_ind->msg, buf, len);
>  
> -		mutex_lock(&wcn->hal_ind_mutex);
> +		spin_lock(&wcn->hal_ind_lock);

If you are going to handle messages in IRQ context, that better be a spin_lock_irq() or spin_lock_bh().
