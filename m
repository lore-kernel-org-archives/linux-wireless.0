Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D55C4151A
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57A0C21904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OVz/FzI7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PnEsIcAM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfBGO7d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:59:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGO7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:59:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3CA5B6085F; Thu,  7 Feb 2019 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551572;
        bh=Z1C5ishFsUA1aSXWI2Jt4SsgPdYgzjIk01Trv75yThI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OVz/FzI7Xvl+FaUfjWdw9frT3drXnrw1wkpNzfdxYZOmYkI8pAaj6IvEYvRdCs4iG
         kjVDc635pOTl3p82TSI9rBDYqaTpELsSyGNRa6Q6v4tYZiQiB9hhj5XZfMjsH2bYcG
         DOCoQ43xOoxVX6oBwCpcDGHjMbBpltgcb8Z16OUk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D33536085F;
        Thu,  7 Feb 2019 14:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551570;
        bh=Z1C5ishFsUA1aSXWI2Jt4SsgPdYgzjIk01Trv75yThI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PnEsIcAMYh+D2LqT9yVmMKd/SXxd1zovB/p9VXYYLs0chBj/9NqFn+yIzolopYoHu
         EmWCX94vEM+1Pa8jGYq2TouNfc0oiWbfvz2Ey5kX9fF6yQ9ggBY511m75RniJ2acPb
         /zN+ueoZnj7Go6Wlk7L7IPb77m9TEvatsemQw7x0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D33536085F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: do not return invalid pointers as a *dentry
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190131131625.GC19807@kroah.com>
References: <20190131131625.GC19807@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145932.3CA5B6085F@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:59:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, they can now return error values if
> something went wrong.  If that happens, return a NULL as a *dentry to
> the relay core instead of passing it an illegal pointer.
> 
> The relay core should be able to handle an illegal pointer, but add this
> check to be safe.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cd98625b3e3f ath9k: do not return invalid pointers as a *dentry

-- 
https://patchwork.kernel.org/patch/10790497/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

