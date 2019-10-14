Return-Path: <SRS0=qTSE=YH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85031ECE587
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 08:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5197120673
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Oct 2019 08:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y1fGYb3T";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WjTLtIPV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfJNIiP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:38:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfJNIiP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Oct 2019 04:38:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C764A60923; Mon, 14 Oct 2019 08:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571042294;
        bh=HbjWABwB+H70HYySEKifBK1/BZaxWLgLAPLoOHWAvKI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y1fGYb3TgBHHNp3a2rsvWcDyZBBXUqk4qzqvqtOEEJzt/59lRFVC0eQftWwKS9QBT
         UE0EGqYtGzMDxzJien6lRrew4+t0RQ5UKGlyid+4+6ZDg5r9T9ohFre0pHluQtfCqY
         /zlb8xaZjo5U0KJ0JZmhcwypuDKCJ28esxDXVn6g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 782F360721;
        Mon, 14 Oct 2019 08:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571042294;
        bh=HbjWABwB+H70HYySEKifBK1/BZaxWLgLAPLoOHWAvKI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WjTLtIPVUDpYZo/KSRFm6faJ+JnDsgWSwWCiZlhtFHuW5DPp9pqHlfILe8l9y6x+7
         edLV1dt2PdP0Caf2Jdco80y8TmptLg2OtUEDcp4HuyBnE3w9W/grIlujO+wxdrUAHQ
         DouF62tpYtlk0gbDrgOdb4n9bcUgv81+1JQCuxCw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 782F360721
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: fix array out-of-bounds access
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570609089-22071-1-git-send-email-miaoqing@codeaurora.org>
References: <1570609089-22071-1-git-send-email-miaoqing@codeaurora.org>
To:     Miaoqing Pan <miaoqing@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Miaoqing Pan <miaoqing@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191014083814.C764A60923@smtp.codeaurora.org>
Date:   Mon, 14 Oct 2019 08:38:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Miaoqing Pan <miaoqing@codeaurora.org> wrote:

> If firmware reports rate_max > WMI_TPC_RATE_MAX(WMI_TPC_FINAL_RATE_MAX)
> or num_tx_chain > WMI_TPC_TX_N_CHAIN, it will cause array out-of-bounds
> access, so print a warning and reset to avoid memory corruption.
> 
> Tested HW: QCA9984
> Tested FW: 10.4-3.9.0.2-00035
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

c5329b2d5b8b ath10k: fix array out-of-bounds access
486a88498434 ath10k: fix memory leak for tpc_stats_final

-- 
https://patchwork.kernel.org/patch/11180701/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

