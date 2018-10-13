Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF7EC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E9620835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hVq7V5UM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PgaZNRoL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64E9620835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbeJNBFN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:05:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48518 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbeJNBFN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:05:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EAAB860BF7; Sat, 13 Oct 2018 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451632;
        bh=lkUmEAoqU+WgPTxCkiSq8+D+wJXbU8t2r/FefmlTGHY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hVq7V5UM4nubevNs5TK0X61C6+2rITMyWu0dfDMjIrqaRsXOJLniVR8C8UAx0AX60
         zrS4Ys/HRUiovGS4w1YuKJel6Lj507sDEIBg3fp+UbiKLvUjHZGxTwQ5ou/mKtr2QU
         PRT6nR7f6IbIlRKK6uD1uXNDTSpOZuQo5szEbZt8=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4AF4B60B72;
        Sat, 13 Oct 2018 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451632;
        bh=lkUmEAoqU+WgPTxCkiSq8+D+wJXbU8t2r/FefmlTGHY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PgaZNRoL8mJzhkvVRKPjUHJDDHVXW9xIIupbIpE187fpZutkn+MD15LIAlejLYitK
         UNw3n51mN1WJcJM1Mp0yatoTjMBJJUh5fyYeO5sE0qmNH3M/5Sz7UjqNBCCjvcGHLr
         v/UeFqK0h33NJ1Xj56uwm27BpLiuiJ0zxYj7q2QU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4AF4B60B72
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: htt: remove some dead code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181011080920.GA15131@mwanda>
References: <20181011080920.GA15131@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Anilkumar Kolli <akolli@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013172712.EAAB860BF7@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:27:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We added an unnecessary condition here in commit a904417fc876 ("ath10k:
> add extended per sta tx statistics support").  "legacy_rate_idx" is a u8
> so it can't be negative.  The caller doesn't pass negatives either.  I
> have deleted this code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e3bfecd5cd37 ath10k: htt: remove some dead code

-- 
https://patchwork.kernel.org/patch/10636255/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

