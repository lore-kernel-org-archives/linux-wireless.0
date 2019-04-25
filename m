Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89AFC43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34883206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jB9oLuZU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YtPai50X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfDYQ6K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:58:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDYQ6K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:58:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1DCCA60388; Thu, 25 Apr 2019 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211490;
        bh=s4z+vtiMJH856TcVKS4k+11FtKDihxxD7KdfPEdI3Yw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jB9oLuZU2y9yMtqhvQAXuTP1rSD/ygAGSyR85hxslkNVunyEc7FoCXhDA7e8fVHiK
         b6IEi2dmd5VXf5iP0i4fKU239JsdGnNG8cZJxFRbHYhx3ebIUZt1eybwBnjQBPBL6U
         Fj8fXjSUgEBYERZB7ekwH4boIiiZF/j6MUaRLI88=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E76A960252;
        Thu, 25 Apr 2019 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211489;
        bh=s4z+vtiMJH856TcVKS4k+11FtKDihxxD7KdfPEdI3Yw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YtPai50XKGd5GjzubIjGMTyxLxm24lGVbSINXg9LDNWDJiLV2rnWlTNlfB7mlMdkJ
         rGr1dNrSJ8Y4iIn+LhA7b5xgrGQPmsG0qRzkhrHXaSLUnAnc1Xg1oJ/qaFukEGg4EP
         gOO5ASUY8uYHEp72erk9dCaW+5ywL7ZMjXYGYQsE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E76A960252
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and
 T11 mini PCs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190422204123.6123-1-hdegoede@redhat.com>
References: <20190422204123.6123-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165810.1DCCA60388@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:58:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> wrote:

> The ACEPC T8 and T11 mini PCs contain quite generic names in the sys_vendor
> and product_name DMI strings, without this patch brcmfmac will try to load:
> "brcmfmac43455-sdio.Default string-Default string.txt" as nvram file which
> is way too generic.
> 
> The DMI strings on which we are matching are somewhat generic too, but
> "To be filled by O.E.M." is less common then "Default string" and the
> system-sku and bios-version strings are pretty unique. Beside the DMI
> strings we also check the wifi-module chip-id and revision. I'm confident
> that the combination of all this is unique.
> 
> Both the T8 and T11 use the same wifi-module, this commit adds DMI
> quirks for both mini PCs pointing to brcmfmac43455-sdio.acepc-t8.txt .
> 
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1690852
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

b1a0ba8f772d brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and T11 mini PCs

-- 
https://patchwork.kernel.org/patch/10911607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

