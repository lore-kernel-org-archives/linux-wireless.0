Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A9DC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6064820863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SWhPaQ9F";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bld/M84Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfBAMfl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:35:41 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51060 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfBAMfl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:35:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8F7F260590; Fri,  1 Feb 2019 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024540;
        bh=6EWF/u9WZeQGTL4HM/Akfy0Tbw471i/0XAE1Um+lXSE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SWhPaQ9F09q9LHm+jHbhNolaVVwS/xeoCL4zNlQwQFGaV9jjbFSHlXVIpKffvo7oP
         qs7XQh85ZH7LJTIuK7C4TA9c+G4FvaCR5VCRegDJ4W0pnDLcSyGD/9juYgxG+9B9dK
         cgN2iaRsjXmgC3kLIPHz1BkxqXuccSul4O20pf1g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2B9960392;
        Fri,  1 Feb 2019 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024540;
        bh=6EWF/u9WZeQGTL4HM/Akfy0Tbw471i/0XAE1Um+lXSE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Bld/M84Q3wu1t4A6qdIOTWeFg91aXsDLywtOAk9pymFtp8Wesm+xbger6l82qWNHM
         BsdF1ti/4pBTbB2iAlT4vZTc2CMaM9NYEo8WqCsvFUpDfpuxYteNaj3ZpQLA0fhSBQ
         eM3mHyyxUgPetbbIgxumXqoCTabajCnEIrTB4FW8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F2B9960392
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-30-gregkh@linuxfoundation.org>
References: <20190122152151.16139-30-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201123540.8F7F260590@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:35:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

e9bdcdc7cdf0 b43: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775733/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

