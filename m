Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558CAC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24CE720863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hgbxsvAE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZNNEf+Yg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfBAMfO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:35:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfBAMfN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:35:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 39C37608C5; Fri,  1 Feb 2019 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024513;
        bh=0sI0euyTGw+E6A5rQ0i7QmjjPspKb6IOD+d5EqlPj/E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hgbxsvAELoQTS3cGb4N4a7Ejmqz8eiXnYkmwXhwBJFikz+gCR1hUAufPSNkDojcBv
         cNstj0GzF9AorVJYKIbuGD4m4xsiTyPaVpBlK38Lr+tzkVi230nBOtFP5W8w0TOsSn
         ltw/xH3kGXhRHtlkKgzmaNB99VH7KzLa87+8RaCU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE5346043F;
        Fri,  1 Feb 2019 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024512;
        bh=0sI0euyTGw+E6A5rQ0i7QmjjPspKb6IOD+d5EqlPj/E=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZNNEf+YgU7usxcIM7tqS1f9+wI13xFsHfieeJHMGM7YIhaRfmV2TlYgMTfONlkE+e
         Ly/0Ll3IEZ/UqSw2lcBKD/dpFOYxmeXR2Kq4SoYYDMi2pToB/zZ6LuHzIqqu3omOe7
         znTym8a9nHxoOtcxinYPD4FgjZpr1H33verlpCcU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BE5346043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-29-gregkh@linuxfoundation.org>
References: <20190122152151.16139-29-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201123513.39C37608C5@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:35:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Solomon Peachy <pizza@shaftnet.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Patch applied to wireless-drivers-next.git, thanks.

80f4c5e3662a cw1200: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775783/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

