Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52453C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 173A220882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F4tzFH/H";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YQOO2hQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfDDKUi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:20:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfDDKUf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:20:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 88B136188E; Thu,  4 Apr 2019 10:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373234;
        bh=3H35q8QomwdulxZrhu2wWqtDwoEfgMAFxuO+yex2lL8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=F4tzFH/HCZqHqAZj0gRvrazMe5N72YH3PtJDy6zHL9rOeDuhC8u9raIk5eX6+Qn/S
         4YKNE6nrw8Nei4tNVuSW4ufWKC+gJxx5jC/WfrBeP459amqedq8/78oGEjxWf+5PNT
         PSEYgJO+/peDVjGj3sSLLH1qTCVci1ZqY2WoUwMI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFFEB6115B;
        Thu,  4 Apr 2019 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554373232;
        bh=3H35q8QomwdulxZrhu2wWqtDwoEfgMAFxuO+yex2lL8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YQOO2hQ9mMRflP4es5DXHMmUKyzRK8xtPl36OX+/tK0KsE0SFyTX0dZIuOC1B1pRy
         QiQnN0J8E6bsLPkiJt2BE0OTeL4N0jVkZYjEk8HFHDkejHcImM1ilBr5EeuKzXluyW
         ZszWhZBfoQ0NuTreLoGQq6/pk6Pm3XG2NQX2WDYk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFFEB6115B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Fix potential NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190313184229.24780-1-pakki001@umn.edu>
References: <20190313184229.24780-1-pakki001@umn.edu>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     pakki001@umn.edu, kjlu@umn.edu,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404102034.88B136188E@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:20:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aditya Pakki <pakki001@umn.edu> wrote:

> dev_alloc_skb can fail and return a NULL pointer. The patch avoids
> a potential NULL pointer dereference and returns -ENOMEM.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

A similar patch was already submitted:

https://patchwork.kernel.org/patch/10848599/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/10851669/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

