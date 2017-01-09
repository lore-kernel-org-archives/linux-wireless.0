Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761306AbdAIOpY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 09:45:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC] ath9k: move RELAY and DEBUG_FS to ATH9K[_HTC]_DEBUGFS
References: <20170106154852.22735-1-chunkeey@googlemail.com>
Date: Mon, 09 Jan 2017 16:45:14 +0200
In-Reply-To: <20170106154852.22735-1-chunkeey@googlemail.com> (Christian
        Lamparter's message of "Fri, 6 Jan 2017 16:48:52 +0100")
Message-ID: <87k2a4z405.fsf@kamboji.qca.qualcomm.com> (sfid-20170109_154535_550501_F45D23B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> Currently, the common ath9k_common module needs to have a
> dependency on RELAY and DEBUG_FS in order to built. This
> is usually not a problem. But for RAM and FLASH starved
> AR71XX devices, every little bit counts.
>
> This patch adds a new symbol CONFIG_ATH9K_COMMON_DEBUG
> which makes it possible to drop the RELAY and DEBUG_FS
> dependency there and move it to ATH_(HTC)_DEBUGFS.
>
> Note: The shared FFT/spectral code (which is the only user
> of the relayfs in ath9k*) needs DEBUG_FS to export the relayfs
> interface to dump the data to userspace. So it makes no sense
> to have the functions compiled in, if DEBUG_FS is not there.
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Here are some numbers for my WD Range Extender (AR7370 with a AR9300):
> For both configurations MAC80211_DEBUGFS and ATH_DEBUG is disabled.
> (if they are enabled, there should be no change). All sizes are in
> bytes. And I only test with or without the patch applied.
>
> module                 | file size | .text size |
> ath9k_common.ko (w/o)  |     32208 |      12832 |
> ath9k_common.ko (with) |     12204 |       3456 |
>
> Note: The kernel with the patch, doesn't need RELAY support anymore.
> Therefore it shrinks a bit as well.
>
>               | lzma uimage size | .text size |
> kernel (w/o)  |          1181777 |    3004592 |
> kernel (with) |          1179666 |    2999448 |
>
> If anyone wants to play with it, I made a test-patch For LEDE [0].
> Just remember to disable CONFIG_PACKAGE_MAC80211_DEBUGFS and
> CONFIG_PACKAGE_ATH_DEBUG.
>
> There are more ways to do this. Let's hear if there's support for
> it or not. The main motivation was that relayfs can be very costly
> on the RAM as well (on ath10k in can eat like 4MiB with VM 
> debugging etc...).
>
> [0] <https://github.com/chunkeey/apm82181-lede/commit/5ef8d4e6497b0b41f0c562650347251e96d73ec8>

No complaints so far so I guess people don't have any issues :) Please
submit this as a proper patch and if there are no comments I'll apply
it.

-- 
Kalle Valo
