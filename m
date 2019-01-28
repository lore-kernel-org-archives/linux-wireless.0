Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E477C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 21:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1152175B
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 21:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfA1V5y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:57:54 -0500
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:49108 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726766AbfA1V5y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 16:57:54 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 033A91801F2C8;
        Mon, 28 Jan 2019 21:57:53 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: magic88_615c72cc92e44
X-Filterd-Recvd-Size: 2512
Received: from XPS-9350 (unknown [172.56.44.167])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Mon, 28 Jan 2019 21:57:48 +0000 (UTC)
Message-ID: <9a66aa07870c729ad0e65ac26a2404fac879f290.camel@perches.com>
Subject: Re: [PATCH 2/2] iwlwifi: Use struct_size() in kzalloc
From:   Joe Perches <joe@perches.com>
To:     YueHaibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Mon, 28 Jan 2019 13:57:45 -0800
In-Reply-To: <20190128064432.17576-3-yuehaibing@huawei.com>
References: <20190128064432.17576-1-yuehaibing@huawei.com>
         <20190128064432.17576-3-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-01-28 at 14:44 +0800, YueHaibing wrote:
> Use struct_size() in kzalloc instead of the 'regd_to_copy'

There is also the use above that in the same function
that could also be converted.

	/* build a regdomain rule for every valid channel */
	size_of_regd =
		sizeof(struct ieee80211_regdomain) +
		num_of_ch * sizeof(struct ieee80211_reg_rule);

	regd = kzalloc(size_of_regd, GFP_KERNEL);
	if (!regd)
		return ERR_PTR(-ENOMEM);

> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
[]
> @@ -1093,7 +1093,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
>  	const u8 *nvm_chan = cfg->nvm_type == IWL_NVM_EXT ?
>  			     iwl_ext_nvm_channels : iwl_nvm_channels;
>  	struct ieee80211_regdomain *regd, *copy_rd;
> -	int size_of_regd, regd_to_copy;
> +	int size_of_regd;
>  	struct ieee80211_reg_rule *rule;
>  	struct regdb_ptrs *regdb_ptrs;
>  	enum nl80211_band band;
> @@ -1193,10 +1193,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
>  	 * Narrow down regdom for unused regulatory rules to prevent hole
>  	 * between reg rules to wmm rules.
>  	 */
> -	regd_to_copy = sizeof(struct ieee80211_regdomain) +
> -		valid_rules * sizeof(struct ieee80211_reg_rule);
> -
> -	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
> +	copy_rd = kmemdup(regd, struct_size(regd, reg_rules, valid_rules),
> +			  GFP_KERNEL);
>  	if (!copy_rd)
>  		copy_rd = ERR_PTR(-ENOMEM);
>  

