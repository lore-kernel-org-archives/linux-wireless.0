Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32D7C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF6D2171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:47:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QHjq+MNC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d9Ovk8HY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732063AbfB1IrG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:47:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732029AbfB1Iq6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:46:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 963DC60767; Thu, 28 Feb 2019 08:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343617;
        bh=lHm0BJ8+oOiVaJAVfggoNnrwCgwxOdZCpYBAbRoNOJA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QHjq+MNCvr6dSuqpDo9ZFxkdEF5nrkr+yEOub8EzmEqmYSQ/bXFr7SGsQsVnrJR5I
         qB5vQrqpEwztfyro5jrswLnHyUs2Jlt7eM7ptMWdMOK/hSq8vue5sLugnnP1dFirue
         OW+nJtd+bIfclYf+lXLXyxX/3ZQjXMBysh6L9tKM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B40A60909;
        Thu, 28 Feb 2019 08:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343617;
        bh=lHm0BJ8+oOiVaJAVfggoNnrwCgwxOdZCpYBAbRoNOJA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=d9Ovk8HYQIrHIbGRIAzz4nKfMJv96BJtsT3uQ+6otjOHWSKOPK/U6pO+Yc21CAWdT
         3gBAv1Wze+tPJYB579zS3RA48QcQ1VmotDBrZLHMnFpqeLS9c1YXJJHJYnTadN7tg2
         rVpVaep18zFpzew5WH90U1yc+QJh9KUhVk11VdII=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B40A60909
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/4] ath10k: Fix the incorrect updation of NSS data in
 tx stats
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1551173278-20926-2-git-send-email-svishnoi@codeaurora.org>
References: <1551173278-20926-2-git-send-email-svishnoi@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228084657.963DC60767@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:46:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

> The NSS data is updated incorrectly in the tx stats as the array
> indexing starts from zero.
> 
> Fix the incorrect updation of NSS data in tx_stats by taking into
> consideration the array index starting from zero.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 
> Fixes: a904417fc876 ("ath10k: add extended per sta tx statistics support")
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

3a08ac3e79e8 ath10k: Fix the incorrect updation of NSS data in tx stats
ef9051c72ab7 ath10k: Fix the wrong updation of BW in tx_stats debugfs entry
8e55fdaa8ea7 ath10k: Fix the wrong updation of SGI in tx_stats debugfs
d23c2cdaa013 ath10k: Fix the wrong calculation ht_idx and idx of rate table for tx_stats

-- 
https://patchwork.kernel.org/patch/10829765/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

