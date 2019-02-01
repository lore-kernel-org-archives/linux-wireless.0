Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5E2C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B0BB21872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YQT90TMb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QyTLhXe+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfBAMn1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:43:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBAMn1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:43:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E02E060710; Fri,  1 Feb 2019 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549025005;
        bh=mpmjTV9AuSagNZPNKxBuAutMo7fUvzLU1oMqmEnRQc8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YQT90TMbushh4b27P3YtGnXVHcj5R5fUkVHl1200lWQQWN34/jkvhs50UnXW12NXy
         qvobkt/kJ7G3PoHghSPleVPMYZKw/V6LpdZBhWhFPnF6gDsupP8OQhLUTBnny/WdIY
         aBhQz2sFZMSmte4S4g8vHOtg9krG4DQ/1r3VLKx8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D50B960398;
        Fri,  1 Feb 2019 12:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549025004;
        bh=mpmjTV9AuSagNZPNKxBuAutMo7fUvzLU1oMqmEnRQc8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QyTLhXe+WOE8E9/45tYmuCoYuJ/VjXYmiHFCOEZ/KVHqWScialTDCERFY7r7zX4nn
         XRVS3GxuxCH0rcLB3CEadMWmbMaIsYZTvZRnJN38k9t789x32xo8FJahOQ6Uq2XQTL
         jc8ypnbj2M9Wc2o/jVIE7pyFU4jXyzGZfgp0YsRQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D50B960398
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: prefix header search paths with $(srctree)/
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548429480-22137-1-git-send-email-yamada.masahiro@socionext.com>
References: <1548429480-22137-1-git-send-email-yamada.masahiro@socionext.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     linux-wireless@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201124325.E02E060710@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:43:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> Currently, the Kbuild core manipulates header search paths in a crazy
> way [1].
> 
> To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
> the search paths in the srctree. Some Makefiles are already written in
> that way, but not all. The goal of this work is to make the notation
> consistent, and finally get rid of the gross hacks.
> 
> Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
> ("kbuild: do not drop -I without parameter").
> 
> I also removed one header search path in:
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
> 
> I was able to compile without it.
> 
> [1]: https://patchwork.kernel.org/patch/9632347/
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

030b43671ae8 wireless: prefix header search paths with $(srctree)/

-- 
https://patchwork.kernel.org/patch/10781533/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

