Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54248C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21DC2206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YBQsv4R3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JVQGS4tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfDDQi7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:38:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfDDQi7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 12:38:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 946856079C; Thu,  4 Apr 2019 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554395938;
        bh=SKPAo48buD7X8AxyJfUMlxADDAoJ1X9bfMPOhEFlKtc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YBQsv4R3fqCKm3RYkj/6nEU8UBkZhhGSZ9jysQRxhf22IdO+ONKyUnG8n4pcPRNwu
         A8TM7ZWIJzG5Ffwj5xLgb8ApZJde/Q81u08Tu2uJy4tue3joHh+Ox1PhNpXgw77NK9
         3mXGE5pGOYw7kvrbn6IKk+uebJt6Cr8N5Eut33cM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5303960790;
        Thu,  4 Apr 2019 16:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554395936;
        bh=SKPAo48buD7X8AxyJfUMlxADDAoJ1X9bfMPOhEFlKtc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JVQGS4trrTNaXS8flNloqNGoNaUbaq67SdXvpmOrQCUjHo+REVgZ3FOCxU6awzGY8
         4ZY70m0qP1tE+hGSJMkNNUC0fOMUBUekzwzMA4m6ydFL5yrSP5kOI2d/h4BSj9BOQs
         SjimriR31LUtTTjfcM0CtFW0rf8GLjJq6IX0qnr4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5303960790
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] qtnfmac: replace qtnf_cmd_acl_data_size() with
 struct_size()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403170236.GA31637@embeddedor>
References: <20190403170236.GA31637@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404163857.946856079C@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 16:38:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct foo {
>     int stuff;
>     struct boo entry[];
> };
> 
> size = sizeof(struct foo) + count * sizeof(struct boo);
> instance = kzalloc(size, GFP_KERNEL)
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> size = struct_size(instance, entry, count);
> 
> or
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)
> 
> Based on the above, replace qtnf_cmd_acl_data_size() with the
> new struct_size() helper.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

95336d4cb588 qtnfmac: replace qtnf_cmd_acl_data_size() with struct_size()

-- 
https://patchwork.kernel.org/patch/10884311/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

