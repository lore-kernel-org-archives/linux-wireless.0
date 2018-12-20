Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957EDC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2832176F
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 06:48:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gn9l00za";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IebFbscB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbeLTGsP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:48:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbeLTGsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 01:48:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 647646021A; Thu, 20 Dec 2018 06:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288494;
        bh=7rYP3tE4qLdlBZAipcz7Yf4S8HZBo2NeLY0T230Q1oE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Gn9l00za/0bzT8SkQyjw9f+4Zx2aKzLIqEInMHBzclXWsRpIk3G9S/yDw6ZawqqR1
         07DcYboDLaxVNM9Fx9fWNrAaTREtZHlf6iY/tByJmEYqhhmGp+/G2VgteGDW1uyOSE
         c2PuNBCoU03qlD6tzq2evzxiXb+/LLe7yKObc41Q=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AE73B60591;
        Thu, 20 Dec 2018 06:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545288493;
        bh=7rYP3tE4qLdlBZAipcz7Yf4S8HZBo2NeLY0T230Q1oE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IebFbscBPEQ9Rz8zgmOa9L4k28kFtSCRpyVH/+1doNMOFje3dXpEo+OfaLKW/hpxH
         w2DXIjcPnbGKcfQdt3kLr6MwUF4EGW9pcOJLxEiwEuzeWPGlP5isdI3GxEXfyTcokX
         5M7D+XHm9qcGoYBfJt5Z3ck9YF3Kkb+/4MT8WZvo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AE73B60591
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless-drivers] brcmfmac: fix roamoff=1 modparam
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181204182905.32267-1-stijn@linux-ipv6.be>
References: <20181204182905.32267-1-stijn@linux-ipv6.be>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Stable <stable@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220064814.647646021A@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 06:48:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stijn Tintel <stijn@linux-ipv6.be> wrote:

> When the update_connect_param callback is set, nl80211 expects the flag
> WIPHY_FLAG_SUPPORTS_FW_ROAM to be set as well. However, this flag is
> only set when modparam roamoff=0, while the callback is set
> unconditionally. Since commit 7f9a3e150ec7 this causes a warning in
> wiphy_register, which breaks brcmfmac.
> 
> Disable the update_connect_param callback when roamoff=0 to fix this.
> 
> Fixes: 7f9a3e150ec7 ("nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS")
> Cc: Stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

Patch applied to wireless-drivers-next.git, thanks.

8c892df41500 brcmfmac: fix roamoff=1 modparam

-- 
https://patchwork.kernel.org/patch/10712383/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

