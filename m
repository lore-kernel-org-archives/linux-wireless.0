Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18485 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934958AbeEINmu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:42:50 -0400
Subject: Re: [PATCH 28/30] staging: wilc1000: added comments for mutex and
 spinlock_t
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-29-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <8b5bc683-13d9-1d3e-ab16-e37e2d62acfd@microchip.com> (sfid-20180509_154254_943482_DA6F2EC3)
Date: Wed, 9 May 2018 16:42:32 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-29-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Added comments for mutex and spinlock_t to avoid checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.h     | 2 +-
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
> index 7a26f34..5e00dde 100644
> --- a/drivers/staging/wilc1000/host_interface.h
> +++ b/drivers/staging/wilc1000/host_interface.h
> @@ -271,7 +271,7 @@ struct host_if_drv {
>  
>  	u8 assoc_bssid[ETH_ALEN];
>  	struct cfg_param_attr cfg_values;
> -
> +/*lock to protect concurrent setting of cfg params*/
>  	struct mutex cfg_values_lock;
>  	struct completion comp_test_key_block;
>  	struct completion comp_test_disconn_block;
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index 607dae0..e517768 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -131,10 +131,11 @@ struct wilc {
>  	u8 vif_num;
>  	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
>  	u8 open_ifcs;
> -
> +/*protect head of transmit queue*/

Add an extra tag to align it with the rest of the structure's members. 

>  	struct mutex txq_add_to_head_cs;
> +/*protect txq_entry_t transmit queue*/
Ditto

>  	spinlock_t txq_spinlock;
> -
> +/*protect rxq_entry_t receiver queue*/

Ditto

>  	struct mutex rxq_cs;
>  	struct mutex hif_cs;
>  
> 
