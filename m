Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D78C388F3
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 11:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D660921A4A
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 11:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dIZIpk9b";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Dff0axe8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfJALMK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 07:12:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfJALMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 07:12:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7514F6087B; Tue,  1 Oct 2019 11:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569928329;
        bh=9kO3QL+L5rr63Ix2ww95YvRUF57iILCa5Qi4MlOlhxM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dIZIpk9bKmKDhnfIWS9jfSnDm4DVoaXx77uUsEOO9K13B67BQkaKbnNxON+csseoV
         1JuCuFeooNuzQ/UYwecK8v2PitycNxQosak4+abcMAbpQUBVjMiBcU5V0RmV4QISwe
         hnAA74SgzCPkycDnXeqti/0dRhJdKlyUE+w2TBYk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4B91E6014B;
        Tue,  1 Oct 2019 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569928328;
        bh=9kO3QL+L5rr63Ix2ww95YvRUF57iILCa5Qi4MlOlhxM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Dff0axe8hdiOON+Jklx4brxGX76YkVHfkiIOQIY82uYhhIpU1BAIJ+ncj8fSYzaqM
         anWwISLIwCbpYPDEmfqvXp8TA6IO32F52uTrw/J8nUbDSQc4+34NZebE2beqryLLdl
         vQVfictCs0UzuZwbaG/naQM63KNlDtd68ZK8cAVY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B91E6014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: remove unused including <linux/version.h>
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190923135632.145051-1-yuehaibing@huawei.com>
References: <20190923135632.145051-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <ath9k-devel@qca.qualcomm.com>, <afaerber@suse.de>,
        <manivannan.sadhasivam@linaro.org>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001111209.7514F6087B@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 11:12:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6aff90c5bab7 ath9k: remove unused including <linux/version.h>

-- 
https://patchwork.kernel.org/patch/11156945/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

