Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E12C43381
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 06:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75772075B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 06:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfCEGn6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 01:43:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:48974 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfCEGn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 01:43:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 22:43:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,443,1544515200"; 
   d="scan'208";a="139188762"
Received: from kphartnx-mobl1.ger.corp.intel.com ([10.252.28.244])
  by orsmga002.jf.intel.com with ESMTP; 04 Mar 2019 22:43:54 -0800
Message-ID: <ec4e92fa787a7db1caf39920a62c3721849baee9.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: fix 64-bit division
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 05 Mar 2019 08:43:53 +0200
In-Reply-To: <20190304203924.2111146-1-arnd@arndb.de>
References: <20190304203924.2111146-1-arnd@arndb.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arnd,

On Mon, 2019-03-04 at 21:38 +0100, Arnd Bergmann wrote:
> do_div() expects unsigned operands and otherwise triggers a warning
> like:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:465:2: error:
> comparison of distinct pointer types ('typeof ((rtt_avg)) *' (aka
> 'long long *') and 'uint64_t *' (aka 'unsigned long long *')) [-
> Werror,-Wcompare-distinct-pointer-types]
>         do_div(rtt_avg, 6666);
>         ^~~~~~~~~~~~~~~~~~~~~
> include/asm-generic/div64.h:222:28: note: expanded from macro
> 'do_div'
>         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>                ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
> 1 error generated.
> 
> Change the do_div() to the simpler div_s64() that can handle
> negative inputs correctly.
> 
> Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

This was already fixed with this patch:

https://patchwork.kernel.org/patch/10823267/

...but it hasn't reached the mainline yet.

I'm planning to send it to the v5.1-rc series as soon as the merge
window closes.  Is that quick enough for you?

--
Cheers,
Luca.

