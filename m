Return-Path: <SRS0=yPAo=EN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7173C388F7
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Nov 2020 16:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8DF820885
	for <linux-wireless@archiver.kernel.org>; Sat,  7 Nov 2020 16:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kzrVmlMN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgKGQD3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 7 Nov 2020 11:03:29 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:36244 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgKGQD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Nov 2020 11:03:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765007; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=zhW9Fd9ECWVPXgVZt9v7ksfzG/0je0jsdG/rHWmN6bI=;
 b=kzrVmlMNiLcZZq7fqVo925bh3hHB2NFcWvujDOtW2Vphzbysij3i77b/jMlXaAEmrp9LD0fm
 nPGSIUDx4K+iGR49FL1dZnSZmUzH9FqB6bdEdoPdv4rjXc9BJSZ2ztT02UtrNN22XBkj+Q21
 NHojGdQYMeUuvbje756bGEIuqtw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fa6c53cf8c560b580b7f692 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:03:08
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A9A9C433C9; Sat,  7 Nov 2020 16:03:07 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBB2CC433C8;
        Sat,  7 Nov 2020 16:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBB2CC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [02/41] rsi: rsi_91x_usb: Fix some basic kernel-doc issues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201102112410.1049272-3-lee.jones@linaro.org>
References: <20201102112410.1049272-3-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107160307.5A9A9C433C9@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:03:07 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/rsi/rsi_91x_usb.c:26: warning: cannot understand function prototype: 'u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL; '
>  drivers/net/wireless/rsi/rsi_91x_usb.c:88: warning: Function parameter or member 'endpoint' not described in 'rsi_write_multiple'
>  drivers/net/wireless/rsi/rsi_91x_usb.c:88: warning: Excess function parameter 'addr' description in 'rsi_write_multiple'
>  drivers/net/wireless/rsi/rsi_91x_usb.c:320: warning: Function parameter or member 'ep_num' not described in 'rsi_rx_urb_submit'
>  drivers/net/wireless/rsi/rsi_91x_usb.c:320: warning: Function parameter or member 'mem_flags' not described in 'rsi_rx_urb_submit'
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

2 patches applied to wireless-drivers-next.git, thanks.

f21e6c5822f2 rsi: rsi_91x_usb: Fix some basic kernel-doc issues
63636b385e39 rsi: rsi_91x_usb_ops: Source file headers are not good candidates for kernel-doc

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201102112410.1049272-3-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

