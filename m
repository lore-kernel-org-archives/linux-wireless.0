Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61977C433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394702065F
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="v05PjHC6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgE2Rks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 13:40:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:50310 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgE2Rks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 13:40:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590774047; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=UXXBbJcWAQNE1ZNglKbbAUXpi4LDBG4fZpZm8mlyhPk=;
 b=v05PjHC6gwI5cZDtY9w98OAbawwPs6de1UH8brXt90bIcOc6eiOY+m47GcO4/9qaNX6hpLlj
 XEaLE992+vndwOYKYfN2i8lMPBfBRDKmA6zawq6avzbgH1Y0EAbaQEaSVh0nRSTp0vKpM8y+
 kt2qHppRKIQqbyMuqM4w6k1QkdY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5ed14917b65440fdba15c1f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:40:39
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6EC21C433C6; Fri, 29 May 2020 17:40:38 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6F27C433C9;
        Fri, 29 May 2020 17:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6F27C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] airo: Fix read overflows sending packets
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200527184830.GA1164846@mwanda>
References: <20200527184830.GA1164846@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Hu Jiahui <kirin.say@gmail.com>,
        Eric Dumazet <edumazet@google.com>, security@kernel.org,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529174038.6EC21C433C6@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:40:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The problem is that we always copy a minimum of ETH_ZLEN (60) bytes from
> skb->data even when skb->len is less than ETH_ZLEN so it leads to a read
> overflow.
> 
> The fix is to pad skb->data to at least ETH_ZLEN bytes.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Hu Jiahui <kirin.say@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Patch applied to wireless-drivers-next.git, thanks.

11e7a91994c2 airo: Fix read overflows sending packets

-- 
https://patchwork.kernel.org/patch/11573765/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

