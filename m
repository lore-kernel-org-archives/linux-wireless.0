Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037553AbdDUKnZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 06:43:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: missing unlock on error path
References: <20170421103937.jko3eguvfn3i6r3v@mwanda>
Date: Fri, 21 Apr 2017 13:43:18 +0300
In-Reply-To: <20170421103937.jko3eguvfn3i6r3v@mwanda> (Dan Carpenter's message
        of "Fri, 21 Apr 2017 13:39:38 +0300")
Message-ID: <87vapy2g8p.fsf@kamboji.qca.qualcomm.com> (sfid-20170421_124330_250204_4AC12A00)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> We should unlock before returning.
>
> Fixes: eda50cde58de ("iwlwifi: pcie: add context information support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
> index 302310dfef9e..4e84955d55c8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
> @@ -212,8 +212,10 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
>  		goto out;
>  	}
>  
> -	if (iwl_pcie_ctxt_info_init(trans, fw))
> -		return -ENOMEM;
> +	if (iwl_pcie_ctxt_info_init(trans, fw)) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}

This was recently fixed:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=97b00d877bb8c2e499b9d0c07b65bd92b4e91ddd

-- 
Kalle Valo
