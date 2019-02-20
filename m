Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE9CC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A41BB2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:54:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A/zG71Ra";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aKUwaDnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfBTRyp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:54:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfBTRyp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 12:54:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D3DAD608FF; Wed, 20 Feb 2019 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685284;
        bh=UjuaUZBNiINnSxvBzxFaHzdoWr00acv0rwItp9ywSxg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=A/zG71RaEs2ZOYz4FDi4GFTQXogtHdOvrI+G5bm648CiXJW2Fs9/a8ZCI4MncHS/n
         1F7OQAqPEK190jUhCkEra7nuMpxrMOf1mtZ5XGODMKOEDLMRKF6oEJGO49IW0sf72f
         Er3Ccb6PCspDidAwSrS8Nr/HxafVae0KbEK+6nxA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 493B5608CD;
        Wed, 20 Feb 2019 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685281;
        bh=UjuaUZBNiINnSxvBzxFaHzdoWr00acv0rwItp9ywSxg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aKUwaDnD6b1dOjp4tLau0mz68dOieQ3s2fry8FcT56VW7LCde/aLpNCeRJnLV61Sj
         u2T91KizwnT/8HkRO4Fbg7fSK4d+Z8yQsOALpWzWWTavjMiWRzMiYbfbRGZcqmaO3z
         I0wzWyU5jIe0QGzKQXBsKkebK+Fq5k5VH5DPJpOg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 493B5608CD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V4] brcmfmac: use bphy_err() in all wiphy-related code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190219224219.31746-1-zajec5@gmail.com>
References: <20190219224219.31746-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190220175443.D3DAD608FF@smtp.codeaurora.org>
Date:   Wed, 20 Feb 2019 17:54:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This recently added macro provides more meaningful error messages thanks
> to identifying a specific wiphy. It's especially important on systems
> with few cards supported by the same (brcmfmac) driver.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

dcb1471bc6d0 brcmfmac: use bphy_err() in all wiphy-related code

-- 
https://patchwork.kernel.org/patch/10820843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

