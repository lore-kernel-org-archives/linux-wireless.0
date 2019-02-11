Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD67C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB97F21773
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:30:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EPqTFRl5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bBTfIldM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfBKQa4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:30:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfBKQa4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:30:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6F21160C69; Mon, 11 Feb 2019 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902655;
        bh=ZPGATeNayvwGUiR+UHWYpTHAG/adnX5gbaYSbTqyQi4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EPqTFRl5alPYL1BJSHA/AbQwBginFyuxlm9LQoU7iu2QnJyvpmfwV2/HYJKvgyANs
         3Es6YduIfLeVJiZ6s+612Sxc2qfq6pEE9kSCZmbd1Mdcr+yVQ9HH2D2BSNFBm/Q28O
         w9OMNXCvSgrUzP129puvGUpeh4vS34Rh2VRK8FZ8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A1D260985;
        Mon, 11 Feb 2019 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902654;
        bh=ZPGATeNayvwGUiR+UHWYpTHAG/adnX5gbaYSbTqyQi4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bBTfIldMwC7RmzUT4m3GrURk49dQ9jHYqbMPf69ud8viLsaCCROpLice/lpyICMZ8
         QL9r5rRRO45NxkNBa2u9pD5kx8Yow0sHQodjyw7jKc/+bP1z9U+1JhV8uRK1Hhb7gO
         dHYmHDhitU+ek+MgPU47syem6ZL2X3kYWTAr9fzY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9A1D260985
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/3] ath10k: Enable bus layer suspend/resume for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190206121433.11606-2-govinds@codeaurora.org>
References: <20190206121433.11606-2-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211163055.6F21160C69@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 16:30:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> Register snoc bus layer suspend/resume PM ops and configure
> the wakeup source(CE2) for the device.
> 
> Testing:
>     Tested on WCN3990 HW.
>     Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

185be1c66469 ath10k: enable bus layer suspend/resume for WCN3990
de8781d7e74d ath10k: disable interface pause wow config for integrated chipset
c40e448e0bcf ath10k: request credit report if flow control enabled on ep

-- 
https://patchwork.kernel.org/patch/10799247/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

