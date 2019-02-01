Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9477DC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 01:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609DD2085B
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 01:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cFGq+x/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfBABYw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 20:24:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41473 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfBABYw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 20:24:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id m1so2144355pgq.8
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 17:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gZkuzVs+OsPj2ZKyI0PZZqXRVLw+omp58C/4dYLtu5U=;
        b=cFGq+x/WiP5J51b4NnF1qcDkSHbuc4haw2n1/FeB3uAmuDrFPOdECDVW+XqbhvW8Lr
         NGL4H6m6SaGYp292QwtXHOec0Q2iKks5OuZv3hArc24iWorYGz5CLQ2UNfNztLGtg1yI
         d2/RYr0U35xoX6EW8JZpKA0bxWKKPSapMRPO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gZkuzVs+OsPj2ZKyI0PZZqXRVLw+omp58C/4dYLtu5U=;
        b=lS44R0kUcahFVtzjIP6dJDQPTImLSw2LUVX3IB/0aITtbPuYOZbt1k6b4ORndYXcGe
         /LS2H4eLIfPHFkA+x2w8Jb++E69HmjUGuzn18uKfNWR9EZLtOt/9zMOCTmFPf5PBiv/L
         LZj0KxsS3hf0lLyWA3/uWIb30UlZtst2rw96iWhOJhA/7M0f3SNNuImg4sI/F6Ib7gw/
         +3xaKrRsJbliMktibR5RfD2J1lO3XGY5eEroBaJvumiNQPzKq7xQUAxJciwOhn1tMrQ8
         zg0VC68KpnBNr1iMYY0wpVVW4gaFyER3gS+WCGQyoqtNsk0na3wuhBDAaHhCypM6WBrJ
         2WvQ==
X-Gm-Message-State: AHQUAua0EIhriHFXElDK70t7Li/419356ZGhopY0AqMi1WLDhXukkj72
        Oo/PNoMJUgl/pEGGHSaIXTe5tw==
X-Google-Smtp-Source: AHgI3Iaykd3GiBoERe7ACXi6/dB/wIabQnL94Bo+Q9+ftsaWQqMBrfI7ngxxHtbhXm1ft2KZjyBMEw==
X-Received: by 2002:a65:4381:: with SMTP id m1mr275368pgp.358.1548984291042;
        Thu, 31 Jan 2019 17:24:51 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id t90sm12115353pfj.23.2019.01.31.17.24.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 17:24:50 -0800 (PST)
Date:   Thu, 31 Jan 2019 17:24:48 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 24/24] rtw88: 8822b: turn rtw_write32s_mask into macro
Message-ID: <20190201012446.GA103846@google.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <1548937297-14660-25-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548937297-14660-25-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Thu, Jan 31, 2019 at 08:21:37PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> The inlined rtw_write32s_mask has to check range of addr with
> BUILD_BUG_ON. But with some variants of gcc version the function might
> not get inlined, and it will have no idea to know how to do, then
> results in a compile error. Turn it into a macro to make sure the values
> are known when compile time.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c | 10 ----------
>  drivers/net/wireless/realtek/rtw88/rtw8822b.h | 15 +++++++++++++++
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
...
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> index 311fe8a..4cf193b1 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
> @@ -97,6 +97,21 @@ struct rtw8822b_efuse {
>  	};
>  };
>  
> +static inline void
> +_rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
> +{
> +	rtw_write32_mask(rtwdev, addr, mask, data);
> +	rtw_write32_mask(rtwdev, addr + 0x200, mask, data);
> +}
> +
> +/* 0xC00-0xCFF and 0xE00-0xEFF have the same layout */

Feels like this belongs with _rtw_write32s_mask() now, not here?

> +#define rtw_write32s_mask(rtwdev, addr, mask, data)			       \
> +	do {								       \
> +		BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);		       \

You probably want parentheses around the 'addr'. You *probably* won't
run into trouble with this particular macro, but if the caller is doing
the wrong kinds of comparisons or arithmetic, this might not work they
way you want.

Brian

> +									       \
> +		_rtw_write32s_mask(rtwdev, addr, mask, data);		       \
> +	} while (0)
> +
>  /* phy status page0 */
>  #define GET_PHY_STAT_P0_PWDB(phy_stat)                                         \
>  	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
> -- 
> 2.7.4
> 
