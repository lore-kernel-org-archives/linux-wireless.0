Return-Path: <SRS0=8y3j=B4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06994C433E1
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Aug 2020 12:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA6A520706
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Aug 2020 12:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="aUkY2O2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgHRMvg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:51:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32079 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgHRMvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Aug 2020 08:51:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597755093; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2JdOswTmqkhfgTXPI/xi2S0NDW0ZKi6weRpD4CL01pQ=;
 b=aUkY2O2cVErE17AUC6N2IJiwgUUNV5EzDYMA3XFaxGRrQuZmAZVXYeCMHFMp+oohibScBDPP
 F+t0t9kJracfyFNDaETO95pI6GUKEeqVhovkNKyjTjhttuS0jfJIu0gIkZ8dYZJzSgRa3Xg7
 yb5enHsYDvoDMV54mhZoPekyFaI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f3bcecc03528d4024d3c798 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 12:51:24
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CCD43C4339C; Tue, 18 Aug 2020 12:51:24 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A43EC433CA;
        Tue, 18 Aug 2020 12:51:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9A43EC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: fix spelling mistake: "unsupport" -> "unsupported"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200806120803.60113-1-colin.king@canonical.com>
References: <20200806120803.60113-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200818125124.CCD43C4339C@smtp.codeaurora.org>
Date:   Tue, 18 Aug 2020 12:51:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are some spelling mistakes in rtw_info messages. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

86c96422a3b3 rtw88: fix spelling mistake: "unsupport" -> "unsupported"

-- 
https://patchwork.kernel.org/patch/11704489/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

