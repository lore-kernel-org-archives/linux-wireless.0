Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F33ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C2021526
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 07:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5C2021526
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbeJQPLH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 11:11:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:47279 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbeJQPLH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 11:11:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2018 00:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,391,1534834800"; 
   d="scan'208";a="81850704"
Received: from oscharmm-mobl.ger.corp.intel.com ([10.252.23.35])
  by orsmga007.jf.intel.com with ESMTP; 17 Oct 2018 00:16:47 -0700
Message-ID: <f98ae961fa880d9c2b9704ea252326d6cc6ab2e1.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: remove set but not used variable
 'he_phy_data'
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 17 Oct 2018 10:16:45 +0300
In-Reply-To: <1538736421-97401-1-git-send-email-yuehaibing@huawei.com>
References: <1538736421-97401-1-git-send-email-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-05 at 10:47 +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c: In function
> 'iwl_mvm_rx_mpdu_mq':
> drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:1386:7: warning:
>  variable 'he_phy_data' set but not used [-Wunused-but-set-variable]
>    u64 he_phy_data;
>    
> 'he_phy_data' never used since be introduce in
> commit 18ead597daa1 ("iwlwifi: support new rx_mpdu_desc api")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Thanks, Yue! This was a merge damage when I applied the HE patches for
iwlwifi.

I've queued this and will send it out as part of the series for 4.21. 
Then it will trickle down as needed.

--
Cheers,
Luca.

