Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA001C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B24208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ozxAked3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E9HNdly/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89B24208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbeJAUcN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:32:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAUcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:32:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 88D9260B7A; Mon,  1 Oct 2018 13:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402058;
        bh=h9TrJKkulq3XtSXVb5WcJsx2fNqpmsQhnUPRyv3JIAU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ozxAked3G3NXbWdC108IsF57TkmnKsqSujm/+68xn8FwnjYPQySG7loNSE8o8x/kw
         T8n1KEKKTkIgiiXkfgykEz11umjPf1Haj3ccf9GeE/m9VJkf9k+NDfzzFsnwl8Q2ID
         qeetUU7DGbEmz3pxi+t2njqTmREnrJqbv5zM/li8=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0829A6079B;
        Mon,  1 Oct 2018 13:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402057;
        bh=h9TrJKkulq3XtSXVb5WcJsx2fNqpmsQhnUPRyv3JIAU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=E9HNdly/C143VS/Z1RluXZr8uHGzcQj/jerGgYbZbW7PocUrzJ+8ra9QCoo8is/Im
         u7M77ymqaP8snaugYLhDer1MMkLlVScMSWKBILvD9Y/7BtzASphQ9T98yapjZUBvOG
         CXWRv5TXqM/swJN4BTEkNMrDof+VLYdZKe2D3oQ0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0829A6079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: utilize random MAC address if none is provided
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180907172157.203785-1-briannorris@chromium.org>
References: <20180907172157.203785-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001135418.88D9260B7A@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 13:54:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> Since commit 9d5804662ce1 ("ath10k: retrieve MAC address from system
> firmware if provided"), we support pulling our MAC address from system
> firmware. Along with this, we should admit that it's possible for system
> firmware to be screwed up as well, omitting the MAC address there.
> 
> Provide a fallback, such that we choose a randomly-generated MAC
> address, with the local assignment bit set.
> 
> This is not a preferred mode of operation and really should only serve
> the purpose of keeping the system chugging along while someone figures
> out what's wrong with the system. Grepping through other wireless
> drivers shows very similar fallback logic though, so why not?
> 
>   git grep eth_random_addr drivers/net/wireless/
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

234e4307cf7f ath10k: utilize random MAC address if none is provided

-- 
https://patchwork.kernel.org/patch/10592411/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

