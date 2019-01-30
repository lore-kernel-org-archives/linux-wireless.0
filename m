Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A2AC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 19:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076F02084C
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 19:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lpyGPyDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbfA3TpA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 14:45:00 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44063 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387664AbfA3TpA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 14:45:00 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so254814pgr.11
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 11:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ROiovBGzDbDhxgeLV0xiNGiWS32JROVNx2Gxd9GnKIE=;
        b=lpyGPyDwpwih0VX3evo1h+EBJh6J7yfutR4uiUcmUmerCcCdLur8cMf6vku5f74kAQ
         bXcOzf8kiG1h4Ug6Jajj0t+1jbw+lu18YC2614qaVYceWTev7Avg/0H8ENXY6YFFSP0F
         EwJi72kO8sNiiEvwen7m96X6efyJcT9JXKwyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ROiovBGzDbDhxgeLV0xiNGiWS32JROVNx2Gxd9GnKIE=;
        b=EDHqGlz59+t1zPJXZ7+lnyFlIXanRRyrRVCJYEwoHEGq2+l4ivvYV7amR+5+BjzTbU
         7HOg6mfFF5oBo7uTMRr5Q/LFIQm9DotR1/F3iyn96yux75tbooKtJSx6MWhMdcmV+t2K
         ymH3UJvQNaeLtncoY8+pePPwbBByDHUU7nYTB17pZKTYjCwI42hN7crB+wdGCbhHxcrp
         RdJQired+rVA3BXz/0rJgkN94Am3qJQ6bovSfh6qKNxPOCeSpF5gNRqTUXIi8j2Qb9sN
         tHmZjUhKZQx+9nB9m/sA43eBBAEo8ReZpV2abnRs3KhOhRPf2YkkZReNOZaWHpqkmtXV
         hG5w==
X-Gm-Message-State: AJcUukeLUgxBeRmELGdR9b+/MJfvDexAIGoF5TPSzQ+gJwQzUFRwdJpQ
        LGunCzfm8CTaeRvBxUVok/DdTA==
X-Google-Smtp-Source: ALg8bN7eQdzFxcghPLGqB4oesJXDkgLav7aes1wq89cgx1IFjy5M/VZGzaWckuur2Gl2cBnUJ4lcNg==
X-Received: by 2002:a62:1f97:: with SMTP id l23mr31360862pfj.13.1548877499062;
        Wed, 30 Jan 2019 11:44:59 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id m19sm6328581pgn.35.2019.01.30.11.44.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 11:44:57 -0800 (PST)
Date:   Wed, 30 Jan 2019 11:44:55 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 09/13] rtw88: chip files
Message-ID: <20190130194453.GA156750@google.com>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-10-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548820940-15237-10-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Jan 30, 2019 at 12:02:16PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> chip files Realtek 802.11ac wireless network chips
> 8822B & 8822C series files
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c      | 1590 ++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8822b.h      |  155 ++
>  .../net/wireless/realtek/rtw88/rtw8822b_table.h    |   18 +
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 1169 ++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8822c.h      |  171 +++
>  .../net/wireless/realtek/rtw88/rtw8822c_table.h    |   16 +
>  6 files changed, 3119 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> new file mode 100644
> index 0000000..0339041
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> @@ -0,0 +1,1590 @@
...
> +static inline void
> +rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
> +{
> +	BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);

This seems to be a non-traditional use of BUILD_BUG_ON(). Normally, I
see this used for stuff that's guaranteed to be known at compile time --
structure offsets, constants, etc. This is usually (always?) a constant,
but it passes through a function parameter, so I'm not sure if that's
really guaranteed.

Anyway...this is failing confusingly for me when I try to build:

drivers/net/wireless/realtek/rtw88/rtw8822b.c: In function ‘rtw_write32s_mask’:
drivers/net/wireless/realtek/rtw88/rtw8822b.c:230:176: error: call to ‘__compiletime_assert_230’ declared with attribute error: BUILD_BUG_ON failed: addr < 0xC00 || addr >= 0xD00
  BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);
                                                                                                                                                                                ^

I tried to pinpoint which call yielded this, and I think once I deleted
enough calls to rtw_write32s_mask() it came down to this one:

        rtw_write32s_mask(rtwdev, REG_RFEINV, BIT(11) | BIT(10) | 0x3f, 0x0);

which doesn't really make sense, as that's a value of 0xcbc.

What I really think it comes down to is that you can't guarantee
rtw_write32s_mask() will get inlined, and so BUILD_BUG_ON() may not know
what to do with it.

I think you should either drop the BUILD_BUG_ON(), or else turn
rtw_write32s_mask() into a macro.

BTW, I'm using a variant of gcc version 4.9.2. I normally use clang for
kernel builds (as that's the current Chromium OS toolchain), but clang
still regularly has breakage upstream, so I'm still building with an old
GCC toolchain. It's technically still supported in
Documentation/process/changes.rst though!

Brian

> +
> +	rtw_write32_mask(rtwdev, addr, mask, data);
> +	/* 0xC00-0xCFF and 0xE00-0xEFF have the same layout */
> +	rtw_write32_mask(rtwdev, addr + 0x200, mask, data);
> +}
> +
 
