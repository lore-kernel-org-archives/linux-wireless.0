Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33132 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbcBKGhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 01:37:13 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Anton Protopopov <a.s.protopopov@gmail.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Eran Harary <eran.harary@intel.com>
CC: linuxwifi <linuxwifi@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: fix erroneous return value
Date: Thu, 11 Feb 2016 06:36:33 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA0DC45@hasmsx107.ger.corp.intel.com> (sfid-20160211_073830_253191_CEA80D30)
References: <1455124113-27024-1-git-send-email-a.s.protopopov@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/10/2016 07:10 PM, Anton Protopopov wrote:
> The iwl_trans_pcie_start_fw() function may return the positive value EIO
> instead of -EIO in case of error.
>
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index d60a467..920ea9d 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -1034,7 +1034,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>  	if (trans_pcie->is_down) {
>  		IWL_WARN(trans,
>  			 "Can't start_fw since the HW hasn't been started\n");
> -		ret = EIO;
> +		ret = -EIO;
>  		goto out;
>  	}
>  

applied - thanks.
