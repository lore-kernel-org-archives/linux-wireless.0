Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9A0C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 09:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AABC8205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 09:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EjVaaQx0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aN4n385L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbfDDJ24 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 05:28:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbfDDJ2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 05:28:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 58765614B5; Thu,  4 Apr 2019 09:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554370134;
        bh=0Kvu+k7olBLdhhfbWZY3bUkOtIN9a4rTe3VpQTjAPjQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EjVaaQx078VvzlNQl2b5s2/9X8zkexxkwgEtpngYr3E6k9geQTaQCeeQ93HNyaX17
         4/euP7z5cb5Wwww+RB/B+W8+cdELCKWUBIkmGZWH6QkWLHpNI87cxqANt81mW2yEKr
         oh7/lbnOWD1MvsyMD/+33FPmVkG5jy1ZZwKoBRhw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F01FD619D2;
        Thu,  4 Apr 2019 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554370133;
        bh=0Kvu+k7olBLdhhfbWZY3bUkOtIN9a4rTe3VpQTjAPjQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aN4n385Lh+W/3/LzSNhVU5wJ6Z2+OGOKrRAO883iCXKB7oIj7FWx1cVOezreYQaH3
         TGDC83wB04rQeIh11droL4epwSpBF26xr9k0wXJlgJFCsh+aPPNSCwxtRJQLGJSdfe
         NJb2k+WNXzLFM6F+sq1Z/msxOHeJKfmg6ES4MyZU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F01FD619D2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] net: mwifiex: fix a NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190323035711.23882-1-kjlu@umn.edu>
References: <20190323035711.23882-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404092854.58765614B5@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 09:28:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
> NULL pointer dereference.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

There is a similar patch submitted:

https://patchwork.kernel.org/patch/10851669/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/10866749/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

