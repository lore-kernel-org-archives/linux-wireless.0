Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927AFC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE5A206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e135GqDF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e8IDIm7s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfDZMBM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 08:01:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46538 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfDZMBM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 08:01:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9F29C607B9; Fri, 26 Apr 2019 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556280071;
        bh=S+UpnZXol44FDaEhpnfw63FLoR4ULpDXYq59FkgEvlg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=e135GqDF3mGHzBz7K5ncyrM46tJ51KNwo1xPctQDRcIvsL62QeuQDa5/7qLpX+XDl
         4IBRGyUxrQNcev8SLgOZ65zgQjVDfM41RPbOpnF/MOLgK2fsUXZfEouEWAGgfNGtk3
         +w+Ie4zkMDu/t1FlJK2gXnCo+QHeqzwD4f01/Rog=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47FFC6053B;
        Fri, 26 Apr 2019 12:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556280071;
        bh=S+UpnZXol44FDaEhpnfw63FLoR4ULpDXYq59FkgEvlg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=e8IDIm7szID2AmRBetITpIJroQmCq6ys4WYsopbuVNMVSOMVwRM5w5j+/T5CRfwnJ
         7GRxidXcf5x/7PeMm/iHS4dvhI6eA4I99fwBKJiyaR0MVvT2YbNoYCQdeEuQ9q+gxw
         hjhUfEJH4y4OQSzH0L3XP0Eez9oOGCgj42fbzwfE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47FFC6053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] brcmfmac: send mailbox interrupt twice for specific
 hardware device
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1556248345-146837-1-git-send-email-wright.feng@cypress.com>
References: <1556248345-146837-1-git-send-email-wright.feng@cypress.com>
To:     Wright Feng <Wright.Feng@cypress.com>
Cc:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190426120111.9F29C607B9@smtp.codeaurora.org>
Date:   Fri, 26 Apr 2019 12:01:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wright Feng <Wright.Feng@cypress.com> wrote:

> For PCIE wireless device with core revision less than 14, device may miss
> PCIE to System Backplane Interrupt via PCIEtoSBMailbox. So add sending
> mail box interrupt twice as a hardware workaround.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

9ef77fbedad9 brcmfmac: send mailbox interrupt twice for specific hardware device

-- 
https://patchwork.kernel.org/patch/10917993/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

