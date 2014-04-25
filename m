Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33971 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaDYBpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 21:45:17 -0400
Date: Thu, 24 Apr 2014 21:40:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: fix adapter pointer dereference
Message-ID: <20140425014022.GB3410@tuxdriver.com> (sfid-20140425_034616_014415_0875FB0B)
References: <1398289253-21398-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1398289253-21398-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I reverted the patch in question already.  If you rewrite it, please
be sure to account for this fix as appropriate.

Thanks,

John

On Wed, Apr 23, 2014 at 02:40:53PM -0700, Bing Zhao wrote:
> drivers/net/wireless/mwifiex/pcie.c:2252 mwifiex_pcie_fw_dump_work()
> error: we previously assumed 'adapter' could be null (see line 2251)
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index 51989b3..249fdbd 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -2248,7 +2248,7 @@ static void mwifiex_pcie_fw_dump_work(struct work_struct *work)
>  	};
>  
>  	if (!adapter) {
> -		dev_err(adapter->dev, "Could not dump firmwware info\n");
> +		pr_err("adapter is null. Could not dump firmware info\n");
>  		return;
>  	}
>  
> -- 
> 1.8.2.3
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
