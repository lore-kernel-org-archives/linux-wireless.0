Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4891DC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1028F21872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q06NTt8M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FwyY0h97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfBAMTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:19:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57666 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfBAMTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:19:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 86EC860710; Fri,  1 Feb 2019 12:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023571;
        bh=fWPh6MFniHA6zoL7Rnyz4O9I0kd5NBtH2WCWpEBME0Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Q06NTt8MquUXGQFm8PUTCn76ypk3CaiA6C1Fa7UyoOnDQQz6HueneQNiNopHetGbX
         VKNFIqvw2wKznDCCiZNCO69YQ3aiI0lkjUUZV4b0TDz9K8lyrMbMHJZxKxmQzsrW8L
         mDfJRrmxI2A5IJc+OnkLHP0mlPysWk1mVP9cFDyQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9EB186043F;
        Fri,  1 Feb 2019 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023571;
        bh=fWPh6MFniHA6zoL7Rnyz4O9I0kd5NBtH2WCWpEBME0Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FwyY0h9732CSWa9kq3tCEnpTEOrZ0czNa4nfM6/dzuEudhVKi9cJOhRqhTbjD7AAf
         GIC0V3l3HN2J5HNd4jinVOdNG8VbTbLaQfKE+yZvi3f5Wcm3mKJmnGjIt79JnZPm9R
         MV/1fzk0zuj1kzzxqQe+/QSnlf/rbMa1IRG7R+aU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9EB186043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: fix indentation issues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190117143623.29363-1-colin.king@canonical.com>
References: <20190117143623.29363-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201121931.86EC860710@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:19:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are two lines that have indentation issues, fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

b0535d502d18 cw1200: fix indentation issues

-- 
https://patchwork.kernel.org/patch/10768357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

