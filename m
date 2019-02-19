Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D893C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD5220859
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZfHR9gnc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NmXuh5r3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfBSPHd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:07:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34224 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfBSPHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:07:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82A6B60388; Tue, 19 Feb 2019 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588852;
        bh=NxQAz3brH52y3XFxSmp8eFXj4ct8TGBDfwzwh6RP7qI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZfHR9gnc/eeP0D1bLU2hJYyf1fXzaK6Ju2IUhRTNcfLdPN8Vy2ISJsAqgNM0d1Fem
         SBVoed/ZH1wyqagCWcBWN6txikU1sNSl5/jtEyIOF0w6zkJjnbW/QSkwJrOzZnb0Cz
         NuyLB7Q68EM09mueMPBwJO57osbBS12iMyLfSp+M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 72C236071A;
        Tue, 19 Feb 2019 15:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588851;
        bh=NxQAz3brH52y3XFxSmp8eFXj4ct8TGBDfwzwh6RP7qI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NmXuh5r30TIRpe0r7i9F5LW5qu2p3GYgwboIJQYptZrhPDXg2bJVBhTYkrs7L8zF4
         Ooogw6l9fzYB6uMOao/nPruWIFwZROZopooBwl549mTV2kGByB+owBDKgjgRJEBwyJ
         ANzNxxjCpU6FWCOrij98jpAXHPPA6P/BP9N9JUyE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 72C236071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmfmac: rework bphy_err() to take struct brcmf_pub
 argument
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190215144554.6860-1-zajec5@gmail.com>
References: <20190215144554.6860-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150732.82A6B60388@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:07:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This macro will be used in more places not just the cfg80211.c. It makes
> sense to pass some common struct to it as "struct wiphy" is mostly
> referenced in cfg80211 code only.
> 
> A very common one (used above the bus abstraction layer) is struct
> brcmf_pub. Many functions already keep reference to it which will make
> using bphy_err() simpler. It should also allow extending that macro's
> logic if it's ever needed.
> 
> This improves code recently added in the commit 3ef005b82e2a ("brcmfmac:
> add bphy_err() and use it in the cfg80211.c").
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

16e646768396 brcmfmac: rework bphy_err() to take struct brcmf_pub argument

-- 
https://patchwork.kernel.org/patch/10815043/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

