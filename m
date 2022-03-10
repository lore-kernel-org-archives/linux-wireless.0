Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E9DC433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Mar 2022 16:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241672AbiCJQio (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Mar 2022 11:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbiCJQin (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Mar 2022 11:38:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B2F154D3E
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2022 08:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1F04ECE2322
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2022 16:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA12C340E8;
        Thu, 10 Mar 2022 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646930257;
        bh=tkl2Gv8z0xh1xHVJ7v2MaeHUyHKe7f5z0P9c4cE7bhw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mY7WxbylAtLywfNf0bbYRKoKqs0lC42N1eC8uvOTQI2Ym9V75b3K9ISphvdcs2wwl
         EoryNFBxexNnqx4w2XcSBUBps6yeWnP4k6pyEEQZPZNMYxXOi9qjU4dZ0ALXBd7MRF
         HGBvJabEveuvscGBdYylfWfEyDzxhYjfxYx9ykL+zdr8FPpSmCQYAGr4umQ6gAX2cg
         UYfsSwkli5ZL3aJ3PS/QN4V7iHlyEqgCvae34HhYiBoJaDbjkoCREnAaruaJuu4XMs
         qOJzNzf+q3mN1g3P8XOiZ02C7X4Xr2dBXnSQC+Tp139adO9dzAybwqQhx+Pt39TGR1
         zbBetwNTZxLrA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 10/13] rtw89: 8852c: add chip::dle_mem
References: <20220307060457.56789-1-pkshih@realtek.com>
        <20220307060457.56789-11-pkshih@realtek.com>
Date:   Thu, 10 Mar 2022 18:37:32 +0200
In-Reply-To: <20220307060457.56789-11-pkshih@realtek.com> (Ping-Ke Shih's
        message of "Mon, 7 Mar 2022 14:04:54 +0800")
Message-ID: <87k0d1rcfn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

> These tables are used to configure hardware buffer size according to
> operating mode.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw89/core.h     |  1 +
>  drivers/net/wireless/realtek/rtw89/mac.c      | 62 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw89/mac.h      | 10 +++
>  drivers/net/wireless/realtek/rtw89/reg.h      |  1 +
>  drivers/net/wireless/realtek/rtw89/rtw8852c.c | 12 ++++
>  5 files changed, 86 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
> index 2dc19b530db62..207ac7e605691 100644
> --- a/drivers/net/wireless/realtek/rtw89/core.h
> +++ b/drivers/net/wireless/realtek/rtw89/core.h
> @@ -2168,6 +2168,7 @@ struct rtw89_ple_quota {
>  	u16 bb_rpt;
>  	u16 wd_rel;
>  	u16 cpu_io;
> +	u16 tx_rpt;
>  };
>  
>  struct rtw89_dle_mem {
> diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
> index df657df6b1493..0081cfbfea042 100644
> --- a/drivers/net/wireless/realtek/rtw89/mac.c
> +++ b/drivers/net/wireless/realtek/rtw89/mac.c
> @@ -1183,6 +1183,18 @@ const struct rtw89_dle_size rtw89_wde_size4 = {
>  };
>  EXPORT_SYMBOL(rtw89_wde_size4);
>  
> +/* 8852C DLFW */
> +const struct rtw89_dle_size rtw89_wde_size18 = {
> +	RTW89_WDE_PG_64, 0, 2048,
> +};
> +EXPORT_SYMBOL(rtw89_wde_size18);
> +
> +/* 8852C PCIE SCC */
> +const struct rtw89_dle_size rtw89_wde_size19 = {
> +	RTW89_WDE_PG_64, 3328, 0,
> +};
> +EXPORT_SYMBOL(rtw89_wde_size19);
> +
>  /* PCIE */
>  const struct rtw89_dle_size rtw89_ple_size0 = {
>  	RTW89_PLE_PG_128, 1520, 16,
> @@ -1195,6 +1207,18 @@ const struct rtw89_dle_size rtw89_ple_size4 = {
>  };
>  EXPORT_SYMBOL(rtw89_ple_size4);
>  
> +/* 8852C DLFW */
> +const struct rtw89_dle_size rtw89_ple_size18 = {
> +	RTW89_PLE_PG_128, 2544, 16,
> +};
> +EXPORT_SYMBOL(rtw89_ple_size18);
> +
> +/* 8852C PCIE SCC */
> +const struct rtw89_dle_size rtw89_ple_size19 = {
> +	RTW89_PLE_PG_128, 1904, 16,
> +};
> +EXPORT_SYMBOL(rtw89_ple_size19);

How much memory does does one EXPORT_SYMBOL() take? There are a lot of
symbols exported now, and some of them have just four values. Wouldn't
it make more sense to have only one exported structure which contains
all the smaller structures?

You could consider this as a separate cleanup.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
