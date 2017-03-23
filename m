Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47476 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753765AbdCWMZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 08:25:58 -0400
Message-ID: <1490271944.2700.63.camel@coelho.fi> (sfid-20170323_132618_708467_FE133D08)
From: Luca Coelho <luca@coelho.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Golan Ben-Ami <golan.ben.ami@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Ido Yariv <ido@wizery.com>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Thu, 23 Mar 2017 14:25:44 +0200
In-Reply-To: <20170323104000.GB20154@mwanda>
References: <20170323104000.GB20154@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: mvm: writing zero bytes to debugfs causes a
 crash
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-23 at 13:40 +0300, Dan Carpenter wrote:
> This is a static analysis fix.  The warning is:
> 
> 	drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:912 iwl_mvm_fw_dbg_collect()
> 	warn: integer overflows 'sizeof(*desc) + len'
> 
> I guess this code is supposed to take a NUL character, but if we write
> zero bytes then it tries to write -1 characters and crashes.
> 
> Fixes: c91b865cb14d ("iwlwifi: mvm: support description for user triggered fw dbg collection")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> index a260cd503200..077bfd8f4c0c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> @@ -1056,6 +1056,8 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
>  
>  	if (ret)
>  		return ret;
> +	if (count == 0)
> +		return 0;
>  
>  	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, buf,
>  			       (count - 1), NULL);

Thanks! I'm going to push this via our internal tree.

--
Cheers,
Luca.
