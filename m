Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933373AbcKQLSQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:18:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: printk() overflow with 32-byte SSIDs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
References: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, security@kernel.org,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>
Message-Id: <20161117111816.227EE61626@smtp.codeaurora.org> (sfid-20161117_121837_238380_BDC28C75)
Date: Thu, 17 Nov 2016 11:18:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> SSIDs aren't guaranteed to be 0-terminated. Let's cap the max length
> when we print them out.
> 
> This can be easily noticed by connecting to a network with a 32-octet
> SSID:
> 
> [ 3903.502925] mwifiex_pcie 0000:01:00.0: info: trying to associate to
> '0123456789abcdef0123456789abcdef <uninitialized mem>' bssid
> xx:xx:xx:xx:xx:xx
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Cc: <stable@vger.kernel.org>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers.git, thanks.

fcd2042e8d36 mwifiex: printk() overflow with 32-byte SSIDs

-- 
https://patchwork.kernel.org/patch/9418369/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
