Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49735C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F3C121019
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VITgCqEW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dG7LDnhs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F3C121019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbeK3Ch7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:37:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbeK3Ch7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:37:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4CE1B606DC; Thu, 29 Nov 2018 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505534;
        bh=Gcc2bDZTzLfhm0OVaEZ5eDQya8PXdFHuwxvKvG+43zY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VITgCqEWFuNWClKFqjDgU9Yq30fPKbKLbnZM8/SfhCCG1U4Wam+dCAumtlMsy9twC
         M0A80StsT4HeIvdd9vrBWgicgXwg5kmgSxEDaQX8c0x9eGujXgEJA9DbBOAI06CSWp
         sRytIBRACoYL/ktB/4fegH3Hil+VuP3igROhSLZc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 063CC60710;
        Thu, 29 Nov 2018 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505533;
        bh=Gcc2bDZTzLfhm0OVaEZ5eDQya8PXdFHuwxvKvG+43zY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dG7LDnhsqID3JCjjAAk/kR/GvYX2bBz2xbqRCiSPPQwfdfbBvIwgvUgWuHZN11jyU
         qkhr9wkZPeRwODUf42leH+2yU0As0swutgtH66VMdYm4+sY7OPmJC3URc9ovEW0IJ6
         RbuQRMKIs5Do31gP+rUIiCRMAeyHXjF6dFMVPYKQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 063CC60710
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] brcmfmac: support STA info struct v7
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1541781535-10523-1-git-send-email-dan.haab@luxul.com>
References: <1541781535-10523-1-git-send-email-dan.haab@luxul.com>
To:     Dan Haab <riproute@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Dan Haab <dan.haab@luxul.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181129153214.4CE1B606DC@smtp.codeaurora.org>
Date:   Thu, 29 Nov 2018 15:32:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Haab <riproute@gmail.com> wrote:

> The newest firmwares provide STA info using v7 of the struct. As v7
> isn't backward compatible, a union is needed.
> 
> Even though brcmfmac does not use any of the new info it's important to
> provide the proper struct buffer. Without this change new firmwares will
> fallback to the very limited v3 instead of something in between such as
> v4.
> 
> Signed-off-by: Dan Haab <dan.haab@luxul.com>
> Reviewed-by: Rafał Miłecki <rafal@milecki.pl>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

4282ff17e557 brcmfmac: support STA info struct v7

-- 
https://patchwork.kernel.org/patch/10676321/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

