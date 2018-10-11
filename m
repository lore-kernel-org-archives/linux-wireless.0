Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2ACC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 09:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C22A020841
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 09:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LfaXXVuK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h49iwQHn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C22A020841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbeJKRQP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 13:16:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44956 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbeJKRQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 13:16:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE70660C7D; Thu, 11 Oct 2018 09:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539251382;
        bh=bNU393ho0vIAmNXovHFwpSImXhKnE+vhNILIYVwMkn0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LfaXXVuK4o6V8ZbUeGd1LYENEjUkBpTJ2XMDJhp7/iDtvmz3Aocyiw//lG4v+2RaQ
         gpai2unsmSTAqTlg5SYZ93XTT/EbSbKjNW+5ezXfoDQYeVQviNhVapLXIqjrTk4eQm
         KA9dQxGJGTkKl+hU4LfBuP14SSfmmY2LqPp5dK9Y=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA7AD60866;
        Thu, 11 Oct 2018 09:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539251382;
        bh=bNU393ho0vIAmNXovHFwpSImXhKnE+vhNILIYVwMkn0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=h49iwQHnOsnon7iFsCTDFLsUSCBwECtGpztVNcvmtnxdayN+RBcpKBYwgqQZ6xnJr
         puJNFqIDKPZa9GueqbDJTgqE7kTXUsjE01cnN80SKb4pPnK3KXz02eFYwdHBPJCvwn
         sdkBmqBP18XhWQgoxO7amdaS7ol6gUwQrkWnHjp4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA7AD60866
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath10k: fix out of bound read on array ath10k_rates
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181005215609.13935-1-colin.king@canonical.com>
References: <20181005215609.13935-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Sriram R <srirrama@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181011094942.AE70660C7D@smtp.codeaurora.org>
Date:   Thu, 11 Oct 2018 09:49:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> An out-of-bounds read on array ath10k_rates is occurring because
> the maximum number of elements is currently based on the size of
> the array and not the number of elements in the array. Fix this
> by using ARRAY_SIZE instead of sizeof.
> 
> Detected by CoverityScan, CID#1473918 ("Out-of-bounds read")
> 
> Fixes: f279294e9ee2 ("ath10k: add support for configuring management packet rate")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This is already fixed in ath-next.

error: patch failed: drivers/net/wireless/ath/ath10k/mac.c:164
error: drivers/net/wireless/ath/ath10k/mac.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/10628815/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

