Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C61C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 23:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70AB4218DE
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 23:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CJVChc04"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfBZXbf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 18:31:35 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33412 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfBZXbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 18:31:35 -0500
Received: by mail-pl1-f193.google.com with SMTP id y10so7021899plp.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 15:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eZftrEl2TJJyeXw3guyXn2Erxve3Q0bY03ECyAZSZkA=;
        b=CJVChc04zJZUo3K33F3OsZQDaPAKKoTWxPs3ew9CDFaI+QdAV0Zz9utupNPjw66fh0
         60t5Uhv7rXVQxDz3sE+dgO1F8HHjDXWcFc074qe2B8O0x57vHqUQ4+4SH4jVkevTW9Pi
         NSQ0iXXV3VsMlpaebzt6XC+/0kY/8yaeBt3WQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eZftrEl2TJJyeXw3guyXn2Erxve3Q0bY03ECyAZSZkA=;
        b=HiULXuxn0pIjDFmym67I0CcFLeIElooH7R+GQxkzHLK3Yn5O1eBv7A4aYq50Mmj6MK
         5IhhXrrQYudbsr6HVk3D94pOfEEBDnMHZurQyRgIlPBbdYQvv5ThPshrgjzEJsZ73nMd
         y6R3mB/bPNv/QKmkj2cDKj/h0hQZNxeRBROjgtG1f9xGl6d4xQICgGAwNSiAijlRz3uu
         DnvTeWrHb9iGrurIsWl/ayv3DTILrZYL6J6uKTvlvbL/j1p/wDZ3RZOT6S1VAj6EUzJt
         yHJwcHb8uJ4scCthv+x/+PFa8d6Ahy+cqbFWc6WkvxAc7M1KAInleOrEwR4SW0s1rrhM
         bMmA==
X-Gm-Message-State: AHQUAuYQxJcNbQWbJXz2+rKcJSbnUHHx8310YLY+Wg7W2ztE4ZEBTq0D
        BMa0VGLHpNCkj9/qKXIDC3HsRw==
X-Google-Smtp-Source: AHgI3IYXSloYwmu732eq9VDlhsQrfMmwAMs1E83QJcex86P2fK0Dk80HaMPkiZGCK4hNwXQLdTNWhQ==
X-Received: by 2002:a17:902:b609:: with SMTP id b9mr29004600pls.134.1551223895038;
        Tue, 26 Feb 2019 15:31:35 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id x2sm22722798pfx.78.2019.02.26.15.31.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Feb 2019 15:31:34 -0800 (PST)
Date:   Tue, 26 Feb 2019 15:31:31 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN
 rather than disabling it too late
Message-ID: <20190226233130.GB174696@google.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
 <20190224140426.3267-4-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190224140426.3267-4-marc.zyngier@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Marc,

On Sun, Feb 24, 2019 at 02:04:25PM +0000, Marc Zyngier wrote:
> The mwifiex driver makes unsafe assumptions about the state of the
> wake-up interrupt. It requests it and only then disable it. Of
> course, the interrupt may be screaming for whatever reason at that
> time, and the handler will then be called without the interrupt
> having been registered with the PM/wakeup subsystem. Oops.
> 
> The right way to handle this kind of situation is to flag the
> interrupt with IRQ_NOAUTOEN before requesting it. It will then
> stay disabled until someone (the wake-up subsystem) enables it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

This could be:

Fixes: 853402a00823 ("mwifiex: Enable WoWLAN for both sdio and pcie")

although, that was just borrowing the existing antipattern from SDIO
code..

Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks.

> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 2105c2b7c627..82cf35e50579 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1610,6 +1610,7 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
>  			 "wake-up interrupt outside 'wake-up' subnode of %pOF\n",
>  			 adapter->dt_node);
>  
> +	irq_set_status_flags(adapter->irq_wakeup, IRQ_NOAUTOEN);
>  	ret = devm_request_irq(dev, adapter->irq_wakeup,
>  			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
>  			       "wifi_wake", adapter);
> @@ -1619,7 +1620,6 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
>  		goto err_exit;
>  	}
>  
> -	disable_irq(adapter->irq_wakeup);
>  	if (device_init_wakeup(dev, true)) {
>  		dev_err(dev, "fail to init wakeup for mwifiex\n");
>  		goto err_exit;
> -- 
> 2.20.1
> 
