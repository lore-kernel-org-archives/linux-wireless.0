Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6D9C282CB
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 05:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B032E20989
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 05:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfA1F6v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 00:58:51 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:59928 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbfA1F6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 00:58:51 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1C516EF6C33E0F4AD4C1;
        Mon, 28 Jan 2019 13:58:49 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Mon, 28 Jan 2019
 13:58:44 +0800
Subject: Re: [PATCH] iwlwifi: Use kmemdup instead of duplicating its function
To:     Joe Perches <joe@perches.com>, <johannes.berg@intel.com>,
        <emmanuel.grumbach@intel.com>, <luciano.coelho@intel.com>,
        <linuxwifi@intel.com>, <kvalo@codeaurora.org>
References: <20190126124235.11248-1-yuehaibing@huawei.com>
 <0c2c9ef717676371950942b08556d0e0196559de.camel@perches.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <5e72a592-b795-0d88-e393-fff65126ca47@huawei.com>
Date:   Mon, 28 Jan 2019 13:58:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <0c2c9ef717676371950942b08556d0e0196559de.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019/1/27 5:24, Joe Perches wrote:
> On Sat, 2019-01-26 at 20:42 +0800, YueHaibing wrote:
>> Use kmemdup rather than duplicating its implementation
> []
>> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> []
>> @@ -1196,13 +1196,9 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
>>  	regd_to_copy = sizeof(struct ieee80211_regdomain) +
>>  		valid_rules * sizeof(struct ieee80211_reg_rule);
>> -	copy_rd = kzalloc(regd_to_copy, GFP_KERNEL);
>> -	if (!copy_rd) {
>> +	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
> 
> This should probably be
> 
> 	copy_rd = kmemdup(regd, struct_size(regd, reg_rules, valid_rules),
> 			  GFP_KERNEL);
> 

Yes, So also can remove 'regd_to_copy', I will do it in a new patch

Thanks!

>> +	if (!copy_rd)
>>  		copy_rd = ERR_PTR(-ENOMEM);
>> -		goto out;
>> -	}
>> -
>> -	memcpy(copy_rd, regd, regd_to_copy);
>>  
>>  out:
>>  	kfree(regdb_ptrs);
> 
> 
> .
> 

