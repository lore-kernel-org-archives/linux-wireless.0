Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7504CC3A5A7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2D72087E
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rj3jWCV9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hgBpb1Hg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfICNoV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:44:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICNoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:44:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6A8D9608FF; Tue,  3 Sep 2019 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518260;
        bh=S87jAdIzNJ4HJS3B9OrtK4jGRfZUJGaxJeLtOQb91mQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Rj3jWCV9W2rtqmJW/rgg9ZrCunRclUAtqk40oYfOg/2218FudtqQypWGYLCoz7NYF
         VVKIJcWY4wMGeNuDUmsOrHozH1bm1RaW6SAmgE+uyXtgrDo73h+vTrfa6AK4xjH635
         PsJClmtm8EMcivC3KuKmxzE6rsCDPL1HAggSmb5U=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B72D060592;
        Tue,  3 Sep 2019 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518259;
        bh=S87jAdIzNJ4HJS3B9OrtK4jGRfZUJGaxJeLtOQb91mQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hgBpb1HgXrKmujql76Xuq3Pp1dqWDkpNs1e9aiihdaXjALsugTkDO5wpShGRKL4Ij
         Nr7W/qVo9kGZGnDU8n2/W0AAZbEgKm/gCkBhmzRxX93zYbUfYZPY1xhFaUQRSzILrn
         NbfSfLSqrmLFFIlw/HMX3KmvKyLPd4C+GwF3LDpM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B72D060592
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][V2] bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190827081620.20998-1-colin.king@canonical.com>
References: <20190827081620.20998-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903134420.6A8D9608FF@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:44:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> An earlier commit re-worked the setting of the bitmask and is now
> assigning v with some bit flags rather than bitwise or-ing them
> into v, consequently the earlier bit-settings of v are being lost.
> Fix this by replacing an assignment with the bitwise or instead.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 2be25cac8402 ("bcma: add constants for PCI and use them")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

420c20be08a4 bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA

-- 
https://patchwork.kernel.org/patch/11116317/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

