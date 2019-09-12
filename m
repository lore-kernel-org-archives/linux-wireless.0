Return-Path: <SRS0=PXnU=XH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3676EC4CEC5
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 15:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 075E42081B
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 15:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gk9qmOWm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZkvtTvmh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732938AbfILPFw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:05:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732708AbfILPFw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Sep 2019 11:05:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65A3460721; Thu, 12 Sep 2019 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568300751;
        bh=EmDled5B767UpjqGHQ2Kmli4JyKcmNLHLbVUhgKHFbM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Gk9qmOWmMdqBCTnVGJAKm2Yhd5GQLd/DzrTXhzbiRf4QZ4A7bDZd2rHPQREqxiFQu
         sdH9LI2t6dkRbEfpEvGRbvXIs1MVXj04ZnIf1m/A4Oi5G2rSkQL+X/5L5DbUNLBVVZ
         SLIBBJJ2uZ7XsSWBYA7MQZQRMKfRqJh9fXpcCogE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCCD9602BC;
        Thu, 12 Sep 2019 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568300750;
        bh=EmDled5B767UpjqGHQ2Kmli4JyKcmNLHLbVUhgKHFbM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZkvtTvmhf58ifQ9AkbSehRQJnlg5FXwSz1SvPAElZW/kM5kDpjRARd5TjYCx55fS3
         1vq0DaPq5ZA32UjabOfKRg2Z2SPIMgwYsZVXP6amHZ1AGr6/zlkC321nCAfy7XkfAD
         4WiNwNzS8IbfKhE8gp2LHHzTWW05cgCne5Ns5jzI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCCD9602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix channel info parsing for non tlv target
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1552044366-9186-1-git-send-email-pillair@codeaurora.org>
References: <1552044366-9186-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190912150551.65A3460721@smtp.codeaurora.org>
Date:   Thu, 12 Sep 2019 15:05:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The tlv targets such as WCN3990 send more data in the chan info event, which is
> not sent by the non tlv targets. There is a minimum size check in the wmi event
> for non-tlv targets and hence we cannot update the common channel info
> structure as it was done in commit 13104929d2ec ("ath10k: fill the channel
> survey results for WCN3990 correctly"). This broke channel survey results on
> 10.x firmware versions.
> 
> If the common channel info structure is updated, the size check for chan info
> event for non-tlv targets will fail and return -EPROTO and we see the below
> error messages
> 
>    ath10k_pci 0000:01:00.0: failed to parse chan info event: -71
> 
> Add tlv specific channel info structure and restore the original size of the
> common channel info structure to mitigate this issue.
> 
> Tested HW: WCN3990
> 	   QCA9887
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 	   10.2.4-1.0-00037
> 
> Fixes: 13104929d2ec ("ath10k: fill the channel survey results for WCN3990 correctly")
> Cc: stable@vger.kernel.org # 5.0
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6be6c04bcc2e ath10k: fix channel info parsing for non tlv target

-- 
https://patchwork.kernel.org/patch/10844513/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

