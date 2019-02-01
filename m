Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACAFC282DA
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB322084C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JCkz4yX5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VwE54XCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfBAMef (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:34:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfBAMef (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:34:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDD3D6090C; Fri,  1 Feb 2019 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024474;
        bh=qJdMUJDG90Pc5DHq3hM2PJSWLXs/f6uW5t/B0AK57Sc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JCkz4yX5YWYBzjlunyCf2RlUO202YM61grHOLStI11HuxDmHVX0lhNkFK/MLHrx8B
         3aljKbZXpRfiL6sjTbb4+gJ8BMaFbintXuxf45XAs/lGkeLMm0cjOsDNzF2gabuVZq
         HOgeAwIBOAf3zedZOejcdVeLC+ivo8z/fbM/gjzk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE3FC60392;
        Fri,  1 Feb 2019 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024473;
        bh=qJdMUJDG90Pc5DHq3hM2PJSWLXs/f6uW5t/B0AK57Sc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VwE54XCAGgcxVjlyEUdfgMami3+45O9TkoF4ofy9VSINqx9ypPjb52xQUc1UZsyV3
         rXH2unDcEYm8QsuxsTbTIdyD7s39XkjG33Ax/0ejvTm4x2/3/GZQ7d2/y4b23P12HZ
         g803F+Kr/SSafj93AWDyXV3epqjggS3UcgZfePzA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BE3FC60392
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-36-gregkh@linuxfoundation.org>
References: <20190122152151.16139-36-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201123434.CDD3D6090C@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:34:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Igor Mitsyanko <imitsyanko@quantenna.com>
> Cc: Avinash Patil <avinashp@quantenna.com>
> Cc: Sergey Matyukevich <smatyukevich@quantenna.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

b089e6944af3 qtnfmac: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775741/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

