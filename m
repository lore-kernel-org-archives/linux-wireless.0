Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63969C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270BF20859
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NOB4RN5a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YTYbnkF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbfBSPHA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:07:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfBSPHA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:07:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 599AF60388; Tue, 19 Feb 2019 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588819;
        bh=zgO4v7hHspaS6k509jaAL8cnQOCWBjwubUlyC5chMp4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NOB4RN5aU1vpNmpbAyOKJqX0oCzFcTUPd0g/7mhIv/aZ5/eFJOPUWvTwquCrs92xp
         ut0+EDG2kIjPVDHgt2wB1z7fJ2cUIbiL+ocJp7jvxEX6+SSZHnKlJ6VJxswsHm3GnV
         5Ngjtgh2ggH06gCJtoa0KgbQglt9pCZ79rEJHB10=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A94560388;
        Tue, 19 Feb 2019 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588818;
        bh=zgO4v7hHspaS6k509jaAL8cnQOCWBjwubUlyC5chMp4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YTYbnkF1tE4r2GixaO8BOdtxsJaOeUX6CUPX6kT/hM4Vv2qwljUxABg6qfdyNFwxg
         xyDGqsC8/oR99a52+JdPVYoPXRioaoCb9/Pyo3Y2azK5Q+EllWHWW/7jd3NMGmFg65
         +xn1UrwXZk7tqgscCCnJpLCngHzlCM7qa06kHIuI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A94560388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] brcmfmac: improve code handling bandwidth of firmware
 reported channels
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190211220454.19850-1-zajec5@gmail.com>
References: <20190211220454.19850-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150659.599AF60388@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:06:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 1) Use switch to simplify/improve the code & avoid some duplication
> 2) Add warning for unsupported values
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

2 patches applied to wireless-drivers-next.git, thanks.

f4e183293b87 brcmfmac: improve code handling bandwidth of firmware reported channels
30519cbe339a brcmfmac: support firmware reporting 160 MHz channels

-- 
https://patchwork.kernel.org/patch/10806865/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

