Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753851AbcL3Lck (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:32:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: adm80211: return an error if adm8211_alloc_rings() fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161207112122.GA5686@elgon.mountain>
References: <20161207112122.GA5686@elgon.mountain>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20161230113239.94B11614C2@smtp.codeaurora.org> (sfid-20161230_123305_350273_B4059264)
Date: Fri, 30 Dec 2016 11:32:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We accidentally return success when adm8211_alloc_rings() fails but we
> should preserve the error code.
> 
> Fixes: cc0b88cf5ecf ("[PATCH] Add adm8211 802.11b wireless driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
> index 2b4a3eb38dfa..098c814e22c8 100644
> --- a/drivers/net/wireless/admtek/adm8211.c
> +++ b/drivers/net/wireless/admtek/adm8211.c
> @@ -1863,7 +1863,8 @@ static int adm8211_probe(struct pci_dev *pdev,
>  	priv->rx_ring_size = rx_ring_size;
>  	priv->tx_ring_size = tx_ring_size;
>  
> -	if (adm8211_alloc_rings(dev)) {
> +	err = adm8211_alloc_rings(dev);
> +	if (err) {
>  		printk(KERN_ERR "%s (adm8211): Cannot allocate TX/RX ring\n",
>  		       pci_name(pdev));
>  		goto err_iounmap;

Patch applied to wireless-drivers-next.git, thanks.

c705a6b3aa78 adm80211: return an error if adm8211_alloc_rings() fails

-- 
https://patchwork.kernel.org/patch/9464449/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
