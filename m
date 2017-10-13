Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758380AbdJMMtT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 08:49:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: debug: Simplify error checking
References: <1507498152-4058-1-git-send-email-chris.gekas@gmail.com>
Date: Fri, 13 Oct 2017 15:49:15 +0300
In-Reply-To: <1507498152-4058-1-git-send-email-chris.gekas@gmail.com>
        (Christos Gkekas's message of "Sun, 8 Oct 2017 22:29:12 +0100")
Message-ID: <87infjw6us.fsf@purkki.adurom.net> (sfid-20171013_144942_324597_B5AA5E46)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christos Gkekas <chris.gekas@gmail.com> writes:

> Variable val is unsigned so checking whether it is less than zero is
> redundant.
>
> Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/debug.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 01fa301..3b93c23 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -1164,10 +1164,7 @@ static ssize_t write_file_tpc(struct file *file, const char __user *user_buf,
>  		return -EFAULT;
>  
>  	buf[len] = '\0';
> -	if (kstrtoul(buf, 0, &val))
> -		return -EINVAL;
> -
> -	if (val < 0 || val > 1)
> +	if (kstrtoul(buf, 0, &val) || val > 1)
>  		return -EINVAL;

Same as with the ath10k patch, please keep the two if statements
separate.

-- 
Kalle Valo
