Return-Path: <SRS0=0mSa=WC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DD7C32751
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8DA02147A
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Aug 2019 12:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Hj0VxOaQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jfU8EUTy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbfHFMhb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:37:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfHFMhb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Aug 2019 08:37:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2BCC36074F; Tue,  6 Aug 2019 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095050;
        bh=ULaXsCHdpXk/9ASUvzQpHo0ujEuhZwPiBEwFY5gmZTU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Hj0VxOaQfOqhu+gcWbihujoKC/gFmJ996B9OUJ1iQqdPuLLGbT5gYwp5p6eXazk2U
         0ebAPqu3Znb0lT8koRhgUSmHofiy4Dyn42o/JGxtFHSLKisTUSb8eVMwQEE1sz/gT7
         bbtr27AdtV1kDwqbAn8icUag6pmzgCOCp+M/JWIc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A2076038E;
        Tue,  6 Aug 2019 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095049;
        bh=ULaXsCHdpXk/9ASUvzQpHo0ujEuhZwPiBEwFY5gmZTU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jfU8EUTyw7PKu2rzMrymC91mJ/Y6iH473HclG5PrZfOakeVzh0zaNwW7oqo3XZM0i
         W3Ah4Y4kUSRqIUM8IGoRgi1ppB6Jjldy3dQjuocmppedvHokWeQzC0Z6Usc7DFF7/5
         SSIIiFPoQEshZy7rLv8Akyttr/lWeD5U7TWArlH4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A2076038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: remove redundant assignment to err
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190726100614.6924-1-colin.king@canonical.com>
References: <20190726100614.6924-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123730.2BCC36074F@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:37:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable err is initialized to a value that is never read and it
> is re-assigned later.  The initialization is redundant and can
> be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

937a194ae865 ipw2x00: remove redundant assignment to err

-- 
https://patchwork.kernel.org/patch/11060715/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

