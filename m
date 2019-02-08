Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05BEC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5FE12146E
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZEUtDM/R";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BsE37kuo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfBHPX3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:23:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBHPX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:23:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8E2EB608CE; Fri,  8 Feb 2019 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639408;
        bh=8CBkVXNhZBdiSjVy4UiikPO4fFGC3CGgNdtZccb3fWA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZEUtDM/RiNczyzmeu6kE+XNIOoEKfYto+twCCmXr1v650CNafQmj6rlpfLTzuHsLz
         M7OWKvD8ZG4NFZy+Zq9C6mfErATbXiKuN5R8Cw41sECOzUZvox55jVVm+csfvLaDqQ
         1ZQWCH5oDWvmbNVjfCv93/RRd0+N40W+gVHxjXbY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32FCE60995;
        Fri,  8 Feb 2019 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639405;
        bh=8CBkVXNhZBdiSjVy4UiikPO4fFGC3CGgNdtZccb3fWA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BsE37kuoTdPxdFaox7VtY8tKnYZ9q9jBGBblwGASX/tvTau0AXCgmYHFbsZgx+77V
         Cl8NDUxIngIl+e5vf+5bG3+gObRrxIBQ+qR+PhkQsUXIz3bi+m3or0N3xZIol7iq4P
         tPI1+OCu6XsQw79IHzC/TkebOD5PP/alKEnGtOBU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32FCE60995
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 1/2] brcmfmac: modify __brcmf_err() to take bus as a
 parameter
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190206112816.563-1-zajec5@gmail.com>
References: <20190206112816.563-1-zajec5@gmail.com>
To:     " =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= " <rafal.milecki@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208152328.8E2EB608CE@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:23:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

" wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far __brcmf_err() was using pr_err() which didn't allow identifying
> device that was affected by an error. It's crucial for systems with more
> than 1 device supported by brcmfmac (a common case for home routers).
> 
> This change allows passing struct brcmf_bus to the __brcmf_err(). That
> struct has been agreed to be the most common one. It allows accessing
> struct device easily & using dev_err() printing helper.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers-next.git, thanks.

5cc898fbcb35 brcmfmac: modify __brcmf_err() to take bus as a parameter
8602e62441ab brcmfmac: pass bus to the __brcmf_err() in pcie.c

-- 
https://patchwork.kernel.org/patch/10799163/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

