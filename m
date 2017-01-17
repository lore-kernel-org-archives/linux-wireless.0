Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38742 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdAQMGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 07:06:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: debugfs: Fix (sometimes) off-by-1 SSID print
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170109233350.134036-1-briannorris@chromium.org>
References: <20170109233350.134036-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170117120350.5CE4E607CE@smtp.codeaurora.org> (sfid-20170117_130633_786550_71B7A441)
Date: Tue, 17 Jan 2017 12:03:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> Similar to commit fcd2042e8d36 ("mwifiex: printk() overflow with 32-byte
> SSIDs"), we failed to account for the existence of 32-char SSIDs in our
> debugfs code. Unlike in that case though, we zeroed out the containing
> struct first, and I'm pretty sure we're guaranteed to have some padding
> after the 'ssid.ssid' and 'ssid.ssid_len' fields (the struct is 33 bytes
> long).
> 
> So, this is the difference between:
> 
>   # cat /sys/kernel/debug/mwifiex/mlan0/info
>   ...
>   essid="0123456789abcdef0123456789abcdef "
>   ...
> 
> and the correct output:
> 
>   # cat /sys/kernel/debug/mwifiex/mlan0/info
>   ...
>   essid="0123456789abcdef0123456789abcdef"
>   ...
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

6183468a23fc mwifiex: debugfs: Fix (sometimes) off-by-1 SSID print

-- 
https://patchwork.kernel.org/patch/9506069/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
