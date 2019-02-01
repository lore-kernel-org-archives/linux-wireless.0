Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26DAC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81688218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Stp95fr5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YvVdYrOh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfBAMGJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:06:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbfBAMGJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:06:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2BE8760987; Fri,  1 Feb 2019 12:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549022768;
        bh=mS7NyLsT5/SEIMxk+pthUQ7i8BR86RL8PTs+v+zcWeU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Stp95fr5XK9k29HWgid+oPGkC5n1bZJJFf7gUH2GPdhtAJZlNz3qibsYmFhE58Bzf
         pUviKBLFDvbsakUrN4M9WCtWsaDhTXDWlJW6pU2U/msGJtELkkJBnS0McEWfUnkFBY
         cu/KB2WoT589KWfqtM6JqRZf9mauog+gPbC2bV90=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EFB6160A5F;
        Fri,  1 Feb 2019 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549022766;
        bh=mS7NyLsT5/SEIMxk+pthUQ7i8BR86RL8PTs+v+zcWeU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YvVdYrOhgV576x9I+eh6lcUZVWb8J3HufV7QGrdiMP38042DZdHS72K4G9Ua6RdCm
         UPgYpPRHPFj/jxQUGo2FT6ltHZfj2TQp3ba4xTMGnaEoB5Ky19Sg3j3EEtRng0sQSh
         sZy3CmLoZdd5VG7MEKl+/LD3AaJu1gYOysQHGdDA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EFB6160A5F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: use struct_size() in kzalloc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190108172632.GA2918@embeddedor>
References: <20190108172632.GA2918@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201120608.2BE8760987@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:06:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> One of the more common cases of allocation size calculations is finding the
> size of a structure that has a zero-sized array at the end, along with memory
> for some number of elements for that array. For example:
> 
> struct foo {
>     int stuff;
>     void *entry[];
> };
> 
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can now
> use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

db040dfa53e2 qtnfmac: use struct_size() in kzalloc()

-- 
https://patchwork.kernel.org/patch/10752601/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

