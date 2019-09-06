Return-Path: <SRS0=iVws=XB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA10C43331
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 14:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AAE920842
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 14:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JnloefoC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jg1K+GVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394074AbfIFOOD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Sep 2019 10:14:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731142AbfIFOOD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Sep 2019 10:14:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5AFDB611BE; Fri,  6 Sep 2019 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779242;
        bh=3ruqwPYWVSYqYOsjQ64IZ3mnFFhJcbOC6J9E06sf3bo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JnloefoCEofMRpOJLt3NOydkjbnVKdAe/JZfNvP12iV3eTyVYDOUC3SluJ2Xj4TUT
         ulEUtw7BqGgNnh6PsE776gGdzKt8UtObOyTD9UqzGSb9tomZYT95Ei1nVZi9cbVzWB
         v7DeAPto1Px0l4MIPxcaS0azDZtSvvlpnFg7oRdE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 522E46115B;
        Fri,  6 Sep 2019 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779241;
        bh=3ruqwPYWVSYqYOsjQ64IZ3mnFFhJcbOC6J9E06sf3bo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jg1K+GVnOLs9rqBcjGM2veO8FdUlQk7du7eY/b1pUpv4ohMMb2O0lzIJDPNxJISjF
         QzaKqyDW/uekniRgP11/PqYig4WFoAm6KAtLHr/sFyGiSfhVHlrsx/3EJ26NS2aT2G
         8iCeYzS1I7npvNquw9NTQr1QrszxAShTIzV6FApA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 522E46115B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] hostap: use %*ph to print small buffer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190904174321.76826-1-andriy.shevchenko@linux.intel.com>
References: <20190904174321.76826-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190906141402.5AFDB611BE@smtp.codeaurora.org>
Date:   Fri,  6 Sep 2019 14:14:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied to wireless-drivers-next.git, thanks.

290890df5a8a hostap: use %*ph to print small buffer

-- 
https://patchwork.kernel.org/patch/11131157/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

