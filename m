Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960F7C10F03
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 17:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F932081B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 17:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AWlB/O/J";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KihBECrN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfCGRP0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:15:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCGRP0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 12:15:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 148F7602FC; Thu,  7 Mar 2019 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551978925;
        bh=KgLbJfHLfOeBhieTyB7XgxHqqK36UAb7NIUFaiv5ie0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AWlB/O/JcDOUkCt4UDXUFeRSrLU9bosoAGG1zgzRi+hnCknbOg4+UEocKthqwK7xQ
         9awk+hDpInQAD2FMcDCqImQDthfupel07Mir5mbilxpTJQpWQDfUVpfE90rLEYC7i0
         0ghpcwlQmBpyG0z2FeU2g0XV9J3WYVkMswhleIEg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BF596029B;
        Thu,  7 Mar 2019 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551978924;
        bh=KgLbJfHLfOeBhieTyB7XgxHqqK36UAb7NIUFaiv5ie0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KihBECrN/nbCPkB3bPmFuH1I3mFBfzyZKUaJ6ijhO+tvc2kU/94fg4XFO93GIoii4
         7AjIVFP0eGknKQ6yME7YMUaRtk2YZGnRhsYOZs1gmXkyv++byeRumB7rq/FyHLCS9u
         6Y5ORZ1IjxAVfPfZ/N2AwTwQStp1dQEwxy1bMmiM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6BF596029B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: fix 64-bit division
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190304203924.2111146-1-arnd@arndb.de>
References: <20190304203924.2111146-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190307171525.148F7602FC@smtp.codeaurora.org>
Date:   Thu,  7 Mar 2019 17:15:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> do_div() expects unsigned operands and otherwise triggers a warning like:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:465:2: error: comparison of distinct pointer types ('typeof ((rtt_avg)) *' (aka 'long long *') and 'uint64_t *' (aka 'unsigned long long *')) [-Werror,-Wcompare-distinct-pointer-types]
>         do_div(rtt_avg, 6666);
>         ^~~~~~~~~~~~~~~~~~~~~
> include/asm-generic/div64.h:222:28: note: expanded from macro 'do_div'
>         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>                ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
> 1 error generated.
> 
> Change the do_div() to the simpler div_s64() that can handle
> negative inputs correctly.
> 
> Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers.git, thanks.

688cd8bd2c0f iwlwifi: fix 64-bit division

-- 
https://patchwork.kernel.org/patch/10838587/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

