Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62053 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab2DXVFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 17:05:12 -0400
Date: Tue, 24 Apr 2012 17:05:05 -0400
From: Pavel Roskin <proski@gnu.org>
To: Jonathan Bither <jonbither@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ath5k: add missing iounmap to AHB probe removal
Message-ID: <20120424170505.51687253@mj> (sfid-20120424_230518_179461_B614AD00)
In-Reply-To: <4F96704F.8050406@gmail.com>
References: <4F96704F.8050406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 Apr 2012 05:20:15 -0400
Jonathan Bither <jonbither@gmail.com> wrote:

> When our driver device is removed on the AHB bus, our IO memory is
> never unmapped.
> 
> Signed-off-by: Jonathan Bither <jonbither@gmail.com>
> 
> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c
> b/drivers/net/wireless/ath/ath5k/ahb.c index 8c50d9d..aec33cc 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -220,6 +220,7 @@ static int ath_ahb_remove(struct platform_device
> *pdev) }
>  
>  	ath5k_deinit_ah(ah);
> +	iounmap(ah->iobase);
>  	platform_set_drvdata(pdev, NULL);
>  	ieee80211_free_hw(hw);

Reviewed-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
