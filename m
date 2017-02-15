Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdBOFt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 00:49:58 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2500usb: don't mark register accesses as inline
References: <20170214212846.2809141-1-arnd@arndb.de>
Date: Wed, 15 Feb 2017 07:49:38 +0200
In-Reply-To: <20170214212846.2809141-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 14 Feb 2017 22:28:33 +0100")
Message-ID: <8760kcovf1.fsf@kamboji.qca.qualcomm.com> (sfid-20170215_065053_483336_0C3F6785)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> When CONFIG_KASAN is set, we get a rather large stack here:
>
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c: In function 'rt2500usb_set_device_state':
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1074:1: error: the frame size of 3032 bytes is larger than 100 bytes [-Werror=frame-larger-than=]
>
> If we don't force those functions to be inline, the compiler can figure this
> out better itself and not inline the functions when doing so would be harmful,
> reducing the stack size to a merge 256 bytes.
>
> Note that there is another problem that manifests in this driver, as a result
> of the typecheck() macro causing even larger stack frames.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

[...]

> -static inline void rt2500usb_register_multiread(struct rt2x00_dev *rt2x00dev,
> -						const unsigned int offset,
> -						void *value, const u16 length)
> -{
> -	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
> -				      USB_VENDOR_REQUEST_IN, offset,
> -				      value, length);
> -}
> -

I guess you removed this because it was not actually used anywhere? Just
checking.

-- 
Kalle Valo
