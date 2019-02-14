Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3F5C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 06:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B6A222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 06:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405935AbfBNG5Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 01:57:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:10068 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405705AbfBNG5Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 01:57:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 22:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,367,1544515200"; 
   d="scan'208";a="318902102"
Received: from hnswanep-mobl.amr.corp.intel.com ([10.252.8.171])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2019 22:57:21 -0800
Message-ID: <34b38d463c5eddef2a3923cbc291c8284eb54cf9.camel@intel.com>
Subject: Re: [PATCH v2 1/2] iwlwifi: Use kmemdup instead of duplicating its
 function
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Thu, 14 Feb 2019 08:57:20 +0200
In-Reply-To: <20190129032144.18120-2-yuehaibing@huawei.com>
References: <20190129032144.18120-1-yuehaibing@huawei.com>
         <20190129032144.18120-2-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-29 at 11:21 +0800, YueHaibing wrote:
> Use kmemdup rather than duplicating its implementation
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> index d9afedc..569cc50 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> @@ -1196,13 +1196,9 @@ iwl_parse_nvm_mcc_info(struct device *dev,
> const struct iwl_cfg *cfg,
>  	regd_to_copy = sizeof(struct ieee80211_regdomain) +
>  		valid_rules * sizeof(struct ieee80211_reg_rule);
>  
> -	copy_rd = kzalloc(regd_to_copy, GFP_KERNEL);
> -	if (!copy_rd) {
> +	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
> +	if (!copy_rd)
>  		copy_rd = ERR_PTR(-ENOMEM);
> -		goto out;
> -	}
> -
> -	memcpy(copy_rd, regd, regd_to_copy);
>  
>  out:
>  	kfree(regdb_ptrs);

This was already applied.  Dropping.

--
Luca.

