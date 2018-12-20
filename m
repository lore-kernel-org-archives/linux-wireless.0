Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36558C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0221520815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fqiw9E4X";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="C5FhPjyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbeLTRFo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:05:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34776 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbeLTRFn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:05:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1CE29607F1; Thu, 20 Dec 2018 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325543;
        bh=EFdDbBMyJGubmatNB3rfIvz1GBBWnOfFvSeFn62rjvA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fqiw9E4XSsQZrRg2jupnUqkqEjL3BXCutA0OVpsNOeS8DROoBzdY14zd28dE+Xu0r
         VAS6ml3Vgsjug6bD8jPsEzIcMyXWhPxetXN9G/YSiaZUYNZ0JeGOFt0S3S/EAY/6y/
         Cr3sGX0U7ZTzXxFwWdArGTmEbGNOriSFCV/zcsUI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 921826053B;
        Thu, 20 Dec 2018 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325542;
        bh=EFdDbBMyJGubmatNB3rfIvz1GBBWnOfFvSeFn62rjvA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=C5FhPjyY0kQQfj5GWKJ7Pnti8Zc0ohkQNcK9Uj3QTzM/jnzpPakMwJt7lULNkNe8m
         q2/w5B93RgX/DD6LTBBc0CM9srUFrcssXDwNU8r8p/IiaF5+SjerdIRxmPXhEwuwCW
         JCIjTzWtkVv39vQSaYXKTO+4mJ6uHFDXykdaOU0w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 921826053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix a NULL vs IS_ERR() check
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181126081143.tvu55aimdc3safcq@kili.mountain>
References: <20181126081143.tvu55aimdc3safcq@kili.mountain>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Govind Singh <govinds@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170543.1CE29607F1@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:05:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The devm_memremap() function doesn't return NULLs, it returns error
> pointers.
> 
> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c28dcbce0592 ath10k: fix a NULL vs IS_ERR() check

-- 
https://patchwork.kernel.org/patch/10697755/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

