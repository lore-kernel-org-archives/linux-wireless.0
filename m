Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FCCECE589
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 09:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6786721920
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 09:13:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Uapre/Kw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ji0zxpIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733256AbfJAJNw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 05:13:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfJAJNw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 05:13:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3E25F608CE; Tue,  1 Oct 2019 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921231;
        bh=ceLRdOBekgc/KQVTfBLRZE1LgI2EFl5Zshh2kmXZHbg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Uapre/KwW3pyIU0rWjuiRLmBZTIvtnx9sFIiKDA19/cyR8fWYTn17CNwM4rHx0PW4
         wMGpvPbY8WhjMuo02K17YfVlK1btISHJZhIATaht07nf3KUCr+ZjNERbTcgHyPp3R+
         vr75IOB+dE4QfrEoQTr5mL9tc26UzK808m7z865c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF034608CE;
        Tue,  1 Oct 2019 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921230;
        bh=ceLRdOBekgc/KQVTfBLRZE1LgI2EFl5Zshh2kmXZHbg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ji0zxpISp/m33foHKf7RDYQNVifM2HdP4nJ6R2IaN4vwDt2oI4tlHDzLztUxBu/to
         BcE3Ew/b8oOu8yyNgBt+cXfZAyHqL2cxLVARFW/aAh+APFyUaEuYjxVVnqF0CYgqQ8
         IdPldpOvrTprYLFAlP7GmcYW7TkH251CvgYmQEq0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF034608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove a useless test
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190915193210.27357-1-christophe.jaillet@wanadoo.fr>
References: <20190915193210.27357-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001091351.3E25F608CE@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:13:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> 'pih' is known to be non-NULL at this point, so the test can be removed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

3f1b32bdbb0a brcmsmac: remove a useless test

-- 
https://patchwork.kernel.org/patch/11146089/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

