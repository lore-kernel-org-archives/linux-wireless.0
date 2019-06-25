Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6414C48BD4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 05:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0BD8205F4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 05:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g8q3VGp1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="V5p1ezBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfFYFCa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 01:02:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFYFCa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 01:02:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 244DE606DC; Tue, 25 Jun 2019 05:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438949;
        bh=fPT0gT7LS22qEGFkJrHhbQkhxQmWqS5gE1kUD0/5/H8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=g8q3VGp1tr0QDZF9rNCKoWqG7xbbAF4pZuqVe8tXdme3jXVPGQ4owqQDWd2njWDcS
         DVDgqoucYmhbC/+Lzjj1eWRpnt6JevRwTJY0EJ0zC0RplnwmEAqLqEo6D3PCKHv4NZ
         SKAL55wTdePh1GbQh/RAQUDY5Uy9VtCzqmD/pQyk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A14096025A;
        Tue, 25 Jun 2019 05:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438948;
        bh=fPT0gT7LS22qEGFkJrHhbQkhxQmWqS5gE1kUD0/5/H8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=V5p1ezBB0o9dKOdCKPQYJz3VLZPGKjVuETJPXKr5Ude6LO3dQGTGHKcHmfcuqpWip
         R7iFQRaiH6NQuHi1tW3+LiiiXsE0KDUWG/PTz5T1g0o2e35D+nhgGEbRUvW/y/l9CR
         chh2N3H10elK86aErU1jvw42RUvVuh8Pp2+cDflE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A14096025A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8188ee: remove redundant assignment to
 rtstatus
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190608105800.26571-1-colin.king@canonical.com>
References: <20190608105800.26571-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625050229.244DE606DC@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 05:02:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable rtstatus is being initialized with a value that is never read
> as rtstatus is being re-assigned a little later on. The assignment is
> redundant and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

25a986e426b0 rtlwifi: rtl8188ee: remove redundant assignment to rtstatus

-- 
https://patchwork.kernel.org/patch/10983111/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

