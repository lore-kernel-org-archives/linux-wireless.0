Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31216 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDTVrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:47:42 -0400
Subject: Re: [PATCH 08/11] iwl3945: use cancel_delayed_work_sync to cancel
 rfkill_poll
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1240263424-8495-9-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-8-git-send-email-reinette.chatre@intel.com>
	 <1240263424-8495-9-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 14:53:45 -0700
Message-Id: <1240264425.5206.112.camel@rc-desk> (sfid-20090420_234745_440966_05302A9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Could you please submit this patch to 2.6.30 also?

Thank you

Reinette


On Mon, 2009-04-20 at 14:37 -0700, Chatre, Reinette wrote:
> Users reported lockup with work still trying to run
> after module has been unloaded.
> 
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/30594/focus=30601
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reported-by: TJ <ubuntu@tjworld.net>
> Reported-by: Huaxu Wan <huaxu.wan@linux.intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index e22282e..a776326 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -4436,7 +4436,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
>  	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
>  
>  	iwl_rfkill_unregister(priv);
> -	cancel_delayed_work(&priv->rfkill_poll);
> +	cancel_delayed_work_sync(&priv->rfkill_poll);
>  
>  	iwl3945_dealloc_ucode_pci(priv);
>  

