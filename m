Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33197 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbHVRZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 13:25:53 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"Eliad Peller" <eliad@wizery.com>,
	"Kaufman, Liad" <liad.kaufman@intel.com>,
	"Gottlieb, Matti" <matti.gottlieb@intel.com>,
	"Bondar, Alexander" <alexander.bondar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] iwlwifi: mvm: catch underflow error earlier
Date: Sat, 22 Aug 2015 17:25:48 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8271DF@hasmsx107.ger.corp.intel.com> (sfid-20150822_192603_624205_8FC6EFE5)
References: <20150821084821.GC25369@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On 08/21/2015 11:49 AM, Dan Carpenter wrote:
> My static checker complains that we don't check for underflows in
> iwl_dbgfs_fw_dbg_conf_write().  This is harmless because we have a
> sanity check in iwl_mvm_start_fw_dbg_conf(), but we may as well make
> this unsigned and silence the underflow warning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Applied in our internal tree. Thanks.

> diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
> index ca4a1f8..7d69a55 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
> @@ -949,9 +949,10 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
>  					   char *buf, size_t count,
>  					   loff_t *ppos)
>  {
> -	int ret, conf_id;
> +	unsigned int conf_id;
> +	int ret;
>  
> -	ret = kstrtoint(buf, 0, &conf_id);
> +	ret = kstrtouint(buf, 0, &conf_id);
>  	if (ret)
>  		return ret;
>  
> 
