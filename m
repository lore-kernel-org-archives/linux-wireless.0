Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6418EC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 19:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A67F21872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 19:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SB55rl5O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfBATtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 14:49:45 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41419 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfBATtp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 14:49:45 -0500
Received: by mail-pf1-f195.google.com with SMTP id b7so3714968pfi.8
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 11:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=41svM6nb2hsXTCWDE1VCSPT5zBxHfHBX5w927AXx21Q=;
        b=SB55rl5O7TdnW1UOZ7cg9eodr9VWXXJZNt70mWX4I4oFMvEnAuDaxr4tduNdemSu/y
         fgbVYgasAo0fc39Yv35Nc3IHHpFMWI3f7s0KFM0Qe5SaogQUzyOynINYmjQ4IL4qZs7v
         /Lr/Bg838NTusGpd6lruvzkCySJovhax0U/84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=41svM6nb2hsXTCWDE1VCSPT5zBxHfHBX5w927AXx21Q=;
        b=rw7FyVlvnCdySktXToCFe0ouLHgDgcUMYvd0FFb4a4LidG9MwyWp50ARPB4ZpEnLn7
         DhkpHMF9LjKEF5QWKuZYoZOQmA4/84HHrVmZSdyW5vxPuJmcj+euiiEpg4x61bk26FFf
         oY1vbgVvGrp6P5ICprZj48Y2/fsOX2aM2LrmEyLxHA4Hl3fxCIRCD9jSn+oRGtV/SkbQ
         vkrsy1SZO00kAda+vWMEcJnkNGnSGCmWMSO+qpyGZ7o/TkwTpiqEIxaihv34FlK5S36D
         7djN99vyFTz1JAE+vl5yvRqYd1t/9vkfimC1aaVJbCO7MQRRHISvHsFAlhhbkU9C9sJe
         GOkQ==
X-Gm-Message-State: AJcUukfu2puFDwecZ9/qBV4qBP9C0Mcm6UTAcYjXIpQReB3CIZZ6qfbC
        yYsYC3HuQSbt88Y0Yk19UaE1fA==
X-Google-Smtp-Source: ALg8bN5sRaShbTZyZTxTUjNqUXJIAV49Ty3T/Cv3np8/6hb01spJeIp6x/jWG9HYdK0ily9WB5ukbg==
X-Received: by 2002:a62:4e83:: with SMTP id c125mr41168961pfb.101.1549050584025;
        Fri, 01 Feb 2019 11:49:44 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id e2sm5543027pga.92.2019.02.01.11.49.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 11:49:42 -0800 (PST)
Date:   Fri, 1 Feb 2019 11:49:40 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 08/13] rtw88: debug files
Message-ID: <20190201194938.GA98048@google.com>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-9-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548820940-15237-9-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Jan 30, 2019 at 12:02:15PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> debug files for Realtek 802.11ac wireless network chips
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/debug.c | 631 +++++++++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/debug.h |  35 ++
>  2 files changed, 666 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/debug.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/debug.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
> new file mode 100644
> index 0000000..d0cb9d3
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/debug.c
> @@ -0,0 +1,631 @@

...

> +#ifdef CONFIG_RTW88_DEBUG
> +
> +void __rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...)
> +{
> +	struct va_format vaf = {
> +		.fmt = fmt,
> +	};
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	vaf.va = &args;
> +
> +	if (net_ratelimit())
> +		dev_dbg(rtwdev->dev, "%pV", &vaf);

I understand some questions came up about this dbg() interface
previously, without the most constructive result, but...

...I do find one particular aspect of this interface a little weird: it
has its own separate Kconfig flag, and yet it's still implicitly
dependent on CONFIG_DYNAMIC_DEBUG. Note how dev_dbg() gets completely
stubbed out if !defined(CONFIG_DYNAMIC_DEBUG) && !defined(DEBUG).

I think some other similar loggers end up just using
dev_printk(KERN_DEBUG, ...) for this piece of the equation, so that if
somebody has bothered to enable CONFIG_RTW88_DEBUG, they can be sure
their log messages are at least compiled in.

But then, other drivers that have used dev_printk() *also* have dynamic
methods to enable/disable their dbg-level messages (e.g., with a 'mask'
module parameter, for classifying different types of messages). That
also gives us the option of compiling in the messages while leaving them
disabled for printing by default. IOW, they basically implement a
categorized version of CONFIG_DYNAMIC_DEBUG.

(Also note: my systems generally have DYNAMIC_DEBUG disabled, but we
*do* like to have a few driver-specific debug options enabled for WiFi,
so we can debug problems in the field via runtime enable/disable.)

Altogether, I think this means you should either:

 (a) alias RTW88_DEBUG with DYNAMIC_DEBUG (e.g., RTW88_DEBUG selects or
     depends on DYNAMIC_DEBUG?) or, remove your own special Kconfig
     entirely; or
 (b) implement runtime controls to enable/disable your dbg() messages,
     and do not depend on DYNAMIC_DEBUG

I kinda lean toward (b), since that's how many other WiFi drivers work,
and it prevents me from having to enable all of DYNAMIC_DEBUG (although,
it may be time to reevaluate why Chrome OS has it disabled...probably
just for mild savings on size). It also gives you the option of
classifying your debug messages even further.

Regards,
Brian

> +
> +	va_end(args);
> +}
> +EXPORT_SYMBOL(__rtw_dbg);
> +
> +#endif /* CONFIG_RTW88_DEBUG */
> diff --git a/drivers/net/wireless/realtek/rtw88/debug.h b/drivers/net/wireless/realtek/rtw88/debug.h
> new file mode 100644
> index 0000000..231e4e8
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/debug.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018  Realtek Corporation.
> + */
> +
> +#ifndef __RTW_DEBUG_H
> +#define __RTW_DEBUG_H
> +
> +#ifdef CONFIG_RTW88_DEBUGFS
> +
> +void rtw_debugfs_init(struct rtw_dev *rtwdev);
> +
> +#else
> +
> +static inline void rtw_debugfs_init(struct rtw_dev *rtwdev) {}
> +
> +#endif /* CONFIG_RTW88_DEBUGFS */
> +
> +#ifdef CONFIG_RTW88_DEBUG
> +
> +__printf(2, 3)
> +void __rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...);
> +
> +#define rtw_dbg(rtwdev, a...) __rtw_dbg(rtwdev, ##a)
> +
> +#else
> +
> +static inline void rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> +
> +#endif /* CONFIG_RTW88_DEBUG */
> +
> +#define rtw_info(rtwdev, a...) dev_info(rtwdev->dev, ##a)
> +#define rtw_warn(rtwdev, a...) dev_warn(rtwdev->dev, ##a)
> +#define rtw_err(rtwdev, a...) dev_err(rtwdev->dev, ##a)
> +
> +#endif
> -- 
> 2.7.4
> 
