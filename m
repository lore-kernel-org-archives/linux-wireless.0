Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEF7C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78EEE21908
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wq+1Hp+q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="guxWNFub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBGOhg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:37:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfBGOhg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:37:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A7103605FC; Thu,  7 Feb 2019 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549550255;
        bh=Sa4/nzqTbgg/xbupbnCaLl4g+Ax0nz4Qq/j5GvQ/h5I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Wq+1Hp+qt/Mxego10CEJfTNyD37kXod5relxiJnq2z+J+thP5SdzGNt9KElIFohWc
         vcExz/g5bmpRLyfl7a1b9ELS6aegAiYsBchXZS2ibWXssaWMsWj2Cu6duiU/G4M1sy
         pP5zzorjJlVaxBiYaga8+p++GDkdKGaTq+V9xaog=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7517E602CC;
        Thu,  7 Feb 2019 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549550255;
        bh=Sa4/nzqTbgg/xbupbnCaLl4g+Ax0nz4Qq/j5GvQ/h5I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=guxWNFubKLTAzdCgBi5d/FDN32qzz6I0s0YzOhP4UMBMYke4xsKJVkEDYKPHRw9fU
         2+vwktahuxhviDdX2qtmuVUTjvLhnpD0MQ7uQb8XVMsv265fE9VFMq8ejuoDY3NRt7
         lFYJ1m4nxvnh4CF7KoDBNceChbhf2NvxAg/BogRg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7517E602CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] ath10k: Handle bundled tx completion for
 management frames
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548389402-10083-2-git-send-email-pillair@codeaurora.org>
References: <1548389402-10083-2-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207143735.A7103605FC@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:37:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> WCN3990 supports sending tx completion for multiple
> management frames bundled together in a single event.
> 
> Add support to handle the bundled tx completion
> event for WCN3990.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

cc123fac978f ath10k: Handle bundled tx completion for management frames
543271334483 ath10k: Enable bundle tx compl for management frames in WCN3990

-- 
https://patchwork.kernel.org/patch/10780541/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

