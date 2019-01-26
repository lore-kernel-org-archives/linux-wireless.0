Return-Path: <SRS0=mT4l=QC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F570C282C7
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 21:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34CB72184B
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 21:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfAZVYL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Jan 2019 16:24:11 -0500
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:45439 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726400AbfAZVYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Jan 2019 16:24:11 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D9587180A8862;
        Sat, 26 Jan 2019 21:24:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sign63_7b73fc1e0df0f
X-Filterd-Recvd-Size: 1798
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Jan 2019 21:24:08 +0000 (UTC)
Message-ID: <0c2c9ef717676371950942b08556d0e0196559de.camel@perches.com>
Subject: Re: [PATCH] iwlwifi: Use kmemdup instead of duplicating its function
From:   Joe Perches <joe@perches.com>
To:     YueHaibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Sat, 26 Jan 2019 13:24:07 -0800
In-Reply-To: <20190126124235.11248-1-yuehaibing@huawei.com>
References: <20190126124235.11248-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-01-26 at 20:42 +0800, YueHaibing wrote:
> Use kmemdup rather than duplicating its implementation
[]
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
[]
> @@ -1196,13 +1196,9 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
>  	regd_to_copy = sizeof(struct ieee80211_regdomain) +
>  		valid_rules * sizeof(struct ieee80211_reg_rule);
> -	copy_rd = kzalloc(regd_to_copy, GFP_KERNEL);
> -	if (!copy_rd) {
> +	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);

This should probably be

	copy_rd = kmemdup(regd, struct_size(regd, reg_rules, valid_rules),
			  GFP_KERNEL);

> +	if (!copy_rd)
>  		copy_rd = ERR_PTR(-ENOMEM);
> -		goto out;
> -	}
> -
> -	memcpy(copy_rd, regd, regd_to_copy);
>  
>  out:
>  	kfree(regdb_ptrs);

