Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbbEGM1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:27:25 -0400
Message-ID: <1431001635.11214.2.camel@sipsolutions.net> (sfid-20150507_142738_825528_6F540882)
Subject: Re: [patch] iwlwifi: mvm: remove some dead code
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Arik Nemtsov <arik@wizery.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 07 May 2015 14:27:15 +0200
In-Reply-To: <20150507095844.GA17996@mwanda> (sfid-20150507_115917_046200_420B91D7)
References: <20150507095844.GA17996@mwanda>
	 (sfid-20150507_115917_046200_420B91D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-07 at 12:58 +0300, Dan Carpenter wrote:
> "ret" is zero here so we can remove this stray check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
> index df86963..41f4763 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
> @@ -663,8 +663,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
>  		 */
>  		_iwl_trans_stop_device(mvm->trans, false);
>  		_iwl_trans_start_hw(mvm->trans, false);
> -		if (ret)
> -			return ret;

It looks like "ret = _iwl_trans_start_hw(...)" was intended though?

johannes

