Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11B6C00319
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 11:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7358F206DD
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 11:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YyvVVv8K";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S4DlH2Tl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfCELL2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 06:11:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfCELL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 06:11:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3C3D7627EF; Tue,  5 Mar 2019 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551784287;
        bh=B1UZsHN5g0xUgEJ8u8dx9fVYx8GjYhKxX4ux0piHuUY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YyvVVv8K5HiPareOKbvNosynZT5amGAhn28BtEDij7lZjtu4OfsGub4vUerzY7p2B
         UPmcW1Eglt19jiwmtF5XmAX+9Tkpu5d+VRR6NsSAaDRfaLpu4ZekIgJzA74ImtnFwF
         I615AcAAHEuGLhsN79eoq1yebq2D7fXP8qE8SIwg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E664061C62;
        Tue,  5 Mar 2019 11:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551784286;
        bh=B1UZsHN5g0xUgEJ8u8dx9fVYx8GjYhKxX4ux0piHuUY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S4DlH2Tlbt8dZ5qp4Sgn5qOpWNh1M8nyy0AvPdt3fuY4NBtz5UMf3eiKJR3M5xJdN
         jNum+kzx3BpoABHASo/hKhRUjpEiKwkE7Oay4riIcqJwuL1F3ZY/YZ1P4Jhs58dXwI
         hlzDQ8fzIt64arLGmxIZctR4z5lKvaKlz3KPz8Yo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E664061C62
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix 64-bit division
References: <20190304203924.2111146-1-arnd@arndb.de>
Date:   Tue, 05 Mar 2019 13:11:20 +0200
In-Reply-To: <20190304203924.2111146-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 4 Mar 2019 21:38:42 +0100")
Message-ID: <87a7i9fuef.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

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

Luca, can I take this directly?

-- 
Kalle Valo
