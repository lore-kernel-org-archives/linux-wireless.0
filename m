Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98059C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE9F2074D
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="qk4aZATU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgE2RQX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 13:16:23 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:64486 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgE2RQX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 13:16:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590772583; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=BGui0kTfIvgcz8lNEynqPe2IR/LmNWw9UsE5DP5ka5Q=;
 b=qk4aZATUuZszFNvJrv2NeTYvimEY+Ci+sg/YSxh8p1i9duNKO43viq8MMGqTrXqzoL/dnmu3
 MTHKwvwnYdL9+NZt/EdR74foOREKhwUTxWmnZ2JQ2nxwb9kVyxvustYUVwZj5jGG/R/vuHvY
 oxuPG9LS0FDo5djlTCr7ReakVZw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5ed14360ea0dfa490e7a61d4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:16:16
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13332C433CA; Fri, 29 May 2020 17:16:16 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2E91C433C9;
        Fri, 29 May 2020 17:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F2E91C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: Use shared constant for rfc1042 header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200523212628.31526-1-pterjan@google.com>
References: <20200523212628.31526-1-pterjan@google.com>
To:     Pascal Terjan <pterjan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pascal Terjan <pterjan@google.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529171616.13332C433CA@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:16:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pascal Terjan <pterjan@google.com> wrote:

> This is one of the 9 drivers redefining rfc1042_header.
> 
> Signed-off-by: Pascal Terjan <pterjan@google.com>

Patch applied to wireless-drivers-next.git, thanks.

729ef6b614a1 libertas: Use shared constant for rfc1042 header

-- 
https://patchwork.kernel.org/patch/11567011/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

