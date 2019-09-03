Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5872C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9E8233A1
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cF4EsaD1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mx1oOGdA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfICNzW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:55:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbfICNzW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:55:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 34A40602FE; Tue,  3 Sep 2019 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518921;
        bh=vpuAZkMQK2ZFS6tbmxl5dnvT1U76VTwXtsFnvAQ8SCU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cF4EsaD1Ppr50QyIHKwaV+hFeIHeWFrP2w50mOkX804W5poW+dY2Fs+NgVx3QTRr1
         hkg23xuWRrZgx6UPBqNY00MsAEfkLKMHifmpVlkC9IQ1Ly5GeY5F1pPdOwz+u3SC5u
         L6K5uGDdny0VWOwci0ePEKqwbzFcrCe2ABv3xh2A=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9ECA7602EF;
        Tue,  3 Sep 2019 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518920;
        bh=vpuAZkMQK2ZFS6tbmxl5dnvT1U76VTwXtsFnvAQ8SCU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Mx1oOGdAP3rS/RZz440W+Is4Z5hA243GvXV0Fb8/231frCMDhaKeLKEjKHgtxJNh5
         tapTvV5t1y2SruEM6oWFbffWlk7fmI0zcioQR+Mpl0SS2cG2WXSQqeEblyOEdFqA/t
         r5vwxxXRThxXtB77JTUJRxGAJTtSxVB2lddu5Q88=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9ECA7602EF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix a double free bug in rsi_91x_deinit()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190819220230.10597-1-benquike@gmail.com>
References: <20190819220230.10597-1-benquike@gmail.com>
To:     Hui Peng <benquike@gmail.com>
Cc:     security@kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903135521.34A40602FE@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:55:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hui Peng <benquike@gmail.com> wrote:

> `dev` (struct rsi_91x_usbdev *) field of adapter
> (struct rsi_91x_usbdev *) is allocated  and initialized in
> `rsi_init_usb_interface`. If any error is detected in information
> read from the device side,  `rsi_init_usb_interface` will be
> freed. However, in the higher level error handling code in
> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
> again, in which `dev` will be freed again, resulting double free.
> 
> This patch fixes the double free by removing the free operation on
> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
> used in `rsi_disconnect`, in that code path, the `dev` field is not
>  (and thus needs to be) freed.
> 
> This bug was found in v4.19, but is also present in the latest version
> of kernel. Fixes CVE-2019-15504.
> 
> Reported-by: Hui Peng <benquike@gmail.com>
> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> Signed-off-by: Hui Peng <benquike@gmail.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Patch applied to wireless-drivers.git, thanks.

8b51dc729147 rsi: fix a double free bug in rsi_91x_deinit()

-- 
https://patchwork.kernel.org/patch/11102087/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

