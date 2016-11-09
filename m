Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbcKIWU7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 17:20:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, security@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mwifiex: printk() overflow with 32-byte SSIDs
References: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
Date: Thu, 10 Nov 2016 00:20:53 +0200
In-Reply-To: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
        (Brian Norris's message of "Tue, 8 Nov 2016 18:28:24 -0800")
Message-ID: <87h97guwfu.fsf@kamboji.qca.qualcomm.com> (sfid-20161109_232120_487065_CE1E2082)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

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

I'm planning to push this to 4.9 if no objections.

-- 
Kalle Valo
