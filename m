Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C24EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B53B20700
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ehr//CuH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mkkZ4wrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfBSPRf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:17:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45406 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfBSPRf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:17:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3820560388; Tue, 19 Feb 2019 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589454;
        bh=ZKWY61OHVlLtZbcsEdIOMMrJHTua+ODCxFDAgFM80/k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ehr//CuHdm06D8xFcodDBHcaE3BzS5cxu+8ME/cBH3ZzZWU0q/OpBuwzNA+kIalXV
         WsSyk9z5p4vV01a+q2cKBH/7k+rOZjheqTaRLkGrEFSM3ETDzgJrr4J8iOVFiVYsfJ
         RxWt/TH+ebw0HxBsjBbbZ2NbeeBRYORuM6eEw85M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 77AE660388;
        Tue, 19 Feb 2019 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589452;
        bh=ZKWY61OHVlLtZbcsEdIOMMrJHTua+ODCxFDAgFM80/k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=mkkZ4wrHea6p9IBUoORJ1MJlBufoK1HrlvqVwJgIBmGeI2A+ZuuRbJ+L58mjjLVhc
         h9NGZDmr0+kUU76wh43yJcCMyAHmnX+nR7wHz66a9sCo8pAJMgd+Tp1taTUgKBlheB
         jF/32c6jF8xA913J96+AjOERYOf5HM2qVyGBxEq0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 77AE660388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] orinoco : Replace function name in string with __func__
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190217162548.18257-1-iamkeyur96@gmail.com>
References: <20190217162548.18257-1-iamkeyur96@gmail.com>
To:     Keyur Patel <iamkeyur96@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) iamkeyur96@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)iamkeyur96@gmail.com
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151734.3820560388@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:17:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Keyur Patel <iamkeyur96@gmail.com> wrote:

> From: Keyur Patel <iamkeyur96@gmail.com>
> 
> Replace hard coded function name with __func__, to
> improve robustness and to conform to the Linux kernel coding
> style. Issue found using checkpatch.
> 
> Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

25f87d8b63b8 orinoco : Replace function name in string with __func__

-- 
https://patchwork.kernel.org/patch/10817203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

