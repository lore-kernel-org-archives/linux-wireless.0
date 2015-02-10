Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54215 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbbBJNRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 08:17:15 -0500
Message-ID: <1423574228.28434.22.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150210_141747_087340_21D0A4DC)
Subject: Re: [PATCH] rtlwifi: ratelimit skb allocation failure message
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Colin King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2015 05:17:08 -0800
In-Reply-To: <1423558471-27278-1-git-send-email-colin.king@canonical.com>
References: <1423558471-27278-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-10 at 08:54 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> when running low on memory I noticed rtlwifi was producing a large
> quantity of repeated skb allocation failures messages.  This should
> be ratelimited to reduce the noise.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/rtlwifi/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index c70efb9..ca0fd50 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -817,7 +817,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>  		/* get a new skb - if fail, old one will be reused */
>  		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
>  		if (unlikely(!new_skb)) {
> -			pr_err("Allocation of new skb failed in %s\n",
> +			pr_err_ratelimited("Allocation of new skb failed in %s\n",
>  			       __func__);

Or even better, remove the message.


