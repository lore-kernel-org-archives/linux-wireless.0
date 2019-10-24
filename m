Return-Path: <SRS0=l1pt=YR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B416CA9EBC
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Oct 2019 05:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FEC120679
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Oct 2019 05:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AJ9i8ntd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fDV7FIwv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408485AbfJXFsZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Oct 2019 01:48:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbfJXFsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Oct 2019 01:48:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2F52060B6E; Thu, 24 Oct 2019 05:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896104;
        bh=9xfFYo0OwH9yxo1xzsgyupR8IvI/OSOKlVUq7Vey1jI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AJ9i8ntd0hXx7Q2uIyrff/OJ1aqWx+/IizHg5sJN7N0of+Kft5vaZlAkVRMaP4Vja
         ha95IbygbA6TeLJ042pAXZJrR0MOO8DcYlEXhtI8oM6gXnuzIG8HfgCI00j6IWpVc0
         IvzxJLJRj1bv+9YhUaBPXOHiBwEp5hNX92gJOPkE=
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CB2260B6E;
        Thu, 24 Oct 2019 05:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896102;
        bh=9xfFYo0OwH9yxo1xzsgyupR8IvI/OSOKlVUq7Vey1jI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fDV7FIwv08wlJxfohk4iuWL8phzYJzhGOstoE/nfQ4LglDLPaGZRBnTeFbmZQQ1WR
         cMtLp+ORDIcrWyQCN444zgWYQbzuyXWZmxbRZ+LOMNaixGiEdJg9NAGmjrK9/UQnQ3
         Pi88kuLUmL7rHLUjU/ICEirSqPDdtRQ6sSVj09c8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CB2260B6E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] adm80211: remove set but not used variables 'mem_addr'
 and 'io_addr'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023073842.34512-1-yuehaibing@huawei.com>
References: <20191023073842.34512-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <yuehaibing@huawei.com>,
        <kstewart@linuxfoundation.org>, <allison@lohutok.net>,
        <info@metux.net>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191024054824.2F52060B6E@smtp.codeaurora.org>
Date:   Thu, 24 Oct 2019 05:48:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/admtek/adm8211.c:1784:16:
>  warning: variable mem_addr set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/admtek/adm8211.c:1785:15:
>  warning: variable io_addr set but not used [-Wunused-but-set-variable]
> 
> They are never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

f64b06bd362a adm80211: remove set but not used variables 'mem_addr' and 'io_addr'

-- 
https://patchwork.kernel.org/patch/11205833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

