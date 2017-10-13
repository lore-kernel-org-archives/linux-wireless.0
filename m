Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbdJMKBB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 06:01:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: fix integer overflow warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171005120547.328687-1-arnd@arndb.de>
References: <20171005120547.328687-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171013100100.B7A2F605A5@smtp.codeaurora.org> (sfid-20171013_120131_356204_AD017BC3)
Date: Fri, 13 Oct 2017 10:00:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> gcc produces a harmless warning about a recently introduced
> signed integer overflow:
> 
> drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_prepare_mgmt_desc':
> include/uapi/linux/swab.h:13:15: error: integer overflow in expression [-Werror=overflow]
>   (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
>    ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
> include/uapi/linux/swab.h:104:2: note: in expansion of macro '___constant_swab16'
>   ___constant_swab16(x) :   \
>   ^~~~~~~~~~~~~~~~~~
> include/uapi/linux/byteorder/big_endian.h:34:43: note: in expansion of macro '__swab16'
>  #define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
>                                            ^~~~~~~~
> include/linux/byteorder/generic.h:89:21: note: in expansion of macro '__cpu_to_le16'
>  #define cpu_to_le16 __cpu_to_le16
>                      ^~~~~~~~~~~~~
> drivers/net/wireless/rsi/rsi_91x_hal.c:136:3: note: in expansion of macro 'cpu_to_le16'
>    cpu_to_le16((tx_params->vap_id << RSI_DESC_VAP_ID_OFST) &
>    ^~~~~~~~~~~
> 
> The problem is that the 'mask' value is a signed integer that gets
> turned into a negative number when truncated to 16 bits. Making it
> an unsigned constant avoids this.
> 
> Fixes: eac4eed3224b ("rsi: tx and rx path enhancements for p2p mode")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

a39644b235c1 rsi: fix integer overflow warning

-- 
https://patchwork.kernel.org/patch/9986961/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
