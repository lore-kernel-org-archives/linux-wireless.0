Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E16C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95805213F2
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 21:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UmVRVwOB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fti0GXXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfCSVBW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:01:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbfCSVBW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 17:01:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7986E60F3F; Tue, 19 Mar 2019 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553029281;
        bh=4NkBDu7Dwh4wk0TSBg687tjF/FZQKyLvHVNLHO+Xd+I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UmVRVwOBTIQqIfZT2vEnioUsFUs81NJ7aaHwotlEcCCWewbGxCD4gxFUwegTXaqgp
         5m2nsJR3kAvqnwtAMDYR9RDJp65GjL0fPRQcDgMAJeRbf2F0Wi/K7LO+ITiEMZQxFp
         0kRZGB0yDiwR/0cVGLPHTFHgx83jxC4uEo/0RqXM=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45E1160312;
        Tue, 19 Mar 2019 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553029280;
        bh=4NkBDu7Dwh4wk0TSBg687tjF/FZQKyLvHVNLHO+Xd+I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Fti0GXXtfpcgI3qqq8Ed+frTJsoB7S4A8rXDrd6yIn468aESIlLGGXggR11ONlvoz
         jUsz5vXjvhYHODCGCebwyY6ZY9Zo48h17XkQMVFHG8zciIbJnJIcNKpwhOfok0Hfu0
         MrRLNxq/bG0/giMn3e01MDl5pr1V5drdDpH6dmlI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45E1160312
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <yhchuang@realtek.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sgruszka@redhat.com>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v8 14/14] staging: rtlwifi: remove staging rtlwifi driver
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
        <1552450443-351-15-git-send-email-yhchuang@realtek.com>
Date:   Tue, 19 Mar 2019 23:01:16 +0200
In-Reply-To: <1552450443-351-15-git-send-email-yhchuang@realtek.com>
        (yhchuang@realtek.com's message of "Wed, 13 Mar 2019 12:14:03 +0800")
Message-ID: <87mulqtw83.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> writes:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
> series driver rtw88, remove it to avoid racing with the same ID.
>
> The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/staging/Kconfig                            |     2 -
>  drivers/staging/Makefile                           |     1 -
>  drivers/staging/rtlwifi/Kconfig                    |    12 -
>  drivers/staging/rtlwifi/Makefile                   |    70 -
>  drivers/staging/rtlwifi/TODO                       |    11 -
>  drivers/staging/rtlwifi/base.c                     |  2815 ----
>  drivers/staging/rtlwifi/base.h                     |   175 -

[...]

>  drivers/staging/rtlwifi/stats.c                    |   249 -
>  drivers/staging/rtlwifi/stats.h                    |    31 -
>  drivers/staging/rtlwifi/wifi.h                     |  3362 -----
>  183 files changed, 123718 deletions(-)
>  delete mode 100644 drivers/staging/rtlwifi/Kconfig
>  delete mode 100644 drivers/staging/rtlwifi/Makefile
>  delete mode 100644 drivers/staging/rtlwifi/TODO
>  delete mode 100644 drivers/staging/rtlwifi/base.c
>  delete mode 100644 drivers/staging/rtlwifi/base.h

[...]

> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -40,8 +40,6 @@ source "drivers/staging/rtl8712/Kconfig"
>  
>  source "drivers/staging/rtl8188eu/Kconfig"
>  
> -source "drivers/staging/rtlwifi/Kconfig"
> -
>  source "drivers/staging/rts5208/Kconfig"
>  
>  source "drivers/staging/octeon/Kconfig"
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 5868631..49e436f 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -10,7 +10,6 @@ obj-$(CONFIG_RTL8192E)		+= rtl8192e/
>  obj-$(CONFIG_RTL8723BS)		+= rtl8723bs/
>  obj-$(CONFIG_R8712U)		+= rtl8712/
>  obj-$(CONFIG_R8188EU)		+= rtl8188eu/
> -obj-$(CONFIG_R8822BE)		+= rtlwifi/
>  obj-$(CONFIG_RTS5208)		+= rts5208/
>  obj-$(CONFIG_NETLOGIC_XLR_NET)	+= netlogic/
>  obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
> diff --git a/drivers/staging/rtlwifi/Kconfig b/drivers/staging/rtlwifi/Kconfig
> deleted file mode 100644
> index 7b4276f5..0000000
> --- a/drivers/staging/rtlwifi/Kconfig
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -config R8822BE
> -	tristate "Realtek RTL8822BE Wireless Network Adapter"
> -	depends on PCI && MAC80211 && m
> -	select FW_LOADER
> -	---help---
> -	This is the staging driver for Realtek RTL8822BE 802.11ac PCIe
> -	wireless network adapters.
> -
> -config RTLWIFI_DEBUG_ST
> -	bool
> -	depends on R8822BE
> -	default y

This patch is huge and does not make it to the list because of the size.
Is there a way to optimise the size, any ideas? At least 'git
format-patch -M' or '-C' didn't help, just tried that.

-- 
Kalle Valo
