Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF554C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A58F22147C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PBBZs1I9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="grcKCLoZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbfDDKPG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:15:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbfDDKPG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:15:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 28B0E61B5F; Thu,  4 Apr 2019 10:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372905;
        bh=Aic9mjr4Fu0bz73F3kwYVnpIctwrUwFjBAn9AkLBb04=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PBBZs1I9bhzRFzFp6wX/RVv0gYisjsu9J9BPp7xm1x6bA0rU8ss8dDVOhFWMy71NR
         Kq8P4y1vnWU9cXm5wqhnKJWJSC35ZRvAzbYoF7AbaOwGKHscd8OxEPaxuIkc84Zdcs
         SmSt1teRuDHfW6Ff4Coz22ouqojiTJjkYcQvDTrk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF0F461B51;
        Thu,  4 Apr 2019 10:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372903;
        bh=Aic9mjr4Fu0bz73F3kwYVnpIctwrUwFjBAn9AkLBb04=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=grcKCLoZzl1jKVTk3XSDBZmJ0pUFli9rJ24NRgrZPnk8nuXm3VJbYdp82S+1piVGM
         pU/N9h2MTqTzIZlCh2NIszGKEIOMwTS5Zx20CQF4kiIJoNoGPkC+CU9PLuWfXuUA6P
         NYHzLmDwtOwLZREZ5VY057GwEysbSrmxaYXMUmVY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF0F461B51
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlegacy: remove redundant assignment to *res
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190330201422.8024-1-colin.king@canonical.com>
References: <20190330201422.8024-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101505.28B0E61B5F@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:15:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently 1 is being assigned to *res and then it is immediately
> updated with the computed result.  The first assignment is
> redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Patch applied to wireless-drivers-next.git, thanks.

6603c5844a44 iwlegacy: remove redundant assignment to *res

-- 
https://patchwork.kernel.org/patch/10878565/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

