Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33224 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbcL3NxI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:53:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH 14/14 V2] rtlwifi: Remove some redundant code
References: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
        <20161215182310.13713-15-Larry.Finger@lwfinger.net>
Date: Fri, 30 Dec 2016 15:53:03 +0200
In-Reply-To: <20161215182310.13713-15-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Thu, 15 Dec 2016 12:23:10 -0600")
Message-ID: <87ful5jzgg.fsf@purkki.adurom.net> (sfid-20161230_145312_153105_3797BFF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> The symbol DBG_EMERG is no longer used and is removed.
>
> In a number of places, the code has redundant messages. For example, if
> the failure for the firmware to run is logged, it is not necessary to
> log that the firmware has been started. In addition, extraneous braces are
> removed.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

[...]

> --- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/debug.h
> +++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/debug.h
> @@ -36,7 +36,7 @@
>   *unexpected HW behavior, HW BUG
>   *and so on.
>   */
> -#define DBG_EMERG			0
> +/*#define DBG_EMERG			0 */

You are not really removing, just commenting it out :) But this is good
enough for me, if you really want to remove it submit a followup patch.

-- 
Kalle Valo
