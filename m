Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34418 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbcJDWYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 18:24:25 -0400
Received: by mail-pf0-f181.google.com with SMTP id e6so24318972pfk.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 15:24:25 -0700 (PDT)
Date: Tue, 4 Oct 2016 15:24:22 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [2/8] mwifiex: report error to PCIe for suspend failure
Message-ID: <20161004222422.GB4646@localhost> (sfid-20161005_002428_474976_DD38BE93)
References: <1475066908-11771-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475066908-11771-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 28, 2016 at 06:18:22PM +0530, Amitkumar Karwar wrote:
> When host_sleep_config command fails, we should return an error to
> PCIe, instead of continuing (and possibly panicking, when we try to keep
> processing a timed-out ioctl after we return "successfully" from
> suspend).
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

In case it helps to note this: this is what's already done in sdio.c,
and adding this patch prevented some crashes on my system with pcie.c.

Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>

You might want to fixup usb.c to do the same.

> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 2833d47..063c707 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -101,7 +101,6 @@ static int mwifiex_pcie_suspend(struct device *dev)
>  {
>  	struct mwifiex_adapter *adapter;
>  	struct pcie_service_card *card;
> -	int hs_actived;
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	if (pdev) {
> @@ -117,7 +116,14 @@ static int mwifiex_pcie_suspend(struct device *dev)
>  
>  	adapter = card->adapter;
>  
> -	hs_actived = mwifiex_enable_hs(adapter);
> +	/* Enable the Host Sleep */
> +	if (!mwifiex_enable_hs(adapter)) {
> +		mwifiex_dbg(adapter, ERROR,
> +			    "cmd: failed to suspend\n");
> +		adapter->hs_enabling = false;
> +		return -EFAULT;
> +	}
> +
>  	flush_workqueue(adapter->workqueue);
>  
>  	/* Indicate device suspended */
