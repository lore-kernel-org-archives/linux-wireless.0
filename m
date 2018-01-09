Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:36366 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759765AbeAIQuA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 11:50:00 -0500
Subject: Re: [PATCH v2] b43: Replace mdelay with usleep_range in
 b43_radio_2057_init_post
To: Jia-Ju Bai <baijiaju1990@gmail.com>, kvalo@codeaurora.org,
        kstewart@linuxfoundation.org, johannes.berg@intel.com,
        tiwai@suse.de, gregkh@linuxfoundation.org,
        colin.king@canonical.com, andrew.zaborowski@intel.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org
References: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <05e5756d-e401-5584-f809-e3ad42db2a66@lwfinger.net> (sfid-20180109_175023_719185_A5FE8C6B)
Date: Tue, 9 Jan 2018 10:49:58 -0600
MIME-Version: 1.0
In-Reply-To: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2018 07:40 PM, Jia-Ju Bai wrote:
> b43_radio_2057_init_post is not called in an interrupt handler
> nor holding a spinlock.
> The function mdelay in it can be replaced with usleep_range,
> to reduce busy wait.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
> v2:
> * Replace mdelay with usleep_range, instead of msleep in v1.
>    Thank Larry for good advice.
> ---

I agree that a sleep of 2-3 ms should be OK here.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>   drivers/net/wireless/broadcom/b43/phy_n.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index a5557d7..f2a2f41 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -1031,7 +1031,7 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
>   
>   	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x78);
>   	b43_radio_set(dev, R2057_XTAL_CONFIG2, 0x80);
> -	mdelay(2);
> +	usleep_range(2000, 3000);
>   	b43_radio_mask(dev, R2057_RFPLL_MISC_CAL_RESETN, ~0x78);
>   	b43_radio_mask(dev, R2057_XTAL_CONFIG2, ~0x80);
>   
> 
