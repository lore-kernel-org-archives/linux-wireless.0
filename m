Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49261C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 117BB218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CbkBWxmh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o3BXHvXA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbfBAMGv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:06:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbfBAMGv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:06:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A02C96085C; Fri,  1 Feb 2019 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549022810;
        bh=jJUGDm2iBVBatavz4bCZcmAU/8nqL4hV1kpeNu/5JJA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CbkBWxmhB9q2cMzrDdLf2rRWDYf33gKgm0tTuQ6+DpMw2jdHYVo6K5Yvc1UwRgaf5
         JJFW9zsFjuM98cYr6f+svTUBgl/sXf9viXHnRvYae1uOYuICOGAPt1hPX737wAmaAt
         qLJBgGpTBNdYxIuHhP3pjq69NPjT/d1hJ2qIp1Gs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C939B6043F;
        Fri,  1 Feb 2019 12:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549022809;
        bh=jJUGDm2iBVBatavz4bCZcmAU/8nqL4hV1kpeNu/5JJA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=o3BXHvXAshSHo1nIH/Qi0KHhn0VR4QwgdyWtQcZZL1+9vQNoY6QhRabcgdh91lPrs
         Kcr7NrD+A4AGsyPaf7AFl9RDjRF16d/zIAiP/ft7iSijJUAvD2HSWcz0Eo1zJplWt7
         prbTFXZdjbKTOTLyB5YRinVZJ+dHZQqVs44OxgrA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C939B6043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] libertas: add checks for the return value of
 sysfs_create_group
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190108174222.29121-1-kjlu@umn.edu>
References: <20190108174222.29121-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201120649.A02C96085C@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:06:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> sysfs_create_group() could fail. The fix checkes its return values
> and issue error messages if it fails.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

434256833d8e libertas: add checks for the return value of sysfs_create_group

-- 
https://patchwork.kernel.org/patch/10752631/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

