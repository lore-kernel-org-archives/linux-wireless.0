Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C48BC43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04342206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gcrv6Ej+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P9kwccC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfDYQyL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:54:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:54:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F37A860275; Thu, 25 Apr 2019 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211250;
        bh=Xmbd/wLGRR77Qhjh48yYlXdd8nsn1itpws0+qZykH9M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gcrv6Ej+9lC/KDTi1Fp+eQtuAe/Oh0Mx3hCQe3WXrPhTJAXsYkO89H5RK1jnDAmwQ
         L45Iy1qb/1W9iRg6OxEsO1ty+QV4qJf/KDm4R6e7jpwlcuHCSeCjVsQzF+fuThKHHU
         ZLSIshYlOyYuyi3UBZeqP99KQnptbneq68XoZwzo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B1DC6019D;
        Thu, 25 Apr 2019 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211249;
        bh=Xmbd/wLGRR77Qhjh48yYlXdd8nsn1itpws0+qZykH9M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=P9kwccC5sDuP3URvfvZTJVjQfmvud4khdHRpO6hi6mmi06n8EiDKsmYfg47COT2JN
         8nHWPYCal++LqEJjzc5lLaf5/iL5IrT1kOaRhVYUfVz8wAmcsNwZbcgbiSGOFF9wh+
         9jlm8Lux4LU5qe7IzNecsld6kC+Zb7p3bXfJIMuA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1B1DC6019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] mwifiex: add support for SD8987 chipset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190414183641.7539-2-tszucs@protonmail.ch>
References: <20190414183641.7539-2-tszucs@protonmail.ch>
To:     =?utf-8?b?VGFtw6FzIFN6xbFjcw==?= <tszucs@protonmail.ch>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:MARVELL MWIFIEX WIRELESS
        DRIVER), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>,
        =?utf-8?b?VGFtw6FzIFN6xbFjcw==?= <tszucs@protonmail.ch>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165409.F37A860275@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:54:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tamás Szűcs wrote:

> This patch adds support for Marvell 88W8987 chipset with SDIO interface.
> Register offsets and supported feature flags are updated. The corresponding
> firmware image file shall be "mrvl/sd8987_uapsta.bin".
> 
> Signed-off-by: Tamás Szűcs <tszucs@protonmail.ch>

Patch applied to wireless-drivers-next.git, thanks.

938c7c80c78e mwifiex: add support for SD8987 chipset

-- 
https://patchwork.kernel.org/patch/10899927/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

