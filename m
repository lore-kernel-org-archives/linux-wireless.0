Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdATKG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:06:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/3] rtlwifi: Download firmware as bytes rather than as dwords
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170119202808.27752-2-Larry.Finger@lwfinger.net>
References: <20170119202808.27752-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170120100648.A7F5F609FD@smtp.codeaurora.org> (sfid-20170120_110711_598294_7170C732)
Date: Fri, 20 Jan 2017 10:06:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The firmware is read from disk as a little-endian byte string. The code
> that loads the firmware into the device transfers it as 4-byte quantities.
> The routines that write multi-byte quantities on BE hardware assume that
> the data are in CPU order, and automatically do the conversion to the LE
> order required by the device. As a result, the firmware is transmitted
> incorrectly. Rather than do multiple byte swaps on the data, the download
> routine is revised to transmit bytes rather than dwords. Although the
> number of I/O operations is increased, the firmware is not often loaded.
> 
> All drivers have the same bug, and use essentially the same code to
> download firmware. These routines have been moved into rtlwifi.
> 
> Some CamelCase variables have been renamed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

3 patches applied to wireless-drivers-next.git, thanks.

89d32c9071aa rtlwifi: Download firmware as bytes rather than as dwords
69d8597e9fe5 rtlwifi: rtl8192cu: Calculate descriptor checksum correctly for BE
106e0deca1ac rtlwifi: rtl8192cu: Convert driver to use common macros

-- 
https://patchwork.kernel.org/patch/9526749/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
