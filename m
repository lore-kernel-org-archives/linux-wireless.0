Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E4FC4321A
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 559A920693
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vxac1zzM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aR0xGPxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfDYQk3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:40:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfDYQk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:40:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 016B560791; Thu, 25 Apr 2019 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210428;
        bh=hVyDni0V1LjyvPEw+mQoWCd3LMY6RtD78wfqELocwu8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Vxac1zzMf9cgzlwmhxFsHe0T9emQsdm1xOQI36GGctM02N6adGGpud4Si5FXajukm
         l4Eisl2xXaT0nKa1CfaPwdrF0A/UWU2h8QPC0eGUZtRQRNcORAr1wzFOBhFv/GauaM
         lAODPBDaBk3/By+3NoR1UVKvPJ6DfoxNnwDA1Asw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30F8960791;
        Thu, 25 Apr 2019 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210426;
        bh=hVyDni0V1LjyvPEw+mQoWCd3LMY6RtD78wfqELocwu8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aR0xGPxPYHDIMXIfUS2pCnZhY1ikrsYFO+6uJgvwLJazfRCR1z7mQoUONmFCsHK+7
         IFGCrHXXhe9OlCJ8+PBQAyRcagNximqccaHvQu8YHZ3Tsd7h8zXvrF/DnFPsd/y+Hq
         NTzlsarlzQez+Kx+kUr+lcv6RFLnsV0uMs9WBMb8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30F8960791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: cw1200: fix a NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190312080502.2953-1-kjlu@umn.edu>
References: <20190312080502.2953-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        Solomon Peachy <pizza@shaftnet.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164028.016B560791@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:40:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> In case create_singlethread_workqueue fails, the fix free the
> hardware and returns NULL to avoid NULL pointer dereference.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

0ed2a0053474 net: cw1200: fix a NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/10848701/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

