Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABFDC71122
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F3622077C
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XQs+csAG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SHOPCmv8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F3622077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbeJNBB3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:01:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbeJNBB3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:01:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D63A60A98; Sat, 13 Oct 2018 17:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451410;
        bh=HV9k4uXgpB324YotvYBNxzATJFxVQHQhrz+Ni6zVCCo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XQs+csAGor/Eleo96gRccW9jmH41sHGsn0M3AbUZtINTnpSSOPElAVAgaZxGHe3RN
         Q8mIIYlSv7dd3BejMP7I5u8JLslolruH05rcRO/DxnKbmTNM8HXMcB32Lrv9uYaDng
         nGXV8bD4+EITNht/7HztnXY2bC+l/pTSJXA+B6DY=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 11055600C1;
        Sat, 13 Oct 2018 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451409;
        bh=HV9k4uXgpB324YotvYBNxzATJFxVQHQhrz+Ni6zVCCo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SHOPCmv8FzAXOPRlmpjzsQKxethFoeW8pj5Rn0dZCqv58MxNTkmbKf1E5qzPfJEib
         XA5/mmCdIGgOh/H2dn2KKdxoCDQE6ly5daKCLvpA1mQRru6Yk4z7f1HQADBl7KoYqk
         REWubq452jx5vvAvRRBJ7XIC1BItpBWEMBAUzW5s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 11055600C1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: htt_rx: Fix signedness bug in
 ath10k_update_per_peer_tx_stats
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181005184245.GA11700@embeddedor.com>
References: <20181005184245.GA11700@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013172330.2D63A60A98@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:23:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Currently, the error handling for the call to function
> ath10k_get_legacy_rate_idx() doesn't work because
> *rate_idx* is of type u8 (8 bits, unsigned), which
> makes it impossible for it to hold a value less
> than 0.
> 
> Fix this by changing the type of variable *rate_idx*
> to s8 (8 bits, signed).
> 
> Addresses-Coverity-ID: 1473914 ("Unsigned compared against 0")
> Fixes: 0189dbd71cbd ("ath10k: get the legacy rate index to update the txrate table")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9d9cdbf3f9ed ath10k: htt_rx: fix signedness bug in ath10k_update_per_peer_tx_stats

-- 
https://patchwork.kernel.org/patch/10628675/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

