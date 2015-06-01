Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35186 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbFAJeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 05:34:12 -0400
Received: by wgme6 with SMTP id e6so108928208wgm.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 02:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433150613-5662-1-git-send-email-rmani@qti.qualcomm.com>
References: <1433150613-5662-1-git-send-email-rmani@qti.qualcomm.com>
Date: Mon, 1 Jun 2015 11:34:11 +0200
Message-ID: <CA+BoTQk+gRKdue26G1-Q=qsxf4y1Q5YJffSrPsUgYX8oMfMF=A@mail.gmail.com> (sfid-20150601_113416_128480_51776D71)
Subject: Re: [PATCH] ath10k: free wmi mgmt event skb when parsing fails
From: Michal Kazior <michal.kazior@tieto.com>
To: Raja Mani <rmani@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 June 2015 at 11:23, Raja Mani <rmani@qti.qualcomm.com> wrote:
> When wmi mgmt event function fails to parse given skb,
> it should be freed on failure condition to avoid memory
> leaks. Found this during the code review.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index b892eb8..818bd25 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2089,6 +2089,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
>         ret = ath10k_wmi_pull_mgmt_rx(ar, skb, &arg);
>         if (ret) {
>                 ath10k_warn(ar, "failed to parse mgmt rx event: %d\n", ret);
> +               dev_kfree_skb(skb);
>                 return ret;
>         }

Good catch! Looks good to me.


Michał
