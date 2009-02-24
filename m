Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZBXFCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 00:02:54 -0500
Subject: Re: [PATCH] iwl3945: initialize is_valid_rtc_data_addr function
	pointer
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1235443410.7047.25.camel@rainbow>
References: <1235443410.7047.25.camel@rainbow>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:07:28 -0800
Message-Id: <1235452048.23783.9.camel@rc-desk> (sfid-20090224_060257_889538_DB9DAF5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-02-23 at 18:43 -0800, Jason Andryuk wrote:
> Initialize is_valid_rtc_data_addr function pointer for iwl3945 to
> prevent a NULL pointer dereference in iwl_dump_nic_error_log.
> 
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> --
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index d49e48b..6ae0df5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -2747,6 +2747,7 @@ static struct iwl_lib_ops iwl3945_lib = {
>  		.query_addr = iwlcore_eeprom_query_addr,
>  	},
>  	.send_tx_power	= iwl3945_send_tx_power,
> +	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
>  };
>  
>  static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
> 

Thank you very much

Acked-by: Reinette Chatre <reinette.chatre@intel.com>


Reinette


