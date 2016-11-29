Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757958AbcK2Pdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:33:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Fix enter/exit power_save
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161126204335.12847-1-Larry.Finger@lwfinger.net>
References: <20161126204335.12847-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20161129153331.6F4856134E@smtp.codeaurora.org> (sfid-20161129_163341_847755_49C897F1)
Date: Tue, 29 Nov 2016 15:33:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In commit a5ffbe0a1993 ("rtlwifi: Fix scheduling while atomic bug") and
> commit a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter()
> to use work queue"), an error was introduced in the power-save routines
> due to the fact that leaving PS was delayed by the use of a work queue.
> 
> This problem is fixed by detecting if the enter or leave routines are
> in interrupt mode. If so, the workqueue is used to place the request.
> If in normal mode, the enter or leave routines are called directly.
> 
> Fixes: a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter() to use work queue")
> Reported-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

ba9f93f82aba rtlwifi: Fix enter/exit power_save

-- 
https://patchwork.kernel.org/patch/9448539/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
