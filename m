Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2319CC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0E382176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KJqIJxCt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XwXqjdmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbeLTHbX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:31:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeLTHbX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 02:31:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CEEB860736; Thu, 20 Dec 2018 07:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545291082;
        bh=5ki4O5wyjxB73gN3fRuYC4MOMFKKX5djVtbQeNPQNJk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KJqIJxCt/sFlwZllfDHOi5R4TBeZoVf9lLUNvAvXmdNHwOkL0215dazg5yk9ZOpd8
         CWY43HVuskaMi3CWiP7rNKVnprLG/YgVNQADus55/yOWysEzhx4CbgjKYCTX+pSOuW
         EFsdlustg+qEOAgnvoKdrBLN/7vhGf575Zvg2SwE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 150B260736;
        Thu, 20 Dec 2018 07:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545291082;
        bh=5ki4O5wyjxB73gN3fRuYC4MOMFKKX5djVtbQeNPQNJk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XwXqjdmLWXt2Y++LRF7Isbz3aatFHgD5i3ulwK9AUJCIhDFvYewp6zm2S1tLpnWIv
         jrYMw7FDJt53m/SBJsbG2n/wM1bR7ESJrDOW/IqeiJaZdkJAjGURnJFaCfpzebgA22
         TLUU79DO8X6UVdNS7ushMjVNxzSoeSS0cumdeFfg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 150B260736
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] ath6kl: Only use match sets when firmware supports it
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181108163659.19535-1-kyle.roeschley@ni.com>
References: <20181108163659.19535-1-kyle.roeschley@ni.com>
To:     Kyle Roeschley <kyle.roeschley@ni.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kyle Roeschley <kyle.roeschley@ni.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220073122.CEEB860736@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 07:31:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kyle Roeschley <kyle.roeschley@ni.com> wrote:

> Commit dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
> merged the probed and matched SSID lists before sending them to the
> firmware. In the process, it assumed match set support is always available
> in ath6kl_set_probed_ssids, which breaks scans for hidden SSIDs. Now, check
> that the firmware supports matching SSIDs in scheduled scans before setting
> MATCH_SSID_FLAG.
> 
> Fixes: dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
> Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

fb376a495fbd ath6kl: Only use match sets when firmware supports it
5803c12816c4 ath6kl: Fix off by one error in scan completion
192a986d964c ath6kl: Use debug instead of error message when disabled

-- 
https://patchwork.kernel.org/patch/10674651/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

