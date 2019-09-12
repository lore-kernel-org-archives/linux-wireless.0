Return-Path: <SRS0=PXnU=XH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA50C4CEC5
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 15:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DB61206CD
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 15:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gWBn8P+n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gtTQUNYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbfILPIo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:08:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732566AbfILPIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Sep 2019 11:08:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 57FB2607CA; Thu, 12 Sep 2019 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568300923;
        bh=pTrR9D5IvzamfAjVZmSPKgaXQOeOA3pGCnd89ireZ2s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gWBn8P+ncK2AmHgJJ5jIUo5smx3YMBfQqlRL7RSCsDPFOkQ8tXCC+AxmvRTy2HvZg
         +8VuoBNBZ9sijdiwcNJQBRS58ijuCVempVKM/3+IsZzoQyiph/7E+brpZSB7XkS/tM
         K/Z7A6mkpeMaEeK2lOfexnV7/5/XpB7cyou7M3WA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9455C6055A;
        Thu, 12 Sep 2019 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568300922;
        bh=pTrR9D5IvzamfAjVZmSPKgaXQOeOA3pGCnd89ireZ2s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=gtTQUNYX1ve+/JBC/mts4sFVs3guGLb0AsVEDkx4bsbX7mE40IvA9e2hpfz/LSpEV
         6u+DeuW5wWlj+NKgvmmY4EJfEBRNkr4dTZ6WQHc2T1CUJxFoNCkGrU97mJU++yOEtO
         wyiCxQtWCXJU47ML19Jjzhr29LpW1TQOZdvbwDHc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9455C6055A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/11] wil6210: add wil_netif_rx() helper function
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567931575-27984-2-git-send-email-merez@codeaurora.org>
References: <1567931575-27984-2-git-send-email-merez@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190912150843.57FB2607CA@smtp.codeaurora.org>
Date:   Thu, 12 Sep 2019 15:08:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:

> Move common part of wil_netif_rx_any into new helper function and add
> support for non-gro receive using netif_rx_ni.
> 
> Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

10 patches applied to ath-next branch of ath.git, thanks.

f99fe49ff372 wil6210: add wil_netif_rx() helper function
977c45ab5f41 wil6210: add debugfs to show PMC ring content
42fe1e519e9f wil6210: fix PTK re-key race
f4519fd9375d wil6210: make sure DR bit is read before rest of the status message
e78975fcdae4 wil6210: verify cid value is valid
068f359aac40 wil6210: properly initialize discovery_expired_work
058b3f112419 wil6210: report boottime_ns in scan results
0e698cd0b94c wil6210: use writel_relaxed in wil_debugfs_iomem_x32_set
055c8a71eb5b wil6210: fix RX short frame check
50e107ff2213 wil6210: ignore reset errors for FW during probe

-- 
https://patchwork.kernel.org/patch/11136849/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

