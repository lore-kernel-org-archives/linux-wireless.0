Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25181 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdAMNai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:30:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: move RELAY and DEBUG_FS to ATH9K[_HTC]_DEBUGFS
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170109174852.20114-1-chunkeey@googlemail.com>
References: <20170109174852.20114-1-chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <c81df64bfa14419db793429c857b129f@euamsexm01a.eu.qualcomm.com> (sfid-20170113_143043_914910_37D8E919)
Date: Fri, 13 Jan 2017 14:29:53 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
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

Patch applied to ath-next branch of ath.git, thanks.

1077ec472df4 ath9k: move RELAY and DEBUG_FS to ATH9K[_HTC]_DEBUGFS

-- 
https://patchwork.kernel.org/patch/9505653/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
