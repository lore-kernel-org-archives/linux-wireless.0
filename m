Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44488 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031196AbeEXOYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 10:24:43 -0400
Date: Thu, 24 May 2018 07:24:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: kvalo@codeaurora.org, nsekhar@ti.com,
        linux-wireless@vger.kernel.org, Eyal Reizer <eyalr@ti.com>
Subject: Re: [PATCH] wlcore: sdio: check for valid platform device data
 before suspend
Message-ID: <20180524142440.GY77025@atomide.com> (sfid-20180524_162717_124739_C5674C47)
References: <1527161730-9044-1-git-send-email-eyalr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527161730-9044-1-git-send-email-eyalr@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eyal Reizer <eyalreizer@gmail.com> [180524 11:38]:
> the wl pointer can be null In case only wlcore_sdio is probed while
> no WiLink module is successfully probed, as in the case of mounting a
> wl12xx module while using a device tree file configured with wl18xx
> related settings.
> In this case the system was crashing in wl1271_suspend() as platform
> device data is not set.
> Make sure wl the pointer is valid before using it.

Just checking.. It seems like this fix is separate from the PM
runtime conversion, right?

> Signed-off-by: Eyal Reizer <eyalr@ti.com>mamai

Looks like you have some extra characters ^^^^^ here.

Regards,

Tony
