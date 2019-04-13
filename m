Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FC6C282DA
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0E3F20850
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YkJ1s7nQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="for+cnyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfDMLD0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 07:03:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfDMLD0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 07:03:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 156F461786; Sat, 13 Apr 2019 11:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555153405;
        bh=nZL2BL0AzTzvR5gi44kn2G1BM0TT7rS2aq+pThuRUes=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YkJ1s7nQKWGDMYkqsIhjlCxGYU4QJUihEXibHTP3O8rbpjjKYf4CR9OEYF5KvT4yI
         Dik+yzAXlXBNkLGIU2B+uDlT9O1YKoD8YlMnSxS7fn6aavFWPa5g8llwr4UbKjp+U2
         Wn9bFK3fsWJKVEJhephiLAwYaaIQbEI0y8IodvbQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB0B761577;
        Sat, 13 Apr 2019 11:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555153404;
        bh=nZL2BL0AzTzvR5gi44kn2G1BM0TT7rS2aq+pThuRUes=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=for+cnybbQ9F+eaJt7MSYntNDed8wBKQVgHWLm7QOhko4rcI2fjHQ4psiy7y77U3j
         EwZ+xSA9Gmoj7guuK7MgjihNKID2MxJCnTgCJiNR9gE0iyVJ4ddknps8vDhLI+Nxuu
         cOtPhqxIRREDd891CnNfjRz39vDHjlJXXnnVYpCg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB0B761577
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] brcmfmac: Use struct_size() in kzalloc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403164611.GA29107@embeddedor>
References: <20190403164611.GA29107@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190413110325.156F461786@smtp.codeaurora.org>
Date:   Sat, 13 Apr 2019 11:03:25 +0000 (UTC)
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
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)
> 
> Notice that, in this case, variable reqsz is not necessary,
> hence it is removed.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

0cf83903aad0 brcmfmac: Use struct_size() in kzalloc()

-- 
https://patchwork.kernel.org/patch/10884189/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

