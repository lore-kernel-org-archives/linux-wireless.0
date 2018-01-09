Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40264 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeAIIfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 03:35:39 -0500
Date: Tue, 9 Jan 2018 09:35:41 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Larry.Finger@lwfinger.net, kvalo@codeaurora.org,
        kstewart@linuxfoundation.org, johannes.berg@intel.com,
        tiwai@suse.de, colin.king@canonical.com,
        andrew.zaborowski@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        b43-dev@lists.infradead.org
Subject: Re: [PATCH v2] b43: Replace mdelay with usleep_range in
 b43_radio_2057_init_post
Message-ID: <20180109083541.GA13460@kroah.com> (sfid-20180109_093652_061939_16750297)
References: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 09, 2018 at 09:40:06AM +0800, Jia-Ju Bai wrote:
> b43_radio_2057_init_post is not called in an interrupt handler
> nor holding a spinlock.
> The function mdelay in it can be replaced with usleep_range, 
> to reduce busy wait.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
> v2:
> * Replace mdelay with usleep_range, instead of msleep in v1.
>   Thank Larry for good advice.
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index a5557d7..f2a2f41 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -1031,7 +1031,7 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
>  
>  	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x78);
>  	b43_radio_set(dev, R2057_XTAL_CONFIG2, 0x80);
> -	mdelay(2);
> +	usleep_range(2000, 3000);

Where did 3000 come from?  Are you sure about that?

thanks,

greg k-h
