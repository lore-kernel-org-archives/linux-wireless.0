Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdA1HLx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 02:11:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl_usb: Fix for URB leaking when doing ifconfig up/down
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170126172504.17492-1-Larry.Finger@lwfinger.net>
References: <20170126172504.17492-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Michael Schenk <michael.schenk@albis-elcon.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20170128071152.8625960A55@smtp.codeaurora.org> (sfid-20170128_081204_214267_557A5C83)
Date: Sat, 28 Jan 2017 07:11:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Michael Schenk <michael.schenk@albis-elcon.com>
> 
> In the function rtl_usb_start we pre-allocate a certain number of urbs
> for RX path but they will not be freed when calling rtl_usb_stop. This
> results in leaking urbs when doing ifconfig up and down. Eventually,
> the system has no available urbs.
> 
> Signed-off-by: Michael Schenk <michael.schenk@albis-elcon.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

575ddce05077 rtlwifi: rtl_usb: Fix for URB leaking when doing ifconfig up/down

-- 
https://patchwork.kernel.org/patch/9539941/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
