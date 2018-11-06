Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AF7C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B6D82081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UxhGhHZx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KOICGed7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B6D82081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbeKGCTA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:19:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbeKGCTA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:19:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B70E261340; Tue,  6 Nov 2018 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523174;
        bh=pFqK8DpUnqtDlDwUvmbE79iVYPRHOBfAq5i697vTSzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UxhGhHZxYMITN2ttjUuro+WARz5BpUXoDQMTjojiU23WOfITilJkICO561DLAYSoB
         T8NgUiXfX2O4+wRFzhl3Z8F9zYeTX8MeJvcreIJD9if2FdKBw7baSoQLhR9mcAO+8o
         aJtx6tcHYwTbQrEGHEGCgmXeiqkUtv3ba37Tz3Rs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4390460ADB;
        Tue,  6 Nov 2018 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523173;
        bh=pFqK8DpUnqtDlDwUvmbE79iVYPRHOBfAq5i697vTSzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KOICGed7WrFa9Nw34SNOwemslI/ruezw6uoPkD7pDMIDrkfFOy3PK8K6A9AT+WlpB
         vwkPALvwnodsoVPixuL/2HCFp9NBBxFaJfqqqlXwt13TNnGXCircKKTDNTbjjIs8U6
         q0fgHWLXhRC0nOT6ZXKjwNFkMVz36Bw02woybLuE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4390460ADB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: remove set but not used variable 'int_type'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539569795-176889-1-git-send-email-yuehaibing@huawei.com>
References: <1539569795-176889-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Lubomir Rintel <lkundrak@v3.sk>,
        YueHaibing <yuehaibing@huawei.com>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165254.B70E261340@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:52:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/marvell/libertas/if_spi.c: In function 'if_spi_h2c':
> drivers/net/wireless/marvell/libertas/if_spi.c:799:6: warning:
>  variable 'int_type' set but not used [-Wunused-but-set-variable]
> 
> It never used since introduction in
> commit d2b21f191753 ("libertas: if_spi, driver for libertas GSPI devices")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Tested-by: Lubomir Rintel <lkundrak@v3.sk>

Patch applied to wireless-drivers-next.git, thanks.

937a13091cbd libertas: remove set but not used variable 'int_type'

-- 
https://patchwork.kernel.org/patch/10641005/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

