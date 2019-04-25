Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771A8C43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD51206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b1RIx+Mo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P6HE5NAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfDYQmp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:42:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55176 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfDYQmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:42:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D29266077A; Thu, 25 Apr 2019 16:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210564;
        bh=dDlU680sfNkZ6mFUB0/9to0eOLdv1q/WmS0YAu/rZCg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=b1RIx+Moj81fnMgD7VaZwznpQkXHNbbngxxaPERclu46BXz6bJR3fIFwIZ9wgshkC
         NhkLtcoH1VLiULdF5cAXbQ7wPobBHHJf5gujYFgyIqkv0gOu8J+bqi62aWl9bmi3yu
         Z6iZMTTXKLr0P4Y70LyUC76ip+bVIjM9ryrEI3ZM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 987AF6034D;
        Thu, 25 Apr 2019 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210564;
        bh=dDlU680sfNkZ6mFUB0/9to0eOLdv1q/WmS0YAu/rZCg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=P6HE5NATeLx715tOwdK1RpFHfrvMZNz2qfm2xNE2bFhvSV8LAbjUyV1zF7sH9L8Xo
         G3M1qunAgq13/wp6edP2GbFaIR/waMl3uCzJqDTu0jKLeYvK1so5syJL4tbGyqrzDI
         svhMVGnATDbFZEDVccTp6LDJZ65ptG6h0YBeolxM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 987AF6034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rsi: Fix NULL pointer dereference in kmalloc
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190323204916.8368-1-pakki001@umn.edu>
References: <20190323204916.8368-1-pakki001@umn.edu>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     pakki001@umn.edu, kjlu@umn.edu,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164244.D29266077A@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:42:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aditya Pakki <pakki001@umn.edu> wrote:

> kmalloc can fail in rsi_register_rates_channels but memcpy still attempts
> to write to channels. The patch replaces these calls with kmemdup and
> passes the error upstream.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

d5414c2355b2 rsi: Fix NULL pointer dereference in kmalloc

-- 
https://patchwork.kernel.org/patch/10866983/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

