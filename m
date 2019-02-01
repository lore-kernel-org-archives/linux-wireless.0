Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7D5C282DA
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0532082C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eBZUzt6V";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e0PzUqNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfBAM3V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:29:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfBAM3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:29:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8E6056085C; Fri,  1 Feb 2019 12:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024160;
        bh=XH6qd2simHY6ZzfvkK2miwkLnMU6psaH77/IMHUcd3w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eBZUzt6V98CfN4LmXVyvXx078AaX/vWD4m8f5NmBqgEbnuPqEiS2ccVSLIzuDx/CB
         ZRUcrhmmXbe0wiehg4jUsaUJWNLcMOXL50Ci4bZfwmycaytQRMDXdn9Zr6+zZJ9NgP
         53Plzq0kYjKKhkMI4DP5ldhZVKmLo/D2NHU98DLY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2017F6043F;
        Fri,  1 Feb 2019 12:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024160;
        bh=XH6qd2simHY6ZzfvkK2miwkLnMU6psaH77/IMHUcd3w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=e0PzUqNd0xxEkFdmB0HiunKh4I5qd4xeNFZn8Hg4sUHE5UriS4IqpG/JYNJpTt7re
         bDGGBxKNDdvCeLX5WhYYr72IkyMObrHxXqW/7xv0/CyyHgADtKj0bLjPkfdZwMqbg+
         2xtn0MBZ0Bc0rAjNhF72KqfWopNECD6rAU/6h7YQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2017F6043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlegacy: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-19-gregkh@linuxfoundation.org>
References: <20190122152151.16139-19-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201122920.8E6056085C@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:29:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

71ee1284d626 iwlegacy: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775803/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

