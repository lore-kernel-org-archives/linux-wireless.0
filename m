Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54102 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbeIDKb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 06:31:28 -0400
Message-ID: <78daed5d33990c816c7e947173a1ca12eaa27efb.camel@intel.com> (sfid-20180904_080835_462509_AFE2ED1D)
Subject: Re: [PATCH] iwlwifi: pcie: make array 'prop' static, shrinks object
 size
From: Luciano Coelho <luciano.coelho@intel.com>
To: Colin King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2018 09:07:47 +0300
In-Reply-To: <20180821102109.1630-1-colin.king@canonical.com>
References: <20180821102109.1630-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 11:21 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array prop on the stack but instead make it static.
> Makes the object code smaller by 30 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   80138	  15382	    576	  96096	  17760	drivers/net/wireless/intel/iwlwifi/pcie/trans.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   79948	  15542	    576	  96066	  17742	drivers/net/wireless/intel/iwlwifi/pcie/trans.o
> 
> (gcc version 8.2.0 x86_64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index 7d319b6863fe..c7daf666ee21 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -1947,7 +1947,7 @@ static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
>  	struct iwl_trans_pcie_removal *removal =
>  		container_of(wk, struct iwl_trans_pcie_removal, work);
>  	struct pci_dev *pdev = removal->pdev;
> -	char *prop[] = {"EVENT=INACCESSIBLE", NULL};
> +	static char *prop[] = {"EVENT=INACCESSIBLE", NULL};
>  
>  	dev_err(&pdev->dev, "Device gone - attempting removal\n");
>  	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, prop);

Thanks! I pushed this to our internal tree and it will reach upstream
following our normal process.

--
Luca.
