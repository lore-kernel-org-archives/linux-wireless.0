Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbdHGMiN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:38:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: "\,Tony Lindgren" <tony@atomide.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel\@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v5] wlcore: add missing nvs file name info for wilink8
References: <1502090869-8833-1-git-send-email-eyalr@ti.com>
        <8665E2433BC68541A24DFFCA87B70F5B3641E25B@DFRE01.ent.ti.com>
Date: Mon, 07 Aug 2017 15:38:07 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B3641E25B@DFRE01.ent.ti.com>
        (Eyal Reizer's message of "Mon, 7 Aug 2017 07:31:51 +0000")
Message-ID: <87wp6flfio.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_143832_586085_32F2A0D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

> The following commits:
> c815fde wlcore: spi: Populate config firmware data
> d776fc8 wlcore: sdio: Populate config firmware data

It's recommended to use 12 chars when abbreviating commit ids so the
format should be this:

c815fdebef44 wlcore: spi: Populate config firmware data
d776fc86b82f wlcore: sdio: Populate config firmware data

> Populated the nvs entry for wilink6 and wilink7 only while it is
> still needed for wilink8 as well.
> This broke user space backward compatibility when upgrading from older
> kernels, as the alternate mac address would not be read from the nvs that is
> present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin)
> causing mac address change of the wlan interface.
>
> This patch fix this and update the structure field with the same default
> nvs file name that has been used before.
>
> In addition, some distros hold a default wl1271-nvs.bin in the file
> system with a bogus mac address (deadbeef...) that for a wl18xx device
> also overrides the mac address that is stored inside the device.
> Warn users about this bogus mac address and use a random mac instead
>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

It's always good to have a fixes line(s) and specify which stable
versions should have the fix. As the commit were first in v4.9-rc1
that's the first version we want this to be included:

Fixes: c815fdebef44 ("wlcore: spi: Populate config firmware data")
Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
Cc: <stable@vger.kernel.org> # 4.9+

But if you don't submit a new version I can fix the commit log during
commit.

-- 
Kalle Valo
