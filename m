Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35405 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753974AbcJDVEj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 17:04:39 -0400
Received: by mail-pf0-f176.google.com with SMTP id s13so79562648pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 14:04:39 -0700 (PDT)
Date: Tue, 4 Oct 2016 14:04:36 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 2/2] mwifiex: check hw_status in suspend and resume
 handlers
Message-ID: <20161004210435.GA31652@localhost> (sfid-20161004_230443_479355_460A2478)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <1475600905-2997-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475600905-2997-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 04, 2016 at 10:38:25PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> We have observed a kernel crash when system immediately suspends
> after booting. There is a race between suspend and driver
> initialization paths.
> This patch adds hw_status checks to fix the problem
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: Return failure in suspend/resume handler in this scenario.
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index ba9e068..fa6bf85 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -122,9 +122,10 @@ static int mwifiex_pcie_suspend(struct device *dev)
>  
>  	if (pdev) {
>  		card = pci_get_drvdata(pdev);
> -		if (!card || !card->adapter) {
> +		if (!card || !card->adapter ||
> +		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {

Wait, is there no locking on the 'hw_status' field? That is inherently
an unsafe race all on its own; you're not guaranteed that this will be
read/written atomically. And you also aren't guaranteed that writes to
this happen in the order they appear in the code -- in other words,
reading this flag doesn't necessarily guarantee that initialization is
actually complete (even if that's very likely to be true, given that
it's probably just a single-instruction word-access, and any prior HW
polling or interrupts likely have done some synchronization and can't be
reordered).

This is probably better than nothing, but it's not very good.

>  			pr_err("Card or adapter structure is not valid\n");
> -			return 0;
> +			return -EBUSY;

So the above cases all mean that the driver hasn't finished loading,
right?

!card => can't happen (PCIe probe() would have failed
mwifiex_add_card()), but fine to check

!card->adapter => only happens after patch 1; i.e., when tearing down
the device and detaching it from the driver

card->adapter->hw_status != MWIFIEX_HW_STATUS_READY => FW is not loaded
(i.e., in the process of starting or stopping FW?)

I guess all of those cases make sense to be -EBUSY.

>  		}
>  	} else {
>  		pr_err("PCIE device is not specified\n");

I was going to complain about this branch (!pdev) returning 0, since
that looked asymmetric. But this case will never happen, actually, since
to_pci_dev() is just doing struct offset arithmetic on struct device,
and struct device is never going to be NULL. It probably makes more
sense to just remove this branch entirely, but that's for another patch.

> @@ -166,9 +167,10 @@ static int mwifiex_pcie_resume(struct device *dev)
>  
>  	if (pdev) {
>  		card = pci_get_drvdata(pdev);
> -		if (!card || !card->adapter) {
> +		if (!card || !card->adapter ||
> +		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {

Same complaint, except if you've screwed up here, you probably already
screwed up in suspend().

Brian

>  			pr_err("Card or adapter structure is not valid\n");
> -			return 0;
> +			return -EBUSY;
>  		}
>  	} else {
>  		pr_err("PCIE device is not specified\n");
> -- 
> 1.9.1
> 
