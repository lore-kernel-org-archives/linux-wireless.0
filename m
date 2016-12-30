Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbcL3N5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:57:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Fix alignment issues
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161228214004.6309-1-Larry.Finger@lwfinger.net>
References: <20161228214004.6309-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20161230135709.C8A4361481@smtp.codeaurora.org> (sfid-20161230_145718_422730_0630DFAB)
Date: Fri, 30 Dec 2016 13:57:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The addresses of Wlan NIC registers are natural alignment, but some
> drivers have bugs. These are evident on platforms that need natural
> alignment to access registers.  This change contains the following:
>  1. Function _rtl8821ae_dbi_read() is used to read one byte from DBI,
>     thus it should use rtl_read_byte().
>  2. Register 0x4C7 of 8192ee is single byte.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

40b368af4b75 rtlwifi: Fix alignment issues

-- 
https://patchwork.kernel.org/patch/9490651/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
