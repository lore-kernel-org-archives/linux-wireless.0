Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6CEC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 02:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE77E20B1F
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 02:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="btvW/T/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfBAC0w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 21:26:52 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33369 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfBAC0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 21:26:52 -0500
Received: by mail-pg1-f195.google.com with SMTP id z11so2230650pgu.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 18:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O2eLbNzI6dfO664ZwAbW1ZVV/y2lqu/xqh+covHml5E=;
        b=btvW/T/AfepRqVJOac1wdexZYtwHvZJSU/pfwZO3M2f8Z58d9EcryVSrprVkl79m2y
         pgaP53YrA8gkiHLEefNUJ5/tl3z5mFVCPUQwdpFJF5wP7em6Uo73ZMTyisoBGBKh9J/H
         Uw/KlMhSX4W8s0nGJtr/ZRJoPaxR6I7kRaZkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O2eLbNzI6dfO664ZwAbW1ZVV/y2lqu/xqh+covHml5E=;
        b=GgaG3+VZ7pgotce9HzDnkLHb6llYkP3Ceq/g7nPxQuzkOaA3mjNs69kjxM8umFOQGf
         FqILzrOMcygpw6GIxXxKmdLLyPq5RHOANPP9Q+plF95X+uLwnh9Js1D5VDNMj/SQSxDv
         byTJ8mQb9xf9xbyy8sz/8pY23upRu1OuE11F0rqfSaR4i5jwJPBDIUXKUvW93fcDKge0
         EdhOR3kbi/Wk96kdxhVBR9SefMGwcsdMac5gA973M//H2bV0hNVVV/3s7TESsRO8E4lG
         iZsilvXKVbzjLfCCyryDpaxx8htJfZdBh8VZWYBMixBsMPpD+kGgFdmmqtfIxZPZHT0W
         THqw==
X-Gm-Message-State: AHQUAuZtZ/EAs4vA+6SiwM+1hPP53+SQrT8Zr1bFKpL+mA8jlJ8H2z3P
        1zU1lvAoBNS4plsCZ+gKjo4OPg==
X-Google-Smtp-Source: AHgI3IZh3U8snYFjhKU6RLEq1x5FT8K5a2cCjV9JZ40lh6t8aMDrXVGXUX49vopF69ItAXA1z0JZbw==
X-Received: by 2002:a63:5346:: with SMTP id t6mr460786pgl.40.1548988011494;
        Thu, 31 Jan 2019 18:26:51 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id t13sm7060997pgr.42.2019.01.31.18.26.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 18:26:50 -0800 (PST)
Date:   Thu, 31 Jan 2019 18:26:48 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 07/24] rtw88: 8822c: update efuse table as released
Message-ID: <20190201022647.GA125494@google.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <1548937297-14660-8-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548937297-14660-8-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Thu, Jan 31, 2019 at 08:21:20PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Update efuse table layout as the document released.
> From the newest released document, 8822c has RFE type 1 and type 2.
> Without adding RFE 1 and 2 the user's efuse-programed chips will failed
> to pass the chip info check and cannot power on hardware.
> And 8822c has only 512 bytes for physical efuse.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 12 ++----
>  drivers/net/wireless/realtek/rtw88/rtw8822c.h | 53 ++++++++++++++-------------
>  2 files changed, 31 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> index 71f2af0..5c06e32 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c

> @@ -1137,7 +1133,7 @@ struct rtw_chip_info rtw8822c_hw_spec = {
>  	.tx_buf_desc_sz = 16,
>  	.rx_pkt_desc_sz = 24,
>  	.rx_buf_desc_sz = 8,
> -	.phy_efuse_size = 1024,
> +	.phy_efuse_size = 512,

I realized that technically, I'm blaming your memory errors (writing
past the phy efuse buffer) on the original patchset, when you really
create the error here, when you shrink phy_efuse_size.

Regardless, the original series should be fixed to do better bounds
checking or to stop accessing a fixed value beyond 512 anyway.

Brian

>  	.log_efuse_size = 768,
>  	.ptct_efuse_size = 124,
>  	.txff_size = 262144,
 
