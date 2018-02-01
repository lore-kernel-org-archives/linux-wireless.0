Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbeBAGjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 01:39:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 3/8] rsi: add header file rsi_header
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-4-git-send-email-amitkarwar@gmail.com>
Date: Thu, 01 Feb 2018 08:39:09 +0200
In-Reply-To: <1513168977-2121-4-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 13 Dec 2017 18:12:52 +0530")
Message-ID: <87y3kdmcxe.fsf@purkki.adurom.net> (sfid-20180201_073919_972568_63FAF41B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> The common parameters used by wlan and bt modules are added
> to a new header file "rsi_header.h" defined in '/include/linux'
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> diff --git a/include/linux/rsi_header.h b/include/linux/rsi_header.h
> new file mode 100644
> index 0000000..16a447b
> --- /dev/null
> +++ b/include/linux/rsi_header.h
> @@ -0,0 +1,34 @@
> +/**
> + * Copyright (c) 2017 Redpine Signals Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#ifndef __RSI_HEADER_H__
> +#define __RSI_HEADER_H__
> +
> +/* HAL queue information */
> +#define RSI_COEX_Q			0x0
> +#define RSI_BT_Q			0x2
> +#define RSI_WLAN_Q                      0x3
> +#define RSI_WIFI_MGMT_Q                 0x4
> +#define RSI_WIFI_DATA_Q                 0x5
> +#define RSI_BT_MGMT_Q			0x6
> +#define RSI_BT_DATA_Q			0x7
> +
> +enum rsi_host_intf {
> +	RSI_HOST_INTF_SDIO = 0,
> +	RSI_HOST_INTF_USB
> +};
> +
> +#endif

The name of the header "rsi_header.h" looks odd. The ".h" prefix already
tells that it's a header file, no need to repeat that in the filename.
But also calling it "rsi.h" feels a bit weird, it's not really very
specific. Would "rsi_91x.h" (from rsi_91x.ko) be any better?

Also I'm not sure about the location (include/linux), is that really the
correct place to have a header file shared by a wireless and bluetooth
driver? Anyone know? Or would include/net be better?

-- 
Kalle Valo
