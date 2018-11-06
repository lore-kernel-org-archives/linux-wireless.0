Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196EAC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E0B20862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RDRQh52F";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fPv3ZjaS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3E0B20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbeKGB1H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:27:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388346AbeKGB1H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:27:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDC1760767; Tue,  6 Nov 2018 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520074;
        bh=qFX/oxqrdi4Z9gLVqUmiHbFvrr1vEfSyeAxFV0YvZUk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RDRQh52FBnUNLxg4SBd9yYD8Win/s3g1vtQqRv6ROQ1YH7t8VZaC2Vh7MBtdKbAR2
         E71F9WvtmALdxB5sghGV6wZpZ0KsFrXs0pG2R96dpvoFwEVssBoTpadrBeG7uCL4IY
         21twDfYhHJv4ZrnPkCWgjwS9Dg6JRK9BM8U/qOxM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CF54601DA;
        Tue,  6 Nov 2018 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541520074;
        bh=qFX/oxqrdi4Z9gLVqUmiHbFvrr1vEfSyeAxFV0YvZUk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fPv3ZjaS3WoNkiTEzFx/yTIZHWPcm/f7rgTp3ycZQ192bT8M+pgtuR9yNsdu5SDhN
         Opk3wfJTzRhaTLwl/cxAtWHXZ+iM49WecLleYmP/IEKAxKzW4thPuor6kyOeTVLLKV
         4Z7L39i/fbuPZWHETMW8JaUiLYzwcf2yXleYJHxc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CF54601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix some typo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181101152932.22684-1-tiny.windzz@gmail.com>
References: <20181101152932.22684-1-tiny.windzz@gmail.com>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106160114.CDC1760767@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:01:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> wrote:

> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c8cb09644c6c ath10k: fix some typo

-- 
https://patchwork.kernel.org/patch/10664139/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

