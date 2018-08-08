Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727187AbeHHLno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 07:43:44 -0400
Date: Wed, 8 Aug 2018 11:24:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
Message-ID: <20180808092450.GA25772@redhat.com> (sfid-20180808_112508_538070_EBFFE4C0)
References: <20180807225040.GA2164@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180807225040.GA2164@beast>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 07, 2018 at 03:50:40PM -0700, Kees Cook wrote:
> Even with "const" variables, the compiler will generate warnings about
> VLA usage. In the quest to remove all VLAs from the kernel[1], this uses
> a #define instead of a const to do the array sizing.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Fixes: e87b5039511a ("mt76x0: eeprom files")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Please include this for the v4.19 merge window. The VLA was introduced
> with the new source file (which I also note is missing a SPDX line), so

I thought SPDX line is needed only if file has no license and eeprom.c
file and other mt76x0 files have specified the license. Is SPDX still
needed in that case ?
 
> +#define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
>  static int
>  mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
>  {
> -	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
> -	u8 data[map_reads * 16];

Why this is variable length array? DIV_ROUND_UP can not be calculated
at compile time? But if so, macro do not change the situation either.

Thanks
Stanislaw
